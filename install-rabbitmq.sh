#!/usr/bin/env bash

BASE_DIR=`pwd`
SCRIPT_DIR=$(readlink -e $(dirname $0))

if [ $# -gt 0 ]
then
  VERSION=$1
else
  VERSION=3.2.1-1
fi
RABBITMQ_SRC=rabbitmq-server-$VERSION.noarch.rpm
ERLANG_VERSION=1.0-1
DATA_DIR=$HOME/data/rabbitmq

wget http://packages.erlang-solutions.com/erlang-solutions-$ERLANG_VERSION.noarch.rpm
sudo rpm -Uvh erlang-solutions-$ERLANG_VERSION.noarch.rpm
sudo yum -y install erlang

if [ ! -f $RABBITMQ_SRC ]
then
    wget "http://www.rabbitmq.com/releases/rabbitmq-server/v${VERSION%-*}/$RABBITMQ_SRC"
fi
sudo rpm --import http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
sudo yum -y install $RABBITMQ_SRC

sudo chkconfig rabbitmq-server on
sudo /sbin/service rabbitmq-server start
