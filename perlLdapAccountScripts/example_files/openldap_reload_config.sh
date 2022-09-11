#!/bin/bash
#
# Copyright (c) 2022 tm-dd (Thomas Mueller)
#
# This code is free software. You can use, redistribute and/or
# modify it under the terms of the GNU General Public Licence
# version 2, as published by the Free Software Foundation.
# This program is distributed without any warranty.
# See the GNU General Public Licence for more details.
#

echo "CONVERTING the offline configuration of the OPENLDAP server to the online configuration in 5 seconds."
echo "This will STOP the OPENLDAP service for a while."
echo "Last chance to breake with: [CRTL]+[C] !!!"
sleep 5
echo "STOPPING openldap now ..."
/etc/init.d/slapd stop
killall slapd

echo "TESTING the openldap configuration now ..."
slaptest -f /etc/ldap/slapd_offline.conf

echo "DELETING the OLD openldap settings ..."
rm -rf /etc/ldap/slapd.d
mkdir /etc/ldap/slapd.d
chown openldap.openldap /etc/ldap/slapd.d
chmod 755 /etc/ldap/slapd.d/

echo "SET owner of all openldap databases and files in /var/lib/ldap/* ..."
chown openldap:openldap /var/lib/ldap/*

echo "CONVERTING the offline- to the online configuration in 8 seconds."
echo "YOU MUST press [CRTL]+[C] at the end off the process to restart openldap in the deamon mode."
echo "Otherwise it runs only in the debug mode in this terminal."
sleep 8
/usr/sbin/slapd -f /etc/ldap/slapd_offline.conf -F /etc/ldap/slapd.d -u openldap -g openldap -d 1

echo
echo "RESTART the openldap server now ..."
/etc/init.d/slapd start
