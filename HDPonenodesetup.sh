#! /bin/bash -
#Purpose to setup pseudomode setup of horotnworks


#Declaration of Variables
soft_limit=`ulimit -Sn`
hard_limit=`ulimit -Hn`
ofd_val='10000'
total_mem=`cat /proc/meminfo|grep 'MemTotal'|awk '{ print $2}'`
mem_GB=`printf "%.0f" $(echo ${total_mem}/1024/1024|bc -l)`
avail_space=`df -h|grep -w "/"|awk '{ print $4}'|tr -d "G"`
used_cent=`df -h|grep -w "/"|awk '{ print $5}'|tr -d "%"`
avail_cent=`printf "%d" $(echo 100 -${used_cent}|bc -l)`
login_user=`whoami`

#Hardware check - RAM and Disk space
if [ ${mem_GB} -ge 8 -a ${avail_space} -ge 20 -a ${avail_cent} -ge 70 ]
then 
  echo " Good To Go :-)"
else
  echo "Increase your RAM to 8 or beyond GB and Disk space to 20 or beyond"
  exit 0
fi

#Check for ulimit and increase it of Open File Descriptor Value(i.e. ofd_val)
if [ ${soft_limit} -le ${ofd_val} -a ${hard_limit} -le ${ofd_val}i -o -e ${HOME}/.bash_profile ]
then
  echo "ulimit -n ${ofd_val}" >> ${HOME}/.bash_profile
  printf "\nPlease exit the shell and re-login for ulimit value to take effect \n"
fi


#check for packages, prior to this make sure yum is installed using rpm and linux repo is setup
for pck_lst in curl unzip tar scp ssh wget openssl yum-utils createrepo httpd yum-plugin-priorities ntp
do
  if [ `rpm -qa ${pck_lst}|wc -l` -eq 0 ]
  then
    yum -q -y install ${pck_lst}
  fi
done


# SSH Key generation and copy - Provides seemless access to server using ssh for hadoop user-id
ssh-keygen -t RSA -P "" -f ~/.ssh/id_rsa
su ${user} -c 'user='hadoop';password='hadoop';sshpass -p ${password} ssh-copy-id -i /home/${user}/.ssh/id_rsa.pub -o StrictHostKeyChecking=no ${user}@`hostname`'
systemctl restart sshd

#Start ntp server for time sync facility
systemctl start ntpd
systemctl enable ntpd

printf "Setup your hostname for the server";

#Stopping firewalld services 
systemctl stop firewalld
systemctl disable firewalld

#Setting SELinux in permissive mode 
setenforce 0

#Setting up the umask for the user-id in it's profile
 echo "umask 0022" >> ${HOME}/.bash_profile
 printf "\n Please log-off and login back for umask to set"

#Step number -2 to configuration of repositories for installation of Ambari
sudo systemctl start httpd
systemctl enable httpd

