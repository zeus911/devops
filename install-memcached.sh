#!/usr/bin/env bash

if [ $# -gt 0 ]
then
  VERSION=$1
else
  VERSION=1.4.17
fi
MEMCACHED_SRC=memcached-$VERSION.tar.gz
MEMCACHED_DIR=${MEMCACHED_SRC%.tar.gz}
INSTALL_DIR=$HOME/memcached

if [ ! -f $MEMCACHED_SRC ]
then
  wget http://www.memcached.org/files/$MEMCACHED_SRC
fi

sudo yum -y install libevent libevent-devel

if [ -d $MEMCACHED_DIR ]
then
  rm -rf $MEMCACHED_DIR
fi
tar zxf $MEMCACHED_SRC

cd $MEMCACHED_DIR
./configure --prefix=$INSTALL_DIR
make
make install

cd $INSTALL_DIR
bin/memcached -d
