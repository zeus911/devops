#!/usr/bin/env bash

BASE_DIR=`pwd`
SCRIPT_DIR=$(readlink -e $(dirname $0))

if [ $# -gt 0 ]
then
  VERSION=$1
else
  VERSION=5.6.14
fi
MYSQL_SRC=mysql-$VERSION-linux-glibc2.5-x86_64.tar.gz
MYSQL_DIR=${MYSQL_SRC%.tar.gz}
INSTALL_DIR=$HOME/mysql
DATA_DIR=$HOME/data/mysql

if [ ! -f $MYSQL_SRC ]
then
  wget "http://cdn.mysql.com/Downloads/MySQL-5.6/mysql-$VERSION-linux-glibc2.5-x86_64.tar.gz"
fi
if [ -d $MYSQL_DIR ]
then
  rm -rf $MYSQL_DIR
fi
tar zxf $MYSQL_SRC
mv $MYSQL_DIR $INSTALL_DIR

cd $SCRIPT_DIR
if [ -f conf/mysql/my.cnf ]
then
  mkdir $INSTALL_DIR/etc
  cp conf/mysql/my.cnf $INSTALL_DIR/etc/
  sed -i "s%\$HOME%$HOME%g" $INSTALL_DIR/etc/my.cnf
  sed -i "s%\$HOSTNAME%$HOSTNAME%g" $INSTALL_DIR/etc/my.cnf
fi

mkdir -p $HOME/bin
cd $HOME/bin
ln -sf ../mysql/bin/mysql mysql

cd $INSTALL_DIR
mkdir -p $DATA_DIR
scripts/mysql_install_db --datadir=$DATA_DIR
if [ -f etc/my.cnf ]
then
  bin/mysqld_safe --defaults-file=etc/my.cnf &
else
  bin/mysqld_safe &
fi
