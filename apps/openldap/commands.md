# ldap commands

## access

- anonymous bind
    => simple bind: no user, no passwd
        -> anonymous authorization assoc.
- unauthenticated bind
    => simple bind: user, no passwd
        -> unauthenticated authorization assoc. (disabled by default)
- authentication bind
    => simple bind with user and passwd, SASL, etc.
        failed -> anonymous authorization assoc.
        ok     -> authenticated


    require authc               # only authenticated access to dir
    allow bind_anon_cred        # enable unauthenticated bind (default: off, keep it off)
    security simple_bind=56     # minimal DES for bind
    disallow bind_simple        # no user/passwd authentication (e.g. only SASL)
    disallow bind_anon          # no anon bind


## slapd

    # as root
    ldapsearch -b cn=config [ -s one ]
    
# openldap

# setup

    /var/db/openldap-data               # database
    /usr/local/etc/openldap/slapd.d     # cn=config dir
    /usr/local/etc/openldap/slapd.conf  # only for initial config and conversion

    # conversion
    /usr/local/libexec/slapd -f /usr/local/etc/openldap/slapd.conf -F /usr/local/etc/openldap/slapd.d
    slapd -Tt       # test config

    export LDAPNOINIT=YES           # dont use other configs

    sudo LDAPNOINIT=YES ldapsearch -Y EXTERNAL -H ldapi:/// -b "cn=config"
    sudo LDAPNOINIT=YES ldapmodify -Y EXTERNAL -H ldapi:/// -f file.ldif

# naming contexts

    sudo LDAPNOINIT=YES ldapsearch -Y EXTERNAL -H ldapi:/// -b '' -s base '(objectclass=*)' namingContexts
    sudo LDAPNOINIT=YES ldapsearch -Y EXTERNAL -H ldapi:/// -b 'dc=agoracon,dc=at' -s base '(objectclass=*)' 

# initial realm load/creation

    ldapadd    -x -D "cn=admin,dc=agoracon,dc=at" -y ~/.creds/ldap -f /home/horst/config/ldap/import.ldif
    ldapsearch -x -D "cn=admin,dc=agoracon,dc=at" -y ~/.creds/ldap  '(objectclass=*)' dn

## get config

    ldapsearch -x -D "cn=admin,cn=config" -y ~/.creds/ldap -b 'cn=config'

# password store
    password-hash {CRYPT}
    password-crypt-salt-format "$1$%.8s"


