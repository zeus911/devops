#!/usr/bin/env bash

~/mysql/bin/mysqld_safe --defaults-file=~/mysql/etc/my.cnf &

sleep 3

~/mongodb/bin/mongod -f ~/mongodb/conf/mongod.cnf

sleep 3

~/php/sbin/php-fpm

sleep 3

sudo ~/nginx/sbin/nginx
