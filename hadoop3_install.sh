#!/bin/sh
#Purpose : To automate the process of Hadoopv3 installation single node setup

#Declaring variable
user='hadoop'
group='hadoop'
password='hadoop'
tmpdir='/tmp/apache_hadoop'
usr_dir='/usr/local/apache_hadoop'
git_dir='/home/hadoop/gitrepo'
gitrepo_linux='https://github.com/sandeepksaini/linuxserversetup'
gitrepo_hadoop='https://github.com/sandeepksaini/HDP-HadoopCluster'
hadoop_package='http://apache.is.co.za/hadoop/common/hadoop-3.0.0/hadoop-3.0.0.tar.gz'

#Basic package installation
yum install git sshpass ssh wget -y

# Create user and group
useradd ${user}
echo "hadoop"|passwd --stdin ${password}

#Temporary dir creation and applying permission of hadoop user and group
mkdir -p ${tmpdir}
mkdir -p ${usr_dir}
mkdir -p ${git_dir}
wget -P ${tmpdir} ${hadoop_package}
tar -xvf ${tmpdir}/*.gz -C ${tmpdir}
rm -rf ${tmpdir}/*.gz
chown -R ${user}:${group} ${tmpdir}
mv ${tmpdir}/hadoop* ${usr_dir}

#Cloning repo for script utilization
for repolist in ${gitrepo_linux} ${gitrepo_hadoop}
do
  git -c ${git_dir} clone ${repolist}
  chown -R ${user}:${group} ${git_dir}
done

# SSH Key generation and copy for seemless ssh and allows hadoop to run without issues
su ${user} -c 'ssh-keygen -t RSA -P "" -f ~/.ssh/id_rsa'
su ${user} -c 'user='hadoop';password='hadoop';sshpass -p ${password} ssh-copy-id -i /home/${user}/.ssh/id_rsa.pub -o StrictHostKeyChecking=no ${user}@`hostname`'
systemctl sshd restart
