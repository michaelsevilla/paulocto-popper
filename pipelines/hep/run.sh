#!/bin/bash
# This file should contain the series of steps that are required to execute 
# the experiment. Any non-zero exit code will be interpreted as a failure
# by the 'popper check' command.
set -ex

# if you know Ansible and Docker, the below should make sense
# - we attach ceph-ansible to root because they expect us to be in that dir
ROOT=`dirname $PWD | xargs dirname`
NETW="--net host -v $HOME/.ssh:/root/.ssh"
DIRS="-v `pwd`:/popper \
      -v $ROOT/ansible/ceph:/root \
      -v $ROOT/ansible/srl:/popper/ansible/roles/srl \
      -w /root "
ANSB="-v `pwd`/ansible/group_vars/:/root/group_vars \
      -v `pwd`/hosts:/etc/ansible/hosts \
      -v `pwd`/ansible/ansible.cfg:/etc/ansible/ansible.cfg \
      -v /mnt/disk:/mnt/disk \
      -e ANSIBLE_CONFIG=/etc/ansible/ansible.cfg"
CODE="-v `pwd`/ansible/ceph.yml:/root/ceph.yml \
      -v `pwd`/ansible/monitor.yml:/root/monitor.yml"
WORK="-v `pwd`/ansible/workloads:/workloads"
ARGS="--forks 50 --skip-tags package-install,with_pkg"
VARS="-e @/popper/vars.yml \
      -e @/popper/ansible/vars.yml \
      -i /etc/ansible/hosts"
DOCKER="docker run -it --rm $NETW $DIRS $ANSB $CODE $WORK michaelsevilla/ansible $ARGS $VARS"

# debug mode
if [ ! -z $1 ]; then
  docker run -it --rm $NETW $DIRS $ANSB $CODE $WORK --entrypoint=ansible michaelsevilla/ansible $VARS $@
  exit
fi

rm -fr results || true
mkdir results

for run in `seq 0 5`; do
  ./teardown.sh
  $DOCKER ceph.yml \
    /workloads/hep_ext4.yml \
    /workloads/hep_cephfs.yml
  mv results results-run$run
done

exit 0
