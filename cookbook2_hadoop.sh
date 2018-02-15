#!/bin/bash -

#commands -

# Prior to setup installation required: - Not mentioned in book
yum install wget

#1-Installation of dependencies
yum install gcc gcc-c++ openssl-devel make cmake jdk-1.7u45 
#2-Installation of maven
hadoop_tmp="/tmp/hadoop-pack"
mkdir -p ${hadoop_tmp}
wget -q -P ${hadoop_tmp} mirrors.gigenet.com/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz

#Untar maven in /opt
pack_name=`ls ${hadoop_tmp}`
tar -zxf ${pack_name} -C /opt

#Setup of Maven Env Variable
cat > /etc/profile.d/maven.sh << EOF
export JAVA_HOME=/usr/java/latest
export M3_HOME=/opt/apache-maven-3.3.9
export PATH=$JAVA_HOME/bin:/opt/apache-maven-3.3.9/bin:$PATH
<<EOF

