#!/bin/bash

SRC="/mnt/disk/root"
RUN="docker run --rm -it \
      -w /root \
      -v `pwd`:/scripts \
      -v $SRC:/root \
      --entrypoint=root \
      rootproject/root-ubuntu16 -b -q"

rm -rf $SRC/results.txt >> /dev/null 2>&1

set -ex

for run in 0 1 2; do
  echo "Setup 1: read from the ROOT file"
  $RUN .x root/src/read_baskets_from_file_hep_method.cpp\(\"2AC36403-8E7E-E711-A599-02163E01366D.root\",\"branchListFile.txt\"\)
  
  echo "Setup 3: read from namespace"
  sudo rm -rf $SRC/namespace >> /dev/null || true
  $RUN .x root/src/write_baskets_to_file.cpp\(\"2AC36403-8E7E-E711-A599-02163E01366D.root\",\"\/root\/namespace\"\)
  $RUN .x root/src/read_baskets_from_file_our_method.cpp\(\"branchListFile.txt\"\)
done

mv $SRC/results.txt $SRC/results-ext4.txt
