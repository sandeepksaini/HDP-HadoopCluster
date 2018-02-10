#! /bin/bash -
#Purpose to setup pseudomode setup of horotnworks


#Declaration of Variables
soft_limit=`ulimit -Sn`
hard_limit=`ulimit -Hn`
ofd_val='10000'

#Check for ulimit and increase it of Open File Descriptor Value(i.e. ofd_val)
if [ ${soft_limit} -le ${ofd_val} -a ${hard_limit} -ge ${ofd_val} ]
then
  ulimit -n ${ofd_val}
fi


#check for packages, prior to this make sure yum is installed using rpm and linux repo is setup
for pck_lst in curl unzip tar scp ssh wget
do
  if [ `rpm -qa ${pck_lst}|wc -l` -eq 0 ]
  then
    yum -q -y install ${pck_lst}
  fi
done
