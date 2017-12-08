#!/bin/bash

docker run --rm -it \
  -v ~/Desktop/:/root \
  -w /root \
 --entrypoint=/bin/bash \
 rootproject/root-ubuntu16 
#-c "root ./2AC36403-8E7E-E711-A599-02163E01366D.root"
