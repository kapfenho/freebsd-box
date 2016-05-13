#!/usr/bin/env zsh

src=/usr/jails/jails/redmine
dst=/usr/jails/jails/$1

set -A f1

f1=(
  /etc/mail/mailer.conf
  /usr/local/etc/ssmtp/ssmtp.conf
  /usr/local/etc/ssmtp/revaliases
)

for f in ${f1[@]}
do
  cp -f ${src}${f} ${dst}${f}
done




