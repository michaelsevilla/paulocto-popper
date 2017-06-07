#!/bin/bash

set -ex

# setup the docker command
RUN="docker run -it --rm --net host -v $HOME/.ssh:/root/.ssh -w /root"
ANSIBLE="michaelsevilla/ansible --forks 50 --skip-tags package-install,with_pkg"
CEPH_ANSIBLE="$RUN -v `pwd`/site/roles/ceph-ansible:/root $ANSIBLE"
SRL_ANSIBLE="$RUN -v `pwd`/site:/root $ANSIBLE"

# cleanup and start ceph
for i in 0 1 2; do
  for nfiles in 10 100 1000 10000 100000; do
    mkdir -p results/${nfiles}/logs || true
    for stream in "nostream" "stream"; do
      # configure ceph and setup results directory
      cp site/configs/${stream}.yml site/group_vars/all
      cp site/* site/roles/ceph-ansible || true
      cp -r site/group_vars site/roles/ceph-ansible/
      cp site/hosts site/roles/ceph-ansible/hosts

      # setup
      $SRL_ANSIBLE cleanup.yml
      $CEPH_ANSIBLE ceph.yml cephfs.yml
      $SRL_ANSIBLE ceph_pgs.yml ceph_monitor.yml ceph_wait.yml
      
      # benchmark
      ./ansible-playbook.sh -e nfiles=$nfiles -e stream=$stream \
        ../workloads/journal-rpcs.yml ../workloads/journal-vapply.yml
      ./ansible-playbook.sh -e site=$nfiles collect.yml
    done
  done
  mv results results-microbenchmark-run${i}
done
