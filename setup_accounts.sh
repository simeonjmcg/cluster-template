#!/bin/bash
set -x

if hostname | grep -q namenode; then
  cd /users
  i=0
  while read line
  do
    array[ $i ]="$line"
    (( i++ ))
  done < <(find . -mindepth 1 -maxdepth 1 -type d \( ! -iname ".*" \) | sed 's|^\./||g')

  groupadd hadoop
  for j in "${array[@]}"
  do
    usermod -a -G hadoop $j
  done
    
  for j in "${array[@]}"
  do
    sudo -H -u hdfs bash -c "hdfs dfs -mkdir -p /user/$j"
    sudo -H -u hdfs bash -c "hdfs dfs -chown $j:hadoop /user/$j"
    sudo -H -u hdfs bash -c "hdfs dfs -chmod 755 /user/$j"
  done
  
  sudo -H -u hdfs bash -c "wget -P /tmp http://files.grouplens.org/datasets/movielens/ml-latest.zip"
  sudo -H -u hdfs bash -c "unzip /tmp/ml-latest.zip -d /tmp"
  sudo -H -u hdfs bash -c "hdfs dfs -put /tmp/ml-latest /"
  sudo -H -u hdfs bash -c "hdfs dfs -chmod -R 755 /ml-latest"
  sudo -H -u hdfs bash -c "hdfs dfs -ls -h /ml-latest"
  sudo -H -u hdfs bash -c "rm -Rf /tmp/ml-latest"
  sudo -H -u hdfs bash -c "rm /tmp/ml-latest.zip"
fi
