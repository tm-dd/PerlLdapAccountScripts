#!/bin/bash
#
# Copyright (c) 2022 tm-dd (Thomas Mueller)
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.
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
