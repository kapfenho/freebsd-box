#!/bin/sh -x

set -o errexit
set -o nounset

pool_prefix="save"
pool_backup="save/root"
pool_source="zroot"
lastsnap=$(cat /root/.zfs_backup)

# remove mountpoints of datasets in save ----------------------------
#
zclean() {
  echo "${0}: remove mountpoints of datasets in save"
  
  zfs list -H -o name,mountpoint \
    | grep "^${pool_prefix}" \
    | grep -v 'none$' \
    | cut -f 1 -d ' ' \
    | while read p
  do
    echo "X1: ${p}"
    [ -z ${p} ] && exit 80
    echo "  Removing mountpoint in ${p}"
    echo "zfs set mountpoint=none ${p}"
    # zfs set mountpoint=none ${p}
  done
}

# create missing backup datasets ------------------------------------
#
zcreate() {
  echo "${0}: checking for missing backup datasets"
  
  zfs list -H -o name \
    | grep "^${pool_source}" \
    | while read p
  do
    p1=$(echo ${p} | sed 's/zroot/save\/root/')
  
    if ! zfs list ${p1} >/dev/null 2>&1
    then
      echo "  Dataset ${p} missing, creating now..."
      zfs create ${p1}
      zfs send -R ${p}@${lastsnap} | zfs receive -Fduv ${pool_backup}
      zfs set mountpoint=none ${p1}
    fi
  done
}

# main --------------------------------------
#
zclean
# zcreate
#zclean

echo "${0}: successfully finished"

