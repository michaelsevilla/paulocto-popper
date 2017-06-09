#!/bin/bash

set -ex

# create the image
SRC="/tmp/ceph-daemon"
GIT="f91680128ef51a85d28019c9afd29109bd178b1c"
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
  -e SHA1_OR_REF="$GIT" \
  -e GIT_URL="https://github.com/michaelsevilla/ceph.git" \
  -e BUILD_THREADS=`grep processor /proc/cpuinfo | wc -l` \
  -e CONFIGURE_FLAGS="-DWITH_TESTS=OFF" \
  -e RECONFIGURE="true" \
  cephbuilder/ceph:latest build-cmake
cd -

docker tag ceph-$GIT ceph/daemon:$GIT
docker build -t tmp .
docker run -it -d -v $SRC:/ceph --name tmp --entrypoint=/bin/bash tmp
docker exec tmp /bin/bash -c "cp /ceph/build/lib/*rados*.so* /usr/lib"
#docker commit --change='ENTRYPOINT ["/entrypoint.sh"]' tmp piha.soe.ucsc.edu:5000/ceph/daemon:$GIT
docker commit --change='ENTRYPOINT ["/entrypoint.sh"]' tmp michaelsevilla/cephdaemon:$GIT
docker rm -f tmp

echo "SUCCESS"
