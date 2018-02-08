#!/bin/bash

set -ex
cd ../results-monitor0
for i in `ls *.tar.gz`; do
  tar xzf $i
done

# prepare as a csv
#   "tmp/graphite/whisper/node-4/nettotals/kbout.wsp" \
#   "tmp/graphite/whisper/node-4/nettotals/kbin.wsp" \
 
   #"tmp/graphite/whisper/node-4/mds_server/handle_client_request.wsp" \
   #"tmp/graphite/whisper/node-4/cpuload/avg1.wsp" \
   #"tmp/graphite/whisper/job/cephfs.wsp" \
   #"tmp/graphite/whisper/job/ext4.wsp" \
   #"tmp/graphite/whisper/job/fpb_cephfs.wsp" \
   #"tmp/graphite/whisper/node-0/cpuload/avg1.wsp" \
   #"tmp/graphite/whisper/node-4/cputotals/user.wsp" \
   #"tmp/graphite/whisper/node-4/cputotals/sys.wsp" \
   #"tmp/graphite/whisper/node-4/cputotals/wait.wsp" \
   #"tmp/graphite/whisper/node-4/nettotals/kbout.wsp" \
   #"tmp/graphite/whisper/node-4/nettotals/kbin.wsp" \
for m in \
   "tmp/graphite/whisper/node-4/mds_server/req_create.wsp" \
   "tmp/graphite/whisper/node-4/mds_server/req_mkdir.wsp" \
   "tmp/graphite/whisper/node-4/mds_server/req_open.wsp" \
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
  mv `basename $m`.out `basename $m`.out
done
exit

for m in \
   "tmp/graphite/whisper/node-0/nettotals/kbout.wsp" \
   "tmp/graphite/whisper/node-0/nettotals/kbin.wsp" \
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
  mv `basename $m`.out node-0-`basename $m`.out
done



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
