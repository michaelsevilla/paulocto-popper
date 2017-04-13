#!/bin/bash

MOUNT="/mnt/plfs"
BACKE="posix:///mnt/pstore1"

if [ ! -z $1 ]; then
  MOUNT="$1"
fi
if [ ! -z $2 ]; then
  BACKE="$2"
fi

echo "- global_params:"        >  /etc/plfsrc
echo "  threadpool_size: 64"   >> /etc/plfsrc
echo "- mount_point: $MOUNT"   >> /etc/plfsrc
echo "  workload: shared_file" >> /etc/plfsrc
echo "  backends:"             >> /etc/plfsrc
echo "    - location: $BACKE"  >> /etc/plfsrc

echo "-- PLFS configuration"
cat /etc/plfsrc

echo "-- Setup directories"
plfs_check_config -mkdir

echo "-- Mount it"
plfs -o -f -d $MOUNT
