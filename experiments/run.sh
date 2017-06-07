#!/bin/bash

cat conf/hosts/all | grep ADD >> /dev/null
if [ $? -eq 0 ]; then
  echo "ERROR: please change the hosts file"
  exit 1
fi

echo "let's go!"
set -ex
rm -rf */results* || true

# BASELINE
cp conf/hosts/all baseliner/site/hosts
cp conf/ceph.conf baseliner/site/group_vars/all
cp conf/osds.conf baseliner/site/group_vars/osds
cd baseliner
./deploy.sh
./baseliner.sh
cd -

# N1
cp conf/hosts/* n1/site/inventory/
cp conf/ceph.conf n1/site/group_vars/all
cp conf/osds.conf n1/site/group_vars/osds
cd n1
./run.sh
cd -

# NN
cp conf/hosts/* nn/inventory/
cp conf/ceph.conf nn/site_confs/journal-cache.yml
cp conf/osds.conf nn/site/group_vars/osds
cd nn
./run.sh
cd -

# NN CUDELE MICRO
cp conf/hosts/all nn-cudele/site/hosts
cp conf/hosts/* nn-cudele/inventory/
cp conf/ceph.conf nn-cudele/site/configs/stream.yml
cp conf/ceph-nostream.conf nn-cudele/site/configs/nostream.yml
cp conf/osds.conf nn-cudele/site/group_vars/osds
cd nn-cudele
./run-microbenchmark.sh
./run-macrobenchmark.sh
cd -
