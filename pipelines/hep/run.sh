#!/bin/bash

SRC="/tmp"
RUN="docker run --rm -it \
      -w /root \
      -v `pwd`:/scripts \
      -v $SRC:/root \
      --entrypoint=root \
      rootproject/root-ubuntu16 -b -q"

set -ex

echo "Setup 1: read from the ROOT file"
$RUN .x root/src/read_baskets_from_file_hep_method.cpp\(\"2AC36403-8E7E-E711-A599-02163E01366D.root\",\"branchListFile.txt\"\)

echo "Setup 3: read from namespace"
$RUN .x root/src/write_baskets_to_file.cpp\(\"2AC36403-8E7E-E711-A599-02163E01366D.root\"\)
$RUN .x root/src/read_baskets_from_file_our_method.cpp\(\"branchListFile.txt\"\)
