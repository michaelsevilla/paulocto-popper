#!/bin/bash
set -x
docker stop plfs-dev >> /dev/null 2>&1
docker rm plfs-dev   >> /dev/null 2>&1
docker run -dit \
  --net host \
  --name plfs-dev \
  -v /dev:/dev \
  -v `pwd`:/root \
  --privileged \
  michaelsevilla/plfs \
  /plfs /backend

docker exec plfs-dev /bin/bash -c "echo hi > /plfs/file0"
docker exec plfs-dev /bin/bash -c "echo hi > /plfs/file1"
docker exec plfs-dev /bin/bash -c "echo hi > /plfs/file2"
docker exec plfs-dev /bin/bash -c "/root/parse_tree.sh /backend > /root/tree.dot"

#docker exec $CONTAINER /bin/bash -c "printf $HOSTNAME | dd of=/$MOUNT/vfile.txt bs=1 seek=$((${HOSTNAME//issdm-}*10)) count=20 conv=notrunc"
