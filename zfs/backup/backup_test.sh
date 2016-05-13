#!/bin/sh

snap=20150601

zfs send -R zroot@${snap} | zfs receive -Fduv save/root

