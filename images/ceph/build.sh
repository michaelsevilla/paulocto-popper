#!/bin/bash

set -ex

# create the image
SRC="/tmp/ceph-daemon"
mkdir $SRC || true
cd $SRC

# pull base image from ceph (we will layer on top of this)
wget https://raw.githubusercontent.com/systemslab/docker-cephdev/master/aliases.sh
. aliases.sh
rm aliases.sh
docker pull ceph/daemon:tag-build-master-jewel-ubuntu-14.04
docker tag ceph/daemon:tag-build-master-jewel-ubuntu-14.04 ceph/daemon:jewel
#docker pull cephbuilder/ceph:latest

dmake \
  -e SHA1_OR_REF="72cf7325446c935584a99db59bd0766ee72a38b2" \
  -e GIT_URL="https://github.com/michaelsevilla/ceph.git" \
  -e BUILD_THREADS=`grep processor /proc/cpuinfo | wc -l` \
  -e CONFIGURE_FLAGS="-DWITH_TESTS=OFF" \
  -e RECONFIGURE="true" \
  cephbuilder/ceph:latest build-cmake
cd -

docker tag ceph-72cf7325446c935584a99db59bd0766ee72a38b2 ceph/daemon:72cf732
docker build -t tmp .
docker tag tmp piha.soe.ucsc.edu:5000/ceph/daemon:72cf732
