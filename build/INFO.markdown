# build freebsd kernel

## checkout (first time)

[Handbook](https://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/svn.html#svn-mirrors)

    svn checkout https://svn.FreeBSD.org/base/head  /usr/src
    svn checkout https://svn.FreeBSD.org/ports/head /usr/ports
    svn checkout https://svn.FreeBSD.org/doc/head   /usr/doc

    svn update /usr/src ; svn update /usr/ports ; svn update /usr/doc

## build

    chflags -R noschg /usr/obj/*  # remove write protection
    rm -rf /usr/obj/*

    cd /usr/src
    make buildworld
    make buildkernel KERNCONF=AGORACON
    make installkernel
    reboot                      # -> single user mode

    mount -u /                  # -> ufs
    mount -a -t ufs
    swapon -a

    zfs set readonly=off zroot  # -> zfs
    zfs mount -a

    kbdmap                      # keyboard
    adjkerntz -i                # if cmos clock is local time

