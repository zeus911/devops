#!/usr/bin/env bash

BASE_DIR=`pwd`
SCRIPT_DIR=$(readlink -e $(dirname $0))

if [ $# -gt 0 ]
then
  VERSION=$1
else
  VERSION=1.6.0
fi
INSTALL_DIR=$HOME/nginx

sudo yum -y install pcre pcre-devel openssl openssl-devel

cd $BASE_DIR
if [ -d nginx-http-concat ]
then
  rm -rf nginx-http-concat
fi
git clone https://github.com/alibaba/nginx-http-concat.git

cd $BASE_DIR
if [ ! -f nginx-$VERSION.tar.gz ]
then
  wget http://nginx.org/download/nginx-$VERSION.tar.gz
fi
if [ -d nginx-$VERSION ]
then
  rm -rf nginx-$VERSION
fi
tar zxf nginx-$VERSION.tar.gz
cd nginx-$VERSION
./configure --prefix=$INSTALL_DIR --with-http_stub_status_module --with-http_ssl_module --add-module=../nginx-http-concat
make
make install

cd $SCRIPT_DIR
cp conf/nginx/nginx.conf $INSTALL_DIR/conf/
cp -R conf/nginx/vhosts $INSTALL_DIR/conf/
sed -i "s%\$HOME%$HOME%g" $INSTALL_DIR/conf/nginx.conf
sed -i "s%\$USER%$USER%g" $INSTALL_DIR/conf/nginx.conf

mkdir -p $HOME/data/nginx/logs
cd $INSTALL_DIR
sudo sbin/nginx
