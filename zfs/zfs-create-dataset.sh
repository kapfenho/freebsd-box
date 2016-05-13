ds=zroot/usr/owncloud/ttransfer
mp=/usr/jails/jails-data/owncloud-data/usr/local/www/owncloud/ttransfer
  
zfs create -o compression=off -o exec=off -o setuid=off $ds
zfs set mountpoint=$mp $ds

zfs create -o compression=off -o exec=off -o setuid=off zroot/usr/export
zfs set mountpoint=/usr/export                          zroot/usr/export
