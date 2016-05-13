#!/bin/sh
# 
#       horst.kapfenberger@agoracon.at, 28.01.2016
# 
# during authentication for each domain the call to 
#   http://domain/.well-known/acme... 
# is done.
#
# - allow access in firewall for us servers
# - set sym link in /etc to /usr/local/etc/letsencrypt/{test,prod}
# - currently certs must be copied manually
# 

    cfg_dir="/usr/local/etc/letsencrypt"
agoracon_wr="/usr/jails/jails/proxy1/usr/local/www/agoracon/public"
  gitlab_wr="/usr/jails/jails/proxy1/usr/local/www/gitlab/public"
 redmine_wr="/usr/jails/jails/proxy1/usr/local/www/redmine/public"

      email="admin@agoracon.at"
     keylen="4096"
   srv_test="https://acme-staging.api.letsencrypt.org/directory"
   srv_prod="https://acme-v01.api.letsencrypt.org/directory"

letsencrypt certonly \
	--server ${srv_test} \
        --config-dir ${cfg_dir} \
	--agree-tos \
	--email ${email} \
	--rsa-key-size ${keylen} \
	--webroot \
	--webroot-path ${agoracon_wr} -d agoracon.at -d www.agoracon.at \
	--webroot-path ${gitlab_wr} -d git.agoracon.at \
	--webroot-path ${redmine_wr} -d red.agoracon.at

