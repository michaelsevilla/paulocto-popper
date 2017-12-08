#!/bin/bash
docker stop plfs-dev >> /dev/null 2>&1
docker rm plfs-dev   >> /dev/null 2>&1
set -x
#for i in 1 2 3 4 5 6; do
#  docker run -it --rm \
#    --net host \
#    --name plfs-dev \
#    -v /dev:/dev \
#    -v `pwd`:/root \
#    -w /root \
#    --privileged \
#    --entrypoint=/bin/bash \
#    michaelsevilla/plfs \
#    -c "dot -Tpng -o tree_$i.png tree_namespace_$i.txt.dot"
#  
#  cp tree_$i.png ../../paper/figures/tree_$i_plfs.png 
#done

docker run -it --rm \
  --net host \
  --name plfs-dev \
  -v /dev:/dev \
  -v `pwd`:/root \
  -w /root \
  --privileged \
  --entrypoint=/bin/bash \
  michaelsevilla/plfs \
  -c "dot -Tpng -o tree_hep.png tree_hep.dot"

