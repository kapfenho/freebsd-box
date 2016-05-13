#!/bin/sh -x

# create new zroot

set -o errexit

sysctl kern.geom.debugflags=0x10

gpart destroy -F    ada0
gpart create -s gpt ada0
gpart add -s 512k -a 1m -t freebsd-boot -l ssd0boot ada0
gpart add -s  16g -a 1m -t freebsd-swap -l ssd0swap ada0
gpart add -s 200g -a 1m -t freebsd-zfs  -l ssd0zfs0 ada0
gpart bootcode -b /boot/pmbr -p /boot/gptzfsboot -i 1 ada0

gpart destroy -F    ada1
gpart create -s gpt ada1
gpart add -s 512k -a 1m -t freebsd-boot -l ssd1boot ada1
gpart add -s  16g -a 1m -t freebsd-swap -l ssd1swap ada1
gpart add -s 200g -a 1m -t freebsd-zfs  -l ssd1zfs0 ada1
gpart bootcode -b /boot/pmbr -p /boot/gptzfsboot -i 1 ada1

gnop create -S 4096 /dev/gpt/ssd0zfs0
gnop create -S 4096 /dev/gpt/ssd1zfs0

zpool create -f \
  -o altroot=/mnt \
  -o cachefile=/csave/zroot.cache \
  -O canmount=off \
  -m none \
  zroot \
    /dev/gpt/ssd0zfs0.nop \
    /dev/gpt/ssd1zfs0.nop

zfs set checksum=fletcher4 zroot
zfs set atime=off          zroot
