#!/bin/sh -x

set -o errexit

zfs create -o compression=off -o exec=off -o setuid=off -o atime=off  zdata/horst
zfs create -o compression=off -o exec=off -o setuid=off -o atime=off  zdata/horst/foto
zfs create -o compression=off -o exec=off -o setuid=off -o atime=off  zdata/horst/audio
zfs create -o compression=off -o exec=off -o setuid=off -o atime=off  zdata/horst/video

zfs create -o compression=off -o exec=off -o setuid=off -o atime=off  zdata/agora
zfs create -o compression=off -o exec=on  -o setuid=off -o atime=off  zdata/install
zfs create -o compression=off -o exec=off -o setuid=off -o atime=off  zdata/books
zfs create -o compression=off -o exec=off -o setuid=off -o atime=off  zdata/projects

