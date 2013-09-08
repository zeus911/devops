#!/usr/bin/env bash

if [ $# -gt 0 ]
then
  VERSION=$1
else
  VERSION=7.1.1
fi
AWSTATS_SRC=awstats-$VERSION.tar.gz
AWSTATS_DIR=${AWSTATS_SRC%.tar.gz}
INSTALL_DIR=$HOME/awstats
DATA_DIR=$HOME/data/awstats
WEB_DIR=$HOME/data/www/awstats
SCRIPTS_DIR=$HOME/scripts

if [ ! -f $AWSTATS_SRC ]
then
  wget http://prdownloads.sourceforge.net/awstats/$AWSTATS_SRC
fi

if [ -d $AWSTATS_DIR ]
then
  rm -rf $AWSTATS_DIR
fi
tar zxf $AWSTATS_SRC
mv $AWSTATS_DIR $INSTALL_DIR
mkdir -p $SCRIPTS_DIR
cp scripts/cut_nginx_log.sh $SCRIPTS_DIR/
cp scripts/awstats.sh $SCRIPTS_DIR/
chmod +x $SCRIPTS_DIR/*.sh

mkdir -p $DATA_DIR
mkdir -p $WEB_DIR
cp -r $INSTALL_DIR/wwwroot/* $WEB_DIR/
mkdir $WEB_DIR/html
