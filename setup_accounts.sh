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
    sudo -u hadoop "hdfs dfs -mkdir -p /user/$j"
    sudo -u hadoop "hdfs dfs -chown $j:hadoop /user/$j"
    sudo -u hadoop "hdfs dfs -chmod 755 /user/$j"
  done
fi
