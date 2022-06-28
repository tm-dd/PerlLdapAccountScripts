#!/bin/bash
#
# a perl based script to create a LDAP backup file and check changes
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

# Variable zum Anpassen
onlyTwoBackups='n'          
ldapBackupDir='/data/ldap_backups'
backupDN='dc=example,dc=org'
keepMaxBackups=180
keepMaxLogs=20
dnToFetchLogs='cn=logs-ldapm,ou=ldapauths,dc=example,dc=org'
passwordToFetchLogs='GEHEIMES PASSWORT'

# Ausgabe der Aenderungen im LDAP ueber das "accesslog"-Overlay-Modul
fileLdapChanges="/root/ldap_logs/ldap_changes_`hostname`_$(date +%Y_%m_%d).ldif"
/usr/bin/ldapsearch -b "cn=logs" -h 127.0.0.1 -D $dnToFetchLogs -w "$passwordToFetchLogs" > $fileLdapChanges
echo
echo "Anzahl letzter Aenderungen im LDAP:"
echo
echo -n '   - Anzahl aller veraendeter Zweige: '
cat $fileLdapChanges | grep '^dn: reqStart=' | wc -l
echo -n '   - Zweig Ldap-Client-Authentifizierung: ' 
cat $fileLdapChanges | grep 'ou=ldapauths,dc=example,dc=org' | grep '^reqDN: ' | wc -l
echo -n '   - Zweig Mitarbeiter-Cluster: '
cat $fileLdapChanges | grep 'ou=members,dc=example,dc=org' | grep '^reqDN: ' | wc -l
echo -n '   - Zweig Workshop-Cluster: '
cat $fileLdapChanges | grep 'ou=workshops,dc=example,dc=org' | grep '^reqDN: ' | wc -l
echo
echo '************';
echo
echo "Letzte geaenderte LDAP-Objekte in gekuerzter Form:"
echo
echo '   - Zweig Mitarbeiter-Cluster: '
echo
cat $fileLdapChanges | grep 'ou=members,dc=example,dc=org' | grep '^reqDN: ' | sort | uniq -c
echo
echo '   - Zweig Workshop-Cluster: '
echo
cat $fileLdapChanges | grep 'ou=workshops,dc=example,dc=org' | grep '^reqDN: ' | sort  | uniq -c
echo
echo '   - Sonstige Aenderungen: '
echo
cat $fileLdapChanges | grep 'dc=example,dc=org' | grep '^reqDN: ' | grep -v 'ou=workshops,dc=example,dc=org\|ou=members,dc=example,dc=org' | sort  | uniq -c
echo
echo '************';
echo
# erstelle Verzeichniss falls noch nicht vorhanden
mkdir -p $ldapBackupDir

# erstelle einfaches LDAP-Backup -> spaeter wieder einspielbar mittels 'slapadd -l full_ldap_backup_XXX_YYY.ldif' (evtl. vorher alte LDAP-Daten loeschen)
if [ $onlyTwoBackups == 'y' ];
then
    mv $ldapBackupDir/full_ldap_backup.ldif $ldapBackupDir/full_ldap_backup.ldif.old 2> /dev/null
    /usr/sbin/slapcat -b $backupDN -l $ldapBackupDir/full_ldap_backup.ldif && echo "Es wurde ein neues LDAP-Backup erfolgreich am $(date +%d.%m.%Y) nach $ldapBackupDir erstellt!"
else
    backupfile="$ldapBackupDir/full_ldap_backup_$HOSTNAME_$(date +%Y_%m_%d).ldif"
    /usr/sbin/slapcat -b $backupDN -l $backupfile && echo "Es wurde folgendes neues LDAP-Backup erfolgreich am $(date +%d.%m.%Y) nach $ldapBackupDir erstellt:"
    echo
    ls -lh $backupfile
    echo
    echo "Komprimiere Datei $backupfile ..."
    echo
    bzip2 -9 $backupfile
    ls -l $backupfile.bz2
fi

echo
echo '************'
echo
echo "ALLE letzen Aenderungen im LDAP:"
echo
cat $fileLdapChanges | sed 's/Password.*$/Password: NOT IN THIS MAIL HERE !!!/g' | grep -v '^ '
echo
echo -n 'Ende des Skriptes: '
date
echo
exit 0

