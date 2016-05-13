#!/bin/sh -x

# copy backup pool to newly created pool

set -o errexit
set -o nounset

oldpool=nroot
newpool=zroot

zfs snapshot -r $oldpool@shrink
zfs send -vR $oldpool@shrink | zfs receive -vFd $newpool
zfs destroy -r $oldpool@shrink
zfs destroy -r $newpool@shrink

zpool set bootfs=$newpool/ROOT/default $newpool

exit 0

# perform manual steps from script 1

