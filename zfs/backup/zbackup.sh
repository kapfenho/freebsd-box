#!/bin/sh

set -o errexit 
set -o nounset 

# source pool of backup
pool="zroot"
# destination backup pool
dest="save/root"
# no verbose output
verbose="N"

# remove_old_source_snapshots()   ---------------------------------------
#
remove_old_source_snapshots() {
  set -o errexit 
  set -o nounset 
  local new snaps_src
  # get a sorted list of snapshots of pool
  snaps_src=$(zfs list -r -t snapshot ${pool} | perl -ne 'print if s/^.*@([0-9]+)\s.*$/$1/' | sort | uniq -c)
  
  if [ "X${verbose}" == "XY" ] ; then
    echo "--- These are the existing shapshots of ${pool} (datasets, timestamp):"
    echo "${snaps_src}"
    echo
    echo "--- We will remove all but the last (newest) one..."
  fi
  
  # find the newest snapshot, the one we've created now
  new=$(echo "${snaps_src}" | tail -1 | awk '{print $2}')
  echo "--- Keeping snapshot ${new}"
  
  # and delete all the others
  echo "${snaps_src}" | sed '$d' | while read l
  do
    set -x
    zfs destroy -r ${pool}@$(echo ${l} | awk '{print $2}')
    set +x
  done
}

# create_new_source_snapshot()  -----------------------------------------
#
create_new_source_snapshot() {
  set -o errexit 
  set -o nounset 
  local new snapshot_new
  # snapshot name like 201612312359
  new=$(date +"%Y%m%d%H%M")
  snapshot_new="${pool}@${new}"

  # look for a snapshot with this name
  if zfs list -H -o name -t snapshot | sort | grep "${snapshot_new}$" > /dev/null; then
    echo "ERROR: snapshot ${snapshot_new} already exists"
    exit 80
  fi

  if [ "X${verbose}" == "XY" ] ; then
    echo "--- Taking new snapshot ${snapshot_new}..."
  fi
  set -x
  zfs snapshot -r ${snapshot_new}
  set +x
}


# transfer_snapshot()  ------------------------------------------------
#
transfer_snapshot() {
  set -o errexit 
  set -o nounset 
  local last snaps_dst
  # get the newest snapshot from the destination pool
  snaps_src=$(zfs list -r -t snapshot ${pool} | perl -ne 'print if s/^.*@([0-9]+)\s.*$/$1/' | sort | uniq -c)
  snaps_dst=$(zfs list -r -t snapshot ${dest} | perl -ne 'print if s/^.*@([0-9]+)\s.*$/$1/' | sort | uniq -c)
  
  # find the newest snapshot in destination, we use it for delta
  last=$(echo "${snaps_dst}" | tail -1 | awk '{print $2}')
   new=$(echo "${snaps_src}" | tail -1 | awk '{print $2}')

  commons=$( echo $(echo "${snaps_dst}" | awk '{print $2}') \
                  $(echo "${snaps_src}" | awk '{print $2}') | \
                    sort | uniq -d)
  common=$(echo "${commons}" | tail -1)

  if [ "${common}" -eq "${new}" ] ; then
    echo "ERROR: Newest snapshot at destination is as old source or newer!"
    exit 81
  fi
  
  if [ "X${verbose}" == "XY" ] ; then
    echo "--- Destination Snapshots:"
    echo "${snaps_dst}" | awk '{ print $1 " datasets have snapshot " $2 }'
    echo
    echo "--- Snapshots in common:"
    echo "${commons}" 
    echo
    echo "--- Using newest common snapshot for delta transfer: ${common}"
    echo
  fi
  
  if [ "X${last}" != "X" ] ; then
    echo "--- Transfering delta from ${last} to ${new}..."
    set -x
    zfs send -R -i ${pool}@${last} ${pool}@${new} | zfs receive -Fduv ${dest}
    echo "*** We could now destroy snapshot:"
    echo "*** zfs destroy -r ${pool}@${last}"
    set +x
  else
    echo "--- Could not find a snapshot, we gonna transfer all data..."
    set -x
    zfs send -R ${pool}@${new} | zfs receive -Fduv ${dest}
    set +x
  fi
}


#  main  ##############################################################
#

remove_old_source_snapshots
create_new_source_snapshot
transfer_snapshot

exit 0
