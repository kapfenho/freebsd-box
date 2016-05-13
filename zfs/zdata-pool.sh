#!/bin/sh -x

set -o errexit

# dd if=/dev/random of=/root/zarray0.key bs=64 count=1

for d in $(seq 2 5)
do
     gpart destroy -F ada${d} || true
     gpart create -s gpt ada${d} 
     gpart add -l hdd${d}swap -t freebsd-swap -a 1m -s   16g ada${d}
     gpart add -l hdd${d}zfs0 -t freebsd-zfs  -a 1m -s 2560g ada${d}

     # -- check key size 128 and 256 for performance
     # geli init -s 4096 -l 256 -K /root/zarray0.key /dev/gpt/hdd${d}zfs0
     # geli attach -k /root/zarray0.key /dev/gpt/hdd${d}zfs0
done

zpool create zdata raidz1 \
    gpt/hdd2zfs0 \
    gpt/hdd3zfs0 \
    gpt/hdd4zfs0 \
    gpt/hdd5zfs0
