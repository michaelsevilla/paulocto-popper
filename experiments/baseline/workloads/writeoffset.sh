#!/bin/bash

CONTAINER="plfs"
if [ ! -z $1 ]; then
  CONTAINER=$1
fi

MOUNT="/plfs"
if [ !-z $2 ]; then
  MOUNT=$2
fi

docker exec $CONTAINER /bin/bash -c "printf $HOSTNAME | dd of=/$MOUNT/vfile.txt bs=1 seek=$((${HOSTNAME//issdm-}*10)) count=20 conv=notrunc"
