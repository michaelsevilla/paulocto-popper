#!/bin/bash

cat hosts | grep ADD >> /dev/null
if [ $? -eq 0 ]; then
  echo "ERROR: please change the hosts file"
  exit 1
fi

echo "let's go!"
set -ex

cp hosts baseliner/site/hosts
cp ceph.conf baseliner/site/group_vars/all
cd baseliner
./deploy.sh
./baseliner.sh
cd -
