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

#Hardware check - RAM
if [ ${mem_GB} -ge 8 -a ${avail_space} ge 20 -a ${avail_cent} -ge 70 ]
then 
  echo " Good To Go :-)"
else
  echo "Increase your RAM to 8 or beyond GB and Disk space to 20 or beyond"
  exit 0
fi

#Check for ulimit and increase it of Open File Descriptor Value(i.e. ofd_val)
if [ ${soft_limit} -le ${ofd_val} -a ${hard_limit} -ge ${ofd_val} ]
then
  ulimit -n ${ofd_val}
fi


#check for packages, prior to this make sure yum is installed using rpm and linux repo is setup
for pck_lst in curl unzip tar scp ssh wget openssl
do
  if [ `rpm -qa ${pck_lst}|wc -l` -eq 0 ]
  then
    yum -q -y install ${pck_lst}
  fi
done
