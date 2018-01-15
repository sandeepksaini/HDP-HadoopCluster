#!/bin/bash -x
#Purpose: To enable clear text password and enable root user login via ssh service
# By changing value in sshd_config 
# PermitRootLogin to "yes" will enable root user to login via ssh
# PasswordAuthentication to yes will enable clear text password loing for users using ssh. So instead of key based ssh ->
# -> now user can also use password to do ssh on host.

#Setting up variables
ssh_file='/etc/ssh/sshd_config'

#Backup SSH Config file 
cp ${ssh_file}{,_bck}

per_bol=`egrep -i '^PermitRootLogin no|^#PermitRootLogin no' ${ssh_file}|wc -l`
pwd_bol=`egrep -i '^PasswordAuthentication no|^#PasswordAuthentication no' ${ssh_file}|wc -l`

if [ ${per_bol} -gt 0 ];
then 
        sed -i -e 's/PermitRootLogin no/PermitRootLogin yes/g' ${ssh_file}
elif [ ${pwd_bol} -gt 0 ];
then
        sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/g' ${ssh_file}
fi
