#!/bin/sh -x

set -o errexit

if [ $# -lt 1 ]
then
  echo "ERROR: Parameter zfs_pool_name missing"
  exit 80
fi

pool=$1

# excl: mlslabel

zfs allow -s @adminrole allow,clone,create,destroy,diff,hold,mount,promote,receive,release,rename,rollback,send,share,snapshot,groupquota,groupused,userprop,userquota,userused,aclinherit,aclmode,atime,canmount,casesensitivity,checksum,compression,copies,dedup,devices,exec,filesystem_limit,logbias,jailed,mountpoint,nbmand,normalization,primarycache,quota,readonly,recordsize,refquota,refreservation,reservation,secondarycache,setuid,sharenfs,sharesmb,snapdir,snapshot_limit,sync,utf8only,version,volblocksize,volsize,vscan,xattr $pool

