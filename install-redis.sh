#!/usr/bin/env bash

BASE_DIR=`pwd`
SCRIPT_DIR=$(readlink -e $(dirname $0))

if [ $# -gt 0 ]
then
  VERSION=$1
else
  VERSION=2.8.9
fi
REDIS_SRC=redis-$VERSION.tar.gz
REDIS_DIR=${REDIS_SRC%.tar.gz}
INSTALL_DIR=$HOME/redis
DATA_DIR=$HOME/data/redis

if [ ! -f $REDIS_SRC ]
then
  wget http://download.redis.io/releases/$REDIS_SRC
fi
if [ -d $REDIS_DIR ]
then
  rm -rf $REDIS_DIR
fi
tar zxf $REDIS_SRC
cd $REDIS_DIR
make
make PREFIX=$INSTALL_DIR install

cd $SCRIPT_DIR
mkdir -p $INSTALL_DIR/conf/
cp conf/redis/* $INSTALL_DIR/conf/
sed -i "s%\$HOME%$HOME%g" $INSTALL_DIR/conf/*

mkdir -p $HOME/bin
cd $HOME/bin
ln -sf ../redis/bin/redis-cli redis-cli

mkdir -p $DATA_DIR
cd $INSTALL_DIR
bin/redis-server conf/redis.conf
