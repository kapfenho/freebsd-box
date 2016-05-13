#!/bin/sh -x

dest=jails-config-$(date "+%Y%m%d-%H%M").tgz

sudo tar -cjC /usr/jails -f ~/config-backup/${dest} \
  jails-system \
  jails-custom \
  jails-fstab \
  jails-rcconf


