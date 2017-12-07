#!/bin/bash

docker run --rm -it \
  -v ~/Desktop/:/root \
  -w /root \
 rootproject/root-ubuntu16
  #--entrypoint=/bin/bash \
