#!/bin/bash
#
# a danger but easy script to make a OpenLDAP backup
#
# SEHR einfaches Skript - gedacht als LDAP-BACKUP-CRONJOP.
# Es besteht laut Doku beim Einsatz dieses Skriptes die Gefahr, dass der OpenLDAP-Server zu Problemen kommen kann, wenn man ihn ONLINE backupt.
# In der Praxis hat sich das Skript jedoch bisher viele Jahre bewaehrt, wenn man nachts taeglich ein Backup macht. 
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

# Variable zum anpassen
export ldapbackupdir=/root/ldap_backups

# test ob als root gestartet
if [ $USER != 'root' ];
  then echo "please run this script as root ..."
  exit -1
fi

# erstelle Verzeichniss falls noch nicht vorhanden
cd $ldapbackupdir 2> /dev/null ||
if [ -e $ldapbackupdir ];
    then
        mv $ldapbackupdir $ldapbackupdir.old.$(date +%Y_%m_%d)
        mkdir $ldapbackupdir
    else
        mkdir $ldapbackupdir
fi

# erstelle einfaches LDAP-Backup -> spaeter wieder einspielbar mittels 'slapadd -l full_ldap_backup_XXX_YYY.ldif' (evtl. vorher alte LDAP-Daten loeschen)
chmod 700 $ldapbackupdir
chown root:root $ldapbackupdir
/usr/sbin/slapcat -l $ldapbackupdir/full_ldap_backup_$HOSTNAME_$(date +%Y_%m_%d).ldif && echo "Es wurde ein neues LDAP-Backup erfolgreich am $(date +%d.%m.%Y) nach $ldapbackupdir erstellt!"
chmod 600 $ldapbackupdir/*
    
# loesche alle Backups die aelter sind als 180 Tage
/usr/bin/find $ldapbackupdir -mtime +180 -exec rm {} \;

