#!/bin/bash

echo "Setup 1: read from the ROOT file"
.x read_baskets_from_ROOT.cpp ("./2AC36403-8E7E-E711-A599-02163E01366D.root")

echo "Setup 3: read from namespace"
.x write_baskets_to_file.cpp("./2AC36403-8E7E-E711-A599-02163E01366D.root")
.x read_baskets_from_file.cpp("branchListFile.txt")


# TODO: figure out the timing
# TODO: get read_baskets_from_ROOT to work
# TODO: get these scripts to setup everything
# TODO: deploy on cloudlab and run
