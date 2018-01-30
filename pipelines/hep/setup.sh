#!/bin/bash
SRC="/tmp"
RUN="docker run --rm -it \
      -w /root \
      -v `pwd`:/scripts \
      -v $SRC:/root \
      --entrypoint=root \
      rootproject/root-ubuntu16 -b -q"
INPUT="/Users/msevilla/Desktop/root/2AC36403-8E7E-E711-A599-02163E01366D.root"
TRACE="/Users/msevilla/Desktop/root/cmsdump.outerr"

set -ex

echo "==> Cloning repository..."
#git clone --recursive https://github.com/reza-nasirigerdeh/root.git $SRC/root

echo "==> Copying input file to repository"
ROOTFILE=`basename $INPUT`
CMSDFILE=`basename $TRACE`
#cp $INPUT $SRC/$ROOTFILE
#cp $TRACE $SRC/$CMSDFILE

echo "==> Generating input file..."
#$RUN -b -q .x \
#  root/src/translate_offsets_to_baskets.cpp\(\"2AC36403-8E7E-E711-A599-02163E01366D.root\",\"\",\"full-path\",\"cmsdump.outerr\"\)

echo "==> Cleaning input file..."
grep  -v "READ" $SRC/translated_baskets.txt > $SRC/branchListFile.txt
#sed -i '1,2d' $SRC/branchListFile.txt

echo "==> DONE!"
