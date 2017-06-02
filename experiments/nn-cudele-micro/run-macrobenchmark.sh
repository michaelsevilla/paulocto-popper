#!/bin/bash

set -ex
NFILES=98000

# setup the docker command
RUN="docker run -it --rm --net host -v $HOME/.ssh:/root/.ssh -w /root"
ANSIBLE="michaelsevilla/ansible --forks 50 --skip-tags package-install,with_pkg"
CEPH_ANSIBLE="$RUN -v `pwd`/site/roles/ceph-ansible:/root $ANSIBLE"
SRL_ANSIBLE="$RUN -v `pwd`/site:/root $ANSIBLE"

for nclients in "all"; do
  site="stream"
  for run in 0; do
    for job in "creates-touchstream"; do
      for decoupled in 0 1; do
        # configure ceph and setup results directory
        results="$job-$nclients-decoupled-$decoupled/run$run"
        mkdir -p results/$results/logs || true
        cp site/* site/roles/ceph-ansible || true
        cp site/configs/${site}.yml site/group_vars/all
        cp -r site/group_vars site/roles/ceph-ansible/
        cp inventory/${nclients} site/hosts
        cp inventory/${nclients} site/roles/ceph-ansible/hosts
  
        # cleanup and start ceph
        for k in `seq 0 3`; do
          $SRL_ANSIBLE cleanup.yml || true
        done
        $SRL_ANSIBLE cleanup.yml
        $CEPH_ANSIBLE ceph.yml #cephfs.yml
        $SRL_ANSIBLE ceph_pgs.yml ceph_monitor.yml ceph_wait.yml
  
        # run job
        ./ansible-playbook.sh -e site=$results -e nfiles=$NFILES ../workloads/setup_mdtest.yml
        if [ $decoupled -eq 1 ]; then
          ./ansible-playbook.sh -e site=$results -e nfiles=$NFILES ../workloads/decouple.yml
        fi
        ./ansible-playbook.sh -e site=$results -e nfiles=$NFILES -e drop_delay=30 ../workloads/${job}.yml
        ./ansible-playbook.sh -e site=$results collect.yml
      done
    done
  done
done

mv results results-macrobenchmark
