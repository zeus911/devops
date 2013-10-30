#!/usr/bin/env bash

BASE_DIR=`pwd`
SCRIPT_DIR=$(readlink -e $(dirname $0))

if [ $# -gt 0 ]
then
  VERSION=$1
else
  VERSION=3.2.0-1
fi
ERLANG_VERSION=1.0-1
INSTALL_DIR=$HOME/rabbitmq
DATA_DIR=$HOME/data/rabbitmq

wget http://packages.erlang-solutions.com/erlang-solutions-$ERLANG_VERSION.noarch.rpm
sudo rpm -Uvh erlang-solutions-$ERLANG_VERSION.noarch.rpm
sudo yum install erlang

sudo rpm --import http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
sudo yum install rabbitmq-server-$VERSION.noarch.rpm

sudo chkconfig rabbitmq-server on
sudo /sbin/service rabbitmq-server start
