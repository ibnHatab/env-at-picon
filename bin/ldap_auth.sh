#!/bin/sh


out=/dev/null

read name
read pass


dn=`ldapsearch -x -v -LL -H ldaps://ldapb2a-qa-emea.app.alcatel-lucent.com:1793 -D "uid=admin.sae-tis,dc=sae-tis,dc=apps,dc=alcatel" -w '5a3-t!5' -b "dc=users,dc=alcatel" "(uid=$name)" 2>$out| grep dn | cut -d ":" -f 2`

if [ "X${dn}" == "X" ]
then 
	exit 1
fi

ldapsearch -x -v -LL -H ldaps://ldapb2a-qa-emea.app.alcatel-lucent.com:1793 -D "$dn" -w $pass -b "dc=users,dc=alcatel" "(uid=$name)" >& $out

