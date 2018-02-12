#!/bin/bash
# Author: Michael Sevilla
# Date: 10-8--17
# Description: all this does is install Docker

set -ex

# the below is adapted from:
# - https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/
sudo apt-get update -y
sudo apt-get install -y \
    vim \
    screen \
    gdisk \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update -y
sudo apt-get install -y docker-ce

# enable passwordless login
sudo sed -i "s/#   StrictHostKeyChecking ask/StrictHostKeyChecking no/g" /etc/ssh/ssh_config 

# setup an alias (for MPI related jobs)
#sudo ifconfig eth2 up || true
#ip=`ifconfig | grep 10.10.1. | awk '{print $2}' | sed 's/addr://g'`
#sudo ifconfig eth2:0 $ip up
#echo $HOSTNAME | sed "s/\./ /g" | awk '{print $1}' | xargs sudo hostname
