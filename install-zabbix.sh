#!/usr/bin/env bash

BASE_DIR=`pwd`
SCRIPT_DIR=$(readlink -e $(dirname $0))

if [ $# -gt 0 ]
then
  VERSION=$1
else
  VERSION=2.0.6
fi
ZABBIX_SRC=zabbix-$VERSION.tar.gz
ZABBIX_DIR=${ZABBIX_SRC%.tar.gz}
INSTALL_DIR=$HOME/zabbix
DATA_DIR=$HOME/data/zabbix
WEB_DIR=$HOME/data/www/zabbix

if [ ! -f $ZABBIX_SRC ]
then
  wget http://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/$VERSION/zabbix-$VERSION.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fzabbix%2Ffiles%2FZABBIX%2520Latest%2520Stable%2F$VERSION%2Fzabbix-$VERSION.tar.gz%2Fdownload%3Fuse_mirror%3Dnchc&ts=1352271990&use_mirror=nchc
fi

sudo yum -y install net-snmp net-snmp-devel

if [ -d $ZABBIX_DIR ]
then
  rm -rf $ZABBIX_DIR
fi
tar zxf $ZABBIX_SRC
cd $ZABBIX_DIR
#./configure --prefix=$INSTALL_DIR --enable-server --enable-agent --enable-ipv6 --with-net-snmp --with-libcurl --with-mysql=/home/worker/mysql/bin/mysql_config
./configure --prefix=$INSTALL_DIR --enable-agent --enable-ipv6 --with-libcurl
make
make install

cd $SCRIPT_DIR
cp conf/zabbix/etc/* $INSTALL_DIR/etc/
sed -i "s%\$HOME%$HOME%g" $INSTALL_DIR/etc/zabbix_agentd.conf
sed -i "s%\$HOME%$HOME%g" $INSTALL_DIR/etc/zabbix_server.conf
sed -i "s/Server=zabbix-server/Server=zabbixserver.camera360.com/" $INSTALL_DIR/etc/zabbix_server.conf
sed -i "s/ServerActiv=zabbix-server/ServerActiv=zabbixserver.camera360.com/" $INSTALL_DIR/etc/zabbix_server.conf
mkdir -p $INSTALL_DIR/share/zabbix/externalscripts/
cp conf/zabbix/externalscripts/* $INSTALL_DIR/share/zabbix/externalscripts/
mkdir -p $INSTALL_DIR/share/zabbix/alertscripts/
cp conf/zabbix/alertscripts/* $INSTALL_DIR/share/zabbix/alertscripts/
:<<BLOCK
$HOME/mysql/bin/mysql -u root -e "create database zabbix character set utf8;"
$HOME/mysql/bin/mysql -u root -e "grant all on zabbix.* to 'zabbix'@'localhost';"
$HOME/mysql/bin/mysql -u root -e "grant all on zabbix.* to 'zabbix'@'127.0.0.1';"
$HOME/mysql/bin/mysql -u root -e "grant all on zabbix.* to 'zabbix'@'10.%';"
$HOME/mysql/bin/mysql -u zabbix zabbix <database/mysql/schema.sql
$HOME/mysql/bin/mysql -u zabbix zabbix <database/mysql/images.sql
$HOME/mysql/bin/mysql -u zabbix zabbix <database/mysql/data.sql
BLOCK
mkdir -p $DATA_DIR
#mkdir -p $WEB_DIR
#cp -a frontends/php/* $WEB_DIR

mkdir -p $HOME/bin
cd $HOME/bin
ln -sf ../zabbix/bin/zabbix_get zabbix_get
ln -sf ../zabbix/bin/zabbix_sender zabbix_sender

cd $INSTALL_DIR
#sbin/zabbix_server
sbin/zabbix_agentd
