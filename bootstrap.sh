#!/bin/bash

# WARNING: EXECUTE THIS SCRIPT AT YOUR OWN RISK, SINCE IT EXECUTES AS ROOT

# Before this, make sure you have done these:
# 1. Created a root ext4 partition
# 2. Mounted LFS root partition at /mnt/lfs

export LFS=/mnt/lfs

su -        # Execute as root now

mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources
if [ -d "sources" ]; then
    # If we have a 'sources' directory in this directory, we will copy the contents there
    cp sources/*.{xz,bz2,gz,patch} $LFS/sources/
fi
./smart_download.sh

