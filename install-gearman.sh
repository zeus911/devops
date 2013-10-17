#!/usr/bin/env bash

BASE_DIR=`pwd`
SCRIPT_DIR=$(readlink -e $(dirname $0))

if [ $# -gt 0 ]
then
  VERSION=$1
else
  VERSION=1.1.11
fi
GEARMAN_SRC=gearmand-$VERSION.tar.gz
GEARMAN_DIR=${GEARMAN_SRC%.tar.gz}
INSTALL_DIR=$HOME/gearman
DATA_DIR=$HOME/data/gearman

sudo yum -y install boost boost-devel libevent libevent-devel sqlite sqlite-devel gperf uuid uuid-devel libuuid libuuid-devel

cd $BASE_DIR
if [ ! -f $GEARMAN_SRC ]
then
  wget "https://launchpad.net/gearmand/1.2/$VERSION/+download/$GEARMAN_SRC"
fi
if [ -d $GEARMAN_DIR ]
then
  rm -rf $GEARMAN_DIR
fi
tar zxf $GEARMAN_SRC
cd $GEARMAN_DIR
./configure --prefix=$INSTALL_DIR  --with-mysql=$HOME/mysql/bin/mysql_config
make
make install

mkdir -p $INSTALL_DIR/etc
cd $SCRIPT_DIR
cp conf/gearman/gearmand.conf $INSTALL_DIR/etc/
sed -i "s%\$HOME%$HOME%g" $INSTALL_DIR/etc/gearmand.conf

mkdir -p $HOME/bin
cd $HOME/bin
ln -sf ../gearman/bin/gearman gearman

mkdir -p $DATA_DIR/log
cd $INSTALL_DIR
sbin/gearmand --config-file=etc/gearmand.conf

