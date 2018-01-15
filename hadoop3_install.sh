#!/bin/sh
#Purpose : To automate the process of Hadoopv3 installation single node setup

#Declaring variable
user='hadoop'
password='hadoop'
gitrepo_li='https://github.com/sandeepksaini/linuxserversetup'
gitrepo_hadoop='https://github.com/sandeepksaini/HDP-HadoopCluster'
hadoop_package='http://apache.is.co.za/hadoop/common/hadoop-3.0.0/hadoop-3.0.0.tar.gz'

#Basic package installation
yum install git sshpass -y

#Cloning repo for script utilization
for list in ${gitrepo_li} ${gitrepo_hadoop}
do
  git -clone ${list}
done

# Create user and group
useradd -a ${user}
echo "hadoop"|passwd --stdin $[password}

# SSH Key generation and copy for seemless ssh and allows hadoop to run without issues
su ${user} -c 'ssh-keygen -t RSA -P "" -f ~/.ssh/id_rsa'
su ${user} -c 'ssh-copy-id -i /home/${user}/.ssh/id_rsa.pub hadoop@`hostname`
su ${user} -c sshpass -p ${password} ssh-copy-id -f -i ~/.ssh/id_rsa.pub root@`hostname`
