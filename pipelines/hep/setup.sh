#!/bin/bash
SRC="/mnt/disk/root"
RUN="docker run --rm -it \
      -w /root \
      -v `pwd`:/scripts \
      -v $SRC:/root \
      --entrypoint=root \
      rootproject/root-ubuntu16 -b -q"
INPUT="$SRC/2AC36403-8E7E-E711-A599-02163E01366D.root"
TRACE="$SRC/cmsdump.outerr"

if [[ ! -d $SRC ]]; then
  echo "\$SRC directory does not exist"
  exit 1
fi

if [[ ! -f $INPUT ]]; then
  echo "\$INPUT (ROOT file) does not exist"
  exit 1
fi

if [[ ! -f $TRACE ]]; then
  echo "\$TRACE (CMS Dump file) does not exist"
  exit 1
fi

set -ex
sudo chmod 777 -R $SRC
echo "==> Cloning repository..."
git clone --recursive https://github.com/reza-nasirigerdeh/root.git $SRC/root

echo "==> Generating input file..."
$RUN -b -q .x \
  root/src/translate_offsets_to_baskets.cpp\(\"2AC36403-8E7E-E711-A599-02163E01366D.root\",\"\",\"full-path\",\"cmsdump.outerr\"\)

echo "==> Cleaning input file..."
grep  -v "READ" $SRC/translated_baskets.txt > $SRC/branchListFile.txt
sed -i '1,2d' $SRC/branchListFile.txt

echo "==> DONE!"
