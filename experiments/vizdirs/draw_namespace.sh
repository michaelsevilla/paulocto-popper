#!/bin/bash
set -x
docker stop plfs-dev >> /dev/null 2>&1
docker rm plfs-dev   >> /dev/null 2>&1
docker run -it \
  --net host \
  --name plfs-dev \
  -v /dev:/dev \
  -v `pwd`:/root \
  -w /root \
  --privileged \
  --entrypoint=/bin/bash \
  michaelsevilla/plfs \
  -c "dot -Tpng -o tree.png tree.dot"

set +x
if [ $? == 0 ]; then
  echo "SUCCESS"
else
  echo "FAIL"
fi
