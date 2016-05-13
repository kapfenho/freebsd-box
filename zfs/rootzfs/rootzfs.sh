#!/bin/sh -x

#  Auto-divides a ZFS install.
#  ZFS permissions stolen from
#  https://wiki.freebsd.org/RootOnZFS/GPTZFSBoot/9.0-RELEASE
#  https://wiki.freebsd.org/RootOnZFS/GPTZFSBoot/Mirror

#  edit:
#  disk device name
#  parameters for your zpool type
#  your pool name
#  swap space

#  we're installing
sysctl kern.geom.debugflags=0x10

gpart destroy -F    ada0
gpart create -s gpt ada0
gpart add -s 222 -a 4k -t freebsd-boot -l boot0 ada0
gpart add -s 16g -a 4k -t freebsd-swap -l swap0 ada0
gpart add        -a 4k -t freebsd-zfs  -l disk0 ada0
gpart bootcode -b /boot/pmbr -p /boot/gptzfsboot -i 1 ada0

gpart destroy -F    ada1
gpart create -s gpt ada1
gpart add -s 222 -a 4k -t freebsd-boot -l boot1 ada1
gpart add -s 16g -a 4k -t freebsd-swap -l swap1 ada1
gpart add        -a 4k -t freebsd-zfs  -l disk1 ada1
gpart bootcode -b /boot/pmbr -p /boot/gptzfsboot -i 1 ada1

gnop create -S 4096 /dev/gpt/disk0
gnop create -S 4096 /dev/gpt/disk1

kldload zfs
zpool create -f -o altroot=/mnt -O canmount=off -m none                     zroot \
             /dev/gpt/disk0.nop \
             /dev/gpt/disk1.nop

zfs set checksum=fletcher4 zroot
zfs set atime=off          zroot

zfs create -o mountpoint=none                                               zroot/ROOT
zfs create -o mountpoint=/                                                  zroot/ROOT/default
zfs create -o mountpoint=/tmp -o compression=lzjb             -o setuid=off zroot/tmp
chmod 1777 /mnt/tmp

zfs create -o mountpoint=/usr                                               zroot/usr
zfs create                                                                  zroot/usr/local

zfs create -o mountpoint=/home                                -o setuid=off zroot/home
zfs create                    -o compression=lzjb             -o setuid=off zroot/usr/ports
zfs create                    -o compression=off  -o exec=off -o setuid=off zroot/usr/ports/distfiles
zfs create                    -o compression=off  -o exec=off -o setuid=off zroot/usr/ports/packages

zfs create                    -o compression=lzjb -o exec=off -o setuid=off zroot/usr/src
zfs create                                                                  zroot/usr/obj

zfs create -o mountpoint=/var                                               zroot/var
zfs create                    -o compression=lzjb -o exec=off -o setuid=off zroot/var/crash
zfs create                                        -o exec=off -o setuid=off zroot/var/db
zfs create                    -o compression=lzjb -o exec=on  -o setuid=off zroot/var/db/pkg
zfs create                                        -o exec=off -o setuid=off zroot/var/empty
zfs create                    -o compression=lzjb -o exec=off -o setuid=off zroot/var/log
zfs create                    -o compression=gzip -o exec=off -o setuid=off zroot/var/mail
zfs create                                        -o exec=off -o setuid=off zroot/var/run
zfs create                    -o compression=lzjb -o exec=on  -o setuid=off zroot/var/tmp
chmod 1777 /mnt/var/tmp

zpool set bootfs=zroot/ROOT/default zroot

cat << EOF > /tmp/bsdinstall_etc/fstab
# Device                       Mountpoint              FStype  Options         Dump    Pass#
/dev/gpt/swap0                 none                    swap    sw              0       0
/dev/gpt/swap1                 none                    swap    sw              0       0
EOF

# mount -t devfs devfs /dev
# echo 'zfs_enable="YES"' >> /etc/rc.conf
# echo 'zfs_load="YES"' >> /boot/loader.conf
# zfs set readonly=on zroot/var/empty

