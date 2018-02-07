#!/bin/bash

set -ex
cd ../results-monitor
for i in `ls *.tar.gz`; do
  tar xzf $i
done

# prepare as a csv
#for m in \
#   "tmp/graphite/whisper/node-4/mds_server/req_create.wsp" \
#   "tmp/graphite/whisper/node-4/mds_server/req_readdir.wsp" \
#   "tmp/graphite/whisper/node-4/mds_server/req_lookup.wsp" \
#   "tmp/graphite/whisper/node-4/mds_server/req_unlink.wsp" \
#   "tmp/graphite/whisper/node-4/mds_server/req_rmdir.wsp" \
#   "tmp/graphite/whisper/node-4/cputotals/user.wsp" \
#   "tmp/graphite/whisper/node-4/cpuload/avg1.wsp" \
#   "tmp/graphite/whisper/node-4/nettotals/kbout.wsp" \
#   "tmp/graphite/whisper/node-4/nettotals/kbin.wsp" \
#  ; do
#for m in "tmp/graphite/whisper/node-4/mds_server/req_mkdir.wsp"; do
  #"tmp/graphite/whisper/job/cephfs.wsp" \
  #"tmp/graphite/whisper/job/ext4.wsp" \
  #"tmp/graphite/whisper/job/fpb_cephfs.wsp" \
  #"tmp/graphite/whisper/node-4/mds_server/req_open.wsp" \
  #"tmp/graphite/whisper/node-4/mds_server/req_getattr.wsp" \
  #"tmp/graphite/whisper/node-5/nettotals/kbout.wsp" \
  #"tmp/graphite/whisper/node-5/nettotals/kbin.wsp" \
for m in \
  "tmp/graphite/whisper/node-4/mds_server/handle_client_request.wsp" \
  ; do
  # dump trace
  docker run \
    -v `pwd`/tmp:/tmp \
    --entrypoint=whisper-dump.py \
    michaelsevilla/graphite \
    $m > `basename $m`.out

  # clean trace to prepare for pandas
  docker run \
    -v `pwd`:/root \
    --entrypoint=/bin/bash \
    michaelsevilla/graphite \
    -c "sed -i \"s/:/,/g\" /root/`basename ${m}`.out"
done
exit

count=0
for m in \
  "tmp/graphite/whisper/node-1/diskinfo/writekbs/sdc.wsp" \
  "tmp/graphite/whisper/node-2/diskinfo/writekbs/sdc.wsp" \
  "tmp/graphite/whisper/node-3/diskinfo/writekbs/sdc.wsp" \
  ; do

  count=$((count+1))
  # dump trace
  docker run \
    -v `pwd`/tmp:/tmp \
    --entrypoint=whisper-dump.py \
    michaelsevilla/graphite \
    $m > node$count-`basename $m`.out

  # clean trace to prepare for pandas
  docker run \
    -v `pwd`:/root \
    --entrypoint=/bin/bash \
    michaelsevilla/graphite \
    -c "sed -i \"s/:/,/g\" /root/node$count-`basename ${m}`.out"
done

cd -
