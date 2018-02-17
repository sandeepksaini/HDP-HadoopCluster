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
export JAVA_HOME=/usr/lib/jvm/java-1.7.0
export M3_HOME=/opt/apache-maven-3.3.9
export PATH=$JAVA_HOME/jre/bin:/opt/apache-maven-3.3.9/bin:$PATH
<<EOF

#3- Download and setup protobuf
wget -q -P ${hadoop_tmp} https://github.com/google/protobuf/releases/download/v2.5.0/protobuf-2.5.0.tar.gz
pack_name1=`ls ${hadoop_tmp}|proto*|cut -d '/' -f3`
tar -xzf ${pack_name1} -C /opt
cd /opt/proto*
./configure 2>&1 1>/dev/null
make 2&1 1>/dev/null;make install 2&1 1>/dev/null
cd -

#4- Dowanload hadoop 2.7 stable package and install 
wget -q -P ${hadoop_tmp} http://apache.is.co.za/hadoop/common/hadoop-2.7.5/hadoop-2.7.5-src.tar.gz
pack_name1=`ls ${hadoop_tmp}|hadoop*|cut -d '/' -f3`
tar -xzf ${pack_name1} -C /opt
cd /opt/hadoop*
nohup mvn package -Pdist,native -DskipTests -Dtar &

hadoop_bin="/opt/cluster";

mkdir -p ${hadoop_bin};
tar -xzf "/opt/hadoop-2.7.5-src/hadoop-dist/target/hadoop-2.7.5.tar.gz" -C ${hadoop_bin};
useradd hadoop;echo hadoop|passwd --stdin hadoop;chown -R hadoop:hadoop /opt/cluster/

#  Creation of hadoop env profile file
cat > /etc/profile.d << EOF
export JAVA_HOME=/usr/lib/jvm/java-1.7.0
export HADOOP_HOME=/opt/cluster

export HADOOP_MAPRED_HOME=${HADOOP_HOME}
export HADOOP_COMMON_HOME=${HADOOP_HOME}
export HADOOP_HDFS_HOME=${HADOOP_HOME}
export YARN_HOME=${HADOOP_HOME}
export HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop
export YARN_CONF_DIR=${HADOOP_HOME}/etc/hadoop

export HADOOP_HOME_WARN_SUPRESS=True
PATH=${JAVA_HOME}/jre/bin:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:$PATH
export PATH
EOF

printf "\n Run this command after execution of this script to setup the env variable for hadoop :\n\n# . ./etc/profile.d/hadoopenv.sh\n\n"


