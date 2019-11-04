#!/bin/bash

set -x
#sudo wget http://apache.cs.utah.edu/hadoop/common/hadoop-3.1.1/hadoop-3.1.1.tar.gz
#sudo tar xzf hadoop-3.1.1.tar.gz -C /opt/
#sudo apt-get update -y
#sudo apt-get install -y default-jdk

#sudo bash -c "echo 'HADOOP_HOME=/opt/hadoop-3.1.1/' > /etc/environment"
#sudo bash -c "echo 'PATH=/opt/hadoop-3.1.1/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games' >> /etc/environment"

sudo bash -c "echo 'HADOOP_HOME=/usr/local/hadoop-2.7.3/' > /etc/environment"
sudo bash -c "echo 'PATH=/usr/local/hadoop-2.7.3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games' >> /etc/environment"

#sudo grep -o -E 'datanode[0-9]+$' /etc/hosts > /opt/hadoop-3.1.1/etc/hadoop/slaves
