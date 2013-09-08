#!/bin/bash
# Script to fetch nginx statuses for tribily monitoring systems 
# Author: krish@toonheart.com
# License: GPLv2

# Set Variables
COMMAND_NAME=`basename $0`
if [ $# -ne 3 ]
then
  echo "Usage: $COMMAND_NAME host port zabbix_name"
  exit 1
fi
HOST=$1
PORT=$2
ZABBIX_NAME=$3
DATA_FILE="$HOME/data/zabbix/${COMMAND_NAME}_$ZABBIX_NAME.data"
LOG_FILE="$HOME/data/zabbix/${COMMAND_NAME}_$ZABBIX_NAME.log"

STATUS=`curl "http://$HOST:$PORT/nginx_status"`

echo "$ZABBIX_NAME nginx.conn.active `echo "$STATUS" | awk NR==1 | awk '{print $NF}'`" >$DATA_FILE
echo "$ZABBIX_NAME nginx.conn.accepts `echo "$STATUS" | awk NR==3 | awk '{print $1}'`" >>$DATA_FILE
echo "$ZABBIX_NAME nginx.conn.handled `echo "$STATUS" | awk NR==3 | awk '{print $2}'`" >>$DATA_FILE
echo "$ZABBIX_NAME nginx.req.reading `echo "$STATUS" | awk NR==4 | awk '{print $2}'`" >>$DATA_FILE
echo "$ZABBIX_NAME nginx.req.writing `echo "$STATUS" | awk NR==4 | awk '{print $4}'`" >>$DATA_FILE
echo "$ZABBIX_NAME nginx.req.waiting `echo "$STATUS" | awk NR==4 | awk '{print $6}'`" >>$DATA_FILE
echo "$ZABBIX_NAME nginx.req.requests `echo "$STATUS" | awk NR==3 | awk '{print $3}'`" >>$DATA_FILE

zabbix_sender -vv -z 127.0.0.1 -i $DATA_FILE >>$LOG_FILE 2>&1

echo 0

