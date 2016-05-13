Kernel Config Infos
===================

* if go for the CURRENT release, we need to disable all trace and debug
information.  this can be done with the standard GENERIC-NODEBUG config.
Also used in AGORACON.

* further flags are set in `/etc/make.conf`

  
## GENERIC-NODEBUG

Also used in AGORACON

```
include GENERIC

ident   GENERIC-NODEBUG

nooptions       INVARIANTS
nooptions       INVARIANT_SUPPORT
nooptions       WITNESS
nooptions       WITNESS_SKIPSPIN
nooptions       DEADLKRES
```

## setfib(2)

setfib can be activated either in kernel config (options ROUTETABLES=N) or at
startup (net.fibs="N" in /boot/loader.conf).

more details with `man 2 setfib`.


