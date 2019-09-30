#!/bin/sh

# debconf
sudo echo "slapd	slapd/internal/adminpw	password" | sudo debconf-set-selections
sudo echo "slapd	slapd/password2	password" | sudo debconf-set-selections
sudo echo "slapd	slapd/internal/generated_adminpw	password" | sudo debconf-set-selections
sudo echo "slapd	slapd/password1	password" | sudo debconf-set-selections
sudo echo "slapd	slapd/move_old_database	boolean	true" | sudo debconf-set-selections
sudo echo "slapd	slapd/purge_database	boolean	false" | sudo debconf-set-selections
sudo echo "slapd	slapd/no_configuration	boolean	false" | sudo debconf-set-selections
sudo echo "slapd	slapd/dump_database	select	when needed" | sudo debconf-set-selections
sudo echo "slapd	slapd/domain	string	csc.wcupa.edu" | sudo debconf-set-selections
sudo echo "slapd	slapd/ppolicy_schema_needs_update	select	abort installation" | sudo debconf-set-selections
sudo echo "slapd	slapd/dump_database_destdir	string	/var/backups/slapd-VERSION" | sudo debconf-set-selections
sudo echo "slapd	slapd/unsafe_selfwrite_acl	note" | sudo debconf-set-selections
sudo echo "slapd	shared/organization	string	West Chester University" | sudo debconf-set-selections
sudo echo "slapd	slapd/invalid_config	boolean	true" | sudo debconf-set-selections
sudo echo "slapd	slapd/upgrade_slapcat_failure	error" | sudo debconf-set-selections
sudo echo "slapd	slapd/backend	select	MDB" | sudo debconf-set-selections
sudo echo "slapd	slapd/password_mismatch	note" | sudo debconf-set-selections
#sudo echo "libssl1.1       libssl1.1/restart-services      string  slapd openvpn ssh ntp" | sudo debconf-set-selections
#sudo echo "libssl1.1:amd64 libssl1.1/restart-services      string  slapd openvpn ssh ntp" | sudo debconf-set-selections
sudo echo "libssl1.0.0     libssl1.0.0/restart-services    string  slapd openvpn ssh ntp" | sudo debconf-set-selections
sudo echo "libssl1.0.0:amd64       libssl1.0.0/restart-services    string  slapd openvpn ssh ntp" | sudo debconf-set-selections
sudo echo "libssl1.1       libssl1.1/restart-failed        error" | sudo debconf-set-selections
sudo echo "libssl1.1:amd64 libssl1.1/restart-failed        error" | sudo debconf-set-selections
sudo echo "libssl1.0.0     libssl1.0.0/restart-failed      error" | sudo debconf-set-selections
sudo echo "libssl1.0.0:amd64       libssl1.0.0/restart-failed      error" | sudo debconf-set-selections
sudo echo "libssl1.1       libssl1.1/restart-services      string  openvpn ssh ntp bind9 apache2" | sudo debconf-set-selections
sudo echo "libssl1.1:amd64 libssl1.1/restart-services      string  openvpn ssh ntp bind9 apache2" | sudo debconf-set-selections


sudo apt-get update
sudo apt-get install -y slapd ldap-utils
sudo dpkg-reconfigure slapd
sudo ufw allow ldap
ldapadd -x -D cn=admin,dc=csc,dc=wcupa,dc=edu -W -f /local/repository/ldap/basedn.ldif
ldapadd -x -D cn=admin,dc=csc,dc=wcupa,dc=edu -W -f /local/repository/ldap/users.ldif

sudo apt-get install -y nfs-kernel-server
#apt-get install -y nfs-utils nfs-utils-lib
#yum install -y nfs-utils nfs-utils-lib

sudo chown nobody:nogroup /home

mkdir /software
mkdir /scratch
sudo chown nobody:nogroup /software
sudo chown nobody:nogroup /scratch

# Create the permissions file for the NFS directory.
computes=$(($1 + 1))
for i in $(seq 2 $computes)
do
  echo "/home 192.168.1.$i(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
  echo "/opt 192.168.1.$i(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
  echo "/software 192.168.1.$i(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
  echo "/scratch 192.168.1.$i(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
done

sudo systemctl restart nfs-kernel-server

#chkconfig nfs on
#service rpcbind start
#service nfs start



# Copy, if exists.
cp /local/repository/source/* /scratch || true

## Create the permissions file for the NFS directory.
#computes=$(($1 + 1))
#for i in $(seq $computes)
#do
#  st='/software 192.168.1.'
#  st+=$(($i))
#  st+='(rw,sync,no_root_squash,no_subtree_check)'
#  echo $st >> /etc/exports
#done

#exportfs -a
#echo "Done" >> /users/jk880380/headdoneNFS.txt

# Next step: MPI ####################
#set -x
##sudo yum -y group install "Development Tools"
#sudo apt-get -y group install "Development Tools"
#
#cd /software
#sudo wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.2.tar.gz
#sudo tar xzf openmpi-3.1.2.tar.gz
#cd openmpi-3.1.2
#sudo ./configure --prefix=/software
#sudo make
#sudo make all install
#echo "export PATH='$PATH:/software/bin'" >> /users/jk880380/.bashrc
#echo "export LD_LIBRARY_PATH='$LD_LIBRARY_PATH:/software/lib/'" >> /users/jk880380/.bashrc
#cd ..
#sudo rm -Rf openmpi-3.1.2
#sudo rm -Rf openmpi-3.1.2.tar.gz
##mkdir /software/flagdir
#echo "Done" >> /users/jk880380/headdoneMPI.txt

# Storage.

#touch /etc/exports
#touch /scratch/machine_list
#echo 'storage' >> /scratch/machine_list
#computes=$(($1 + 0))
#for i in $(seq $computes)
#do
#  st='/scratch 192.168.1.'
#  st+=$(($i + 2))
#  st+='(rw,sync,no_root_squash,no_subtree_check)'
#  echo $st >> /etc/exports
#  
#  st2='compute-'
#  st2+=$(($i + 0))
#  #st2='192.168.1.'
#  #st2+=$(($i + 2))
#  echo $st2 >> /scratch/machine_list
#done
#
#exportfs -a

#sleep 600
#mkdir /software
#mount -t nfs 192.168.1.1:/software /software
mkdir /software/flagdir
echo "Done" >> /users/jk880380/DONEnfsheadandstorage.txt
