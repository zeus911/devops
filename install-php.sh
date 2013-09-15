#!/usr/bin/env bash

BASE_DIR=`pwd`
SCRIPT_DIR=$(readlink -e $(dirname $0))

if [ $# -gt 0 ]
then
  VERSION=$1
else
  VERSION=5.3.25
fi
PHP_SRC=php-$VERSION.tar.gz
PHP_DIR=${PHP_SRC%.tar.gz}
INSTALL_DIR=$HOME/php
DATA_DIR=$HOME/data/php
BASE_DIR=`pwd`

sudo yum -y install gd gd-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel openssl openssl-devel libtool-ltdl libtool-ltdl-devel libxml2 libxml2-devel zlib zlib-devel bzip2 bzip2-devel curl curl-devel gettext gettext-devel libevent libevent-devel libxslt libxslt-devel expat expat-devel libmcrypt libmcrypt-devel

cd $BASE_DIR
if [ ! -f $PHP_SRC ]
then
  wget "http://www.php.net/get/$PHP_SRC/from/cn2.php.net/mirror"
fi
if [ -d $PHP_DIR ]
then
  rm -rf $PHP_DIR
fi
tar zxf $PHP_SRC
cd $PHP_DIR
./configure --prefix=$INSTALL_DIR --with-libdir=lib64 --enable-fpm --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-pdo-odbc=unixODBC,/usr --with-gd --with-jpeg-dir --with-png-dir --with-zlib-dir --with-freetype-dir --enable-gd-native-ttf --with-zlib --with-bz2 --with-openssl --with-curl --with-mcrypt --with-mhash --enable-zip --enable-exif --enable-ftp --enable-mbstring --enable-bcmath --enable-pcntl --enable-soap --enable-sockets --enable-sysvmsg --enable-sysvsem --enable-sysvshm --with-gettext --with-xsl --enable-wddx --with-libexpat-dir --with-xmlrpc
make
make install

cd $SCRIPT_DIR
cp conf/php/php.ini $INSTALL_DIR/lib/
sed -i "s%\$HOME%$HOME%g" $INSTALL_DIR/lib/php.ini
cp conf/php/php-fpm.conf $INSTALL_DIR/etc/
sed -i "s%\$HOME%$HOME%g" $INSTALL_DIR/etc/php-fpm.conf
cp conf/php/browscap.ini $INSTALL_DIR/etc/
mkdir $INSTALL_DIR/tmp
mkdir -p $DATA_DIR/log
mkdir -p $DATA_DIR/run

mkdir -p $HOME/bin
cd $HOME/bin
ln -sf ../php/bin/php php
ln -sf ../php/bin/phpize phpize
ln -sf ../php/bin/php-config php-config

cd $INSTALL_DIR
bin/pear config-set php_ini $INSTALL_DIR/lib/php.ini
bin/pear config-set temp_dir $INSTALL_DIR/tmp/pear/
bin/pear config-set cache_dir $INSTALL_DIR/tmp/pear/cache
bin/pear config-set download_dir $INSTALL_DIR/tmp/pear/download
bin/pecl channel-update pecl.php.net
bin/pecl install apc
bin/pecl install memcache
bin/pecl install redis
bin/pecl install mongo
bin/pecl install xdebug
bin/pecl install xhprof-beta

cp ../scripts/php-fpm.sh $HOME/php/sbin
chmod +x $HOME/php/sbin/php-fpm.sh
$HOME/php/sbin/php-fpm.sh start
