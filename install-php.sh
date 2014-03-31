#!/usr/bin/env bash

BASE_DIR=`pwd`
SCRIPT_DIR=$(readlink -e $(dirname $0))

if [ $# -gt 0 ]
then
  VERSION=$1
else
  VERSION=5.5.10
fi
PHP_SRC=php-$VERSION.tar.gz
PHP_DIR=${PHP_SRC%.tar.gz}
INSTALL_DIR=$HOME/php
DATA_DIR=$HOME/data/php
BASE_DIR=`pwd`

sudo yum -y install gd gd-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel openssl openssl-devel libtool-ltdl libtool-ltdl-devel libxml2 libxml2-devel zlib zlib-devel bzip2 bzip2-devel curl curl-devel gettext gettext-devel libevent libevent-devel libxslt libxslt-devel expat expat-devel libicu libicu-devel

cd $BASE_DIR
if [ ! -f $PHP_SRC ]
then
  wget "http://www.php.net/get/$PHP_SRC/from/www.php.net/mirror"
fi
if [ -d $PHP_DIR ]
then
  rm -rf $PHP_DIR
fi
tar zxf $PHP_SRC
cd $PHP_DIR
./configure --prefix=$INSTALL_DIR --enable-fpm --with-mysql --with-mysqli --with-pdo-mysql --with-gd --with-zlib --with-bz2 --with-openssl --with-curl --with-mhash --enable-zip --enable-exif --enable-ftp --enable-mbstring --enable-bcmath --enable-pcntl --enable-soap --enable-sockets --enable-sysvmsg --enable-sysvsem --enable-sysvshm --with-gettext --with-xsl --with-xmlrpc --with-readline --enable-calendar --enable-intl --enable-opcache --with-pear
make
make install
cp php.ini-development $INSTALL_DIR/lib/php.ini

cd $INSTALL_DIR
#bin/pear config-set php_ini $INSTALL_DIR/lib/php.ini
#bin/pear config-set temp_dir $INSTALL_DIR/tmp/pear/
#bin/pear config-set cache_dir $INSTALL_DIR/tmp/pear/cache
#bin/pear config-set download_dir $INSTALL_DIR/tmp/pear/download
#bin/pecl channel-update pecl.php.net
bin/pecl install memcache
bin/pecl install redis
bin/pecl install mongo
bin/pecl install xhprof-beta

cd $INSTALL_DIR
#sbin/php-fpm.sh start
