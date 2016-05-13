#!/bin/sh -x

set -o errexit
set -o nounset

oldpool=zroot
newpool=nroot

zpool create -o cachefile=/csave/$newpool.cache $newpool gpt/newdisk

zfs snapshot -r $oldpool@shrink
zfs send -vR $oldpool@shrink | zfs receive -vFd $newpool
zfs destroy -r $oldpool@shrink
zfs destroy -r $newpool@shrink

zpool set bootfs=$newpool/ROOT/default $newpool

exit 0

# manual steps

cp /csave/$newpool.cache /csave/${newpool}1.cache
zpool export $newpool
zpool import -c /csave/${newpool}1.cache -R /mnt $newpool
# setting mountpoint does not work
# zfs set mountpoint=/ $newpool/ROOT/default
cp /csave/${newpool}1.cache /mnt/boot/zfs/zpool.cache
# now edit:
# - /mnt/etc/fstab
# - /mnt/boot/loader.conf
# reboot


