#!/usr/bin/env bash

if [ $# -gt 0 ]
then
  VERSION=$1
else
  VERSION=5.5.30
fi
MYSQL_SRC=mysql-$VERSION.tar.gz
MYSQL_DIR=${MYSQL_SRC%.tar.gz}
INSTALL_DIR=$HOME/mysql

if [ ! -f $MYSQL_SRC ]
then
  wget "http://dev.mysql.com/get/Downloads/MySQL-5.5/$MYSQL_SRC/from/http://cdn.mysql.com/"
  #wget "http://www.mysql.com/get/Downloads/MySQL-5.6/$MYSQL_SRC/from/http://cdn.mysql.com/"
fi

sudo yum -y install cmake ncurses ncurses-devel bison

if [ -d $MYSQL_DIR ]
then
  rm -rf $MYSQL_DIR
fi
tar zxf $MYSQL_SRC
cd $MYSQL_DIR/BUILD
cmake .. -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR
make
make install
mkdir $INSTALL_DIR/etc
cp ../../conf/mysql/my.cnf $INSTALL_DIR/etc/
sed -i "s%\$HOME%$HOME%g" $INSTALL_DIR/etc/my.cnf

mkdir -p $HOME/bin
cd $HOME/bin
ln -sf ../mysql/bin/mysql mysql

cd $INSTALL_DIR
mkdir -p $HOME/data
scripts/mysql_install_db --user=$USER --datadir=$HOME/data/mysql
bin/mysqld_safe --defaults-file=etc/my.cnf &
