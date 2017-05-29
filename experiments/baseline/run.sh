#!/bin/bash

set -ex

# setup the docker command
RUN="docker run -it --rm --net host -v $HOME/.ssh:/root/.ssh -w /root"
ANSIBLE="michaelsevilla/ansible --forks 50 --skip-tags package-install,with_pkg"
CEPH_ANSIBLE="$RUN -v `pwd`/site/roles/ceph-ansible:/root $ANSIBLE"
SRL_ANSIBLE="$RUN -v `pwd`/site:/root $ANSIBLE"

# cleanup and start ceph
rm -fr results/* || true
mkdir -p results/logs || true

# configure ceph and setup results directory
cp site/configs/base.yml site/group_vars/all
cp site/* site/roles/ceph-ansible || true
cp -r site/group_vars site/roles/ceph-ansible/
cp site/inventory/6client site/hosts
cp site/hosts site/roles/ceph-ansible/hosts

# setup
$SRL_ANSIBLE cleanup.yml
$CEPH_ANSIBLE ceph.yml cephfs.yml
$SRL_ANSIBLE ceph_pgs.yml ceph_monitor.yml ceph_wait.yml
 
# benchmark
for i in 6; do
  cp site/inventory/${i}client site/hosts
  cp site/hosts site/roles/ceph-ansible/hosts
  ./ansible-playbook.sh -e nfiles=${i} ../workloads/plfs.yml
done

#./ansible-playbook.sh collect.yml
##mv results results-run${i}
