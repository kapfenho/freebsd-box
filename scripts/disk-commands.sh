# disk commands

gem disk list           # devices (all types)
camcontrol devlist      # devices (only ATA)
diskinfo -v /dev/ada0   # physical info
gpart list              # disk partitions
zpool list -v           # zfs pools
zfs list                # zfs datasets

ls -l /dev/gpt/
ls -l /dev/gptid/

