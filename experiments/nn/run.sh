#!/bin/bash

set -ex

# setup the docker command
RUN="docker run -it --rm --net host -v $HOME/.ssh:/root/.ssh -w /root"
ANSIBLE="michaelsevilla/ansible --forks 50 --skip-tags package-install,with_pkg"
CEPH_ANSIBLE="$RUN -v `pwd`/site/roles/ceph-ansible:/root $ANSIBLE"
SRL_ANSIBLE="$RUN -v `pwd`/site:/root $ANSIBLE"

for nclients in `ls inventory`; do
  site="journal-cache"
  for job in "creates"; do  #"creates-touchstream" "creates-stat" "creates-touch"; do
     # configure ceph and setup results directory
     results="$job-$nclients/run$run"
     mkdir -p results/$results/logs || true
     cp site/* site/roles/ceph-ansible || true
     cp site_confs/${site}.yml site/group_vars/all
     cp -r site/group_vars site/roles/ceph-ansible/
     cp inventory/${nclients} site/hosts
     cp inventory/${nclients} site/roles/ceph-ansible/hosts

     # cleanup and start ceph
     $SRL_ANSIBLE cleanup.yml
     $CEPH_ANSIBLE ceph.yml cephfs.yml
     $SRL_ANSIBLE ceph_pgs.yml ceph_monitor.yml ceph_wait.yml

     # warmup and get baseline
     for i in `seq 0 2`; do
       ./ansible-playbook.sh -e site=$results -e nfiles=100000 ../workloads/warmup.yml
     done

     # run job
     ./ansible-playbook.sh -e site=$results -e nfiles=98000 -e drop_delay=30 ../workloads/${job}.yml
     ./ansible-playbook.sh -e site=$results collect.yml
  done
done
