#!/bin/bash

rm -r _minted-paper paper.aux paper.bbl paper.blg paper.log paper.out paper.synctex.gz build.log >> /dev/null 2>&1
set -ex

# Build the paper
docker rm -f latex || true
docker run \
  --name latex \
  --entrypoint=/bin/bash \
  -v `pwd`/:/mnt \
  ivotron/texlive_v2:latest -c \
    "cd /mnt ; \
     pdflatex -synctex=1 -interaction=nonstopmode -shell-escape paper && \
     bibtex paper && \
     pdflatex -synctex=1 -interaction=nonstopmode -shell-escape paper && \
     pdflatex -synctex=1 -interaction=nonstopmode -shell-escape paper" &> build.log

ERR=$?
if [ $ERR != "0" ] ; then
  echo "ERROR: $ERR"
  cat build.log
  exit 1
fi

set +e
rm -r _minted-paper paper.aux paper.bbl paper.blg paper.log paper.out paper.synctex.gz build.log >> /dev/null 2>&1

echo "SUCCESS"
exit 0
