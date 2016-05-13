#!/bin/sh

set -o errexit nounset verbose

pool="zroot"
destination="save/root"
 
today=$(date +"%Y%m%d")
#yesterday=$(date -v -1d +"%Y%m%d")
yesterday=20150715
 
# create today snapshot
snapshot_today="$pool@$today"
# look for a snapshot with this name
if zfs list -H -o name -t snapshot | sort | grep "$snapshot_today$" > /dev/null; then
  echo " snapshot, $snapshot_today, already exists"
  exit 1
else
  echo " taking todays snapshot, $snapshot_today"
  zfs snapshot -r $snapshot_today
fi
 
# look for yesterday snapshot
snapshot_yesterday="$pool@$yesterday"
if zfs list -H -o name -t snapshot | sort | grep "$snapshot_yesterday$" > /dev/null; then
  echo " yesterday snapshot, $snapshot_yesterday, exists lets proceed with backup"
 
  zfs send -R -i $snapshot_yesterday $snapshot_today | zfs receive -Fduv $destination
 
  echo " backup complete destroying yesterday snapshot"
  zfs destroy -r $snapshot_yesterday
  exit 0
else
  echo " missing yesterday snapshot $snapshot_yesterday"
  echo " shall we create an initial backup? (y/n)"
  read answer
  if [ "$answer" = "y" ]; then
    zfs send -R $snapshot_today | zfs receive -Fduv $destination
    echo " backup complete"
    exit 0
  fi
  exit 1
fi
