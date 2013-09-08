#!/usr/bin/env bash

if [ $# -ne 1 ]
then
  echo "Usage: centos-rename newname"
  exit
else
  NEWNAME=$1
fi
OLDNAME=`hostname`

sed -i "s/$OLDNAME/$NEWNAME/g" /etc/sysconfig/network
sed -i "s/$OLDNAME/$NEWNAME/g" /etc/hosts
hostname $NEWNAME
hostname
