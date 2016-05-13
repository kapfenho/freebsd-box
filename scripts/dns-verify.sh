#!/bin/sh

#### dns_verify.sh
#
#NETS="192.168.1 172.168.20"
NETS="192.168.1"
IPS=$(jot 254 1)  ## for OpenBSD or FreeBSD
#
# IPS=$(jot 254 1)  ## for OpenBSD or FreeBSD
# IPS=$(seq 1 254)  ## for Linux 
#
echo
echo -e "\tip        ->     hostname      -> ip"
echo '--------------------------------------------------------'  
for NET in $NETS; do
  for n in $IPS; do
    A=${NET}.${n}
    HOST=$(drill -x $A +short)
    if test -n "$HOST"; then
      ADDR=$(drill $HOST +short)
      if test "$A" = "$ADDR"; then
        echo -e "ok\t$A -> $HOST -> $ADDR"
      elif test -n "$ADDR"; then
        echo -e "fail\t$A -> $HOST -> $ADDR"
      else
        echo -e "fail\t$A -> $HOST -> [unassigned]"
      fi
    fi
  done
done

echo ""
echo "DONE."
