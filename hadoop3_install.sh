#!/bin/sh
#Purpose : To automate the process of Hadoopv3 installation on a Linux (Flavour: CentOS) single node setup

#Variable Declaration
user='hadoop'
group='hadoop'
password='hadoop'
tmpdir='/tmp/apache_hadoop'
usr_dir='/usr/local/apache_hadoop'
git_dir='/home/hadoop/gitrepo'
gitrepo_linux='https://github.com/sandeepksaini/linuxserversetup'
gitrepo_hadoop='https://github.com/sandeepksaini/HDP-HadoopCluster'
hadoop_pack_link='http://apache.is.co.za/hadoop/common/hadoop-3.0.0/hadoop-3.0.0.tar.gz'

#Basic package installation
yum -q install git sshpass ssh wget curl -y

# Create user and group
useradd ${user}
echo "hadoop"|passwd --stdin ${password}

#Temporary dir creation and applying permission of hadoop user and group
mkdir -p ${tmpdir}
mkdir -p ${usr_dir}
mkdir -p ${git_dir}
wget -q -P ${tmpdir} ${hadoop_pack_link}
tar -xf ${tmpdir}/*.gz -C ${tmpdir}
rm -rf ${tmpdir}/*.gz
chown -R ${user}:${group} ${tmpdir}
chown -R ${user}:${group} ${usr_dir}
mv ${tmpdir}/hadoop* ${usr_dir}
rm -rf ${tmpdir}

#Git : Cloning repo for script utilization
for repolist in ${gitrepo_linux} ${gitrepo_hadoop}
do
  cd ${git_dir}
  git clone ${repolist} 1>/dev/null 2>&1
  chown -R ${user}:${group} ${git_dir}
  cd -
done

# SSH Key generation and copy - Provides seemless access to server using ssh for hadoop user-id
su ${user} -c 'ssh-keygen -t RSA -P "" -f ~/.ssh/id_rsa'
su ${user} -c 'user='hadoop';password='hadoop';sshpass -p ${password} ssh-copy-id -i /home/${user}/.ssh/id_rsa.pub -o StrictHostKeyChecking=no ${user}@`hostname`'
systemctl restart sshd
