#!/bin/bash

if [ -z $SRC ]; then
  echo "Please tell me where the source code is by populating \$SRC"
  exit
fi

echo "Setup 3: read from namespace"
docker run --rm -it \
  -w /root \
  -v `pwd`:/scripts \
  -v $SRC:/root \
  --entrypoint=root \
  rootproject/root-ubuntu16
  -b -q .x root/src/read_baskets_from_file.cpp\(\"branchListFileTest.txt\"\)


exit 
echo "Setup 1: read from the ROOT file"
.x read_baskets_from_ROOT.cpp ("./2AC36403-8E7E-E711-A599-02163E01366D.root")

.x write_baskets_to_file.cpp("./2AC36403-8E7E-E711-A599-02163E01366D.root")
.x read_baskets_from_file.cpp("branchListFile.txt")


# TODO: figure out the timing
# TODO: get read_baskets_from_ROOT to work
# TODO: get these scripts to setup everything
# TODO: deploy on cloudlab and run
