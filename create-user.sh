#!/usr/bin/env bash

if [ $# -ne 1 ]
then
  echo "Usage: create-user username"
  exit
else
  USERNAME=$1
fi

# create user
/usr/sbin/adduser $USERNAME 
passwd $USERNAME 

# config sudo
sed -i "/NOPASSWD/a\\$USERNAME ALL=(ALL)       NOPASSWD: ALL" /etc/sudoers
# sed -i "s/Defaults    requiretty/Defaults:$USERNAME \!requiretty/" /etc/sudoers
