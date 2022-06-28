# perlLdapAccountScripts

perlLdapAccountScripts are scripts to manage OpenLDAP accounts on Linux clusters.

The goal of the scripts are to use simpel commands for the daily use, instead to need how to know to use an LDAP editor.
If you are an Unix administrator and searching for some scripts to manage hundreds of LINUX accounts
or you need some perl based examples to manage accounts on a LDAP server, have a look to this commands here.

PLEASE NOTE, YOU USE THE SCRIPTS ON YOUR OWN RISK.

I started the code 2007 as an Linux system administrator to find an easy way to manage hundreds of short time conference accounts.
Later I add some more scripts or special LDAP parameter (like quota size for cloud server) for the daily work.

The OpenLDAP setting for Samba are designed for the Samba 3 configuration style and not to use as an Active Directory server.

How to setup and use the whole scripts:
- install the script on a testing server, at first
- put the script directory on a place like "/usr/local/perlLdapAccountScripts/" on the Linux server, how can manage home directories
- install dependencies (like on debian: libconvert-asn1-perl, libnet-ldap-perl, libcrypt-smbhash-perl, libterm-readkey-perl, ... ?)
- import the OpenLDAP schema "extraAccountValues.schema"
- change all nessesary settings in the "config" file (that's a lot)
- start "ldap_start" or read "help.txt" to get first instructions
- change the LaTeX template files in templates and the all configs for production use

The perlLdapAccountScripts contains scripts, to:
- create or remove a lot of accounts with one command, based on a CSV file or group
- create and remove user accounts
- create and remove groups
- create and remove Samba 3 machine accounts
- add or remove user accounts to or from groups
- export user accounts, groups and machine accounts
- disable or enable user accounts
- migrate local accounts and groups (from /etc/passwd and /etc/groups) to an OpenLDAP server
- ...

There are a lot of possible configurations for the daily work in the config file.


PLEASE NOTE, YOU USE THE SCRIPTS ON YOUR OWN RISK.

Thomas Mueller <><

