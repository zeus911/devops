#!/bin/bash
# Script to fetch disk statuses for tribily monitoring systems 
# Author: krish@toonheart.com
# License: GPLv2

# Set Variables
export PATH=$PATH:$HOME/bin
COMMAND_NAME=`basename $0`
if [ $# -lt 2 ]
then
  echo "Usage: $COMMAND_NAME device zabbix_server_host [zabbix_server_port]"
  exit 1
fi
DEVICE=$1
ZABBIX_SERVER_HOST=$2
if [ $# -gt 2 ]
then
  ZABBIX_SERVER_PORT=$3
else
  ZABBIX_SERVER_PORT=10051
fi
HOSTNAME=`hostname`
DATA_FILE="$HOME/data/zabbix/${COMMAND_NAME}_$HOSTNAME.data"
LOG_FILE="$HOME/data/zabbix/${COMMAND_NAME}_$HOSTNAME.log"

STATUS=`iostat -kx 1 2| grep "$DEVICE " | tail -n 1`

echo "$HOSTNAME disk.iostat.wrqm `echo "$STATUS" | awk '{print $2}'`" >$DATA_FILE
echo "$HOSTNAME disk.iostat.wrqm `echo "$STATUS" | awk '{print $3}'`" >>$DATA_FILE
echo "$HOSTNAME disk.iostat.r `echo "$STATUS" | awk '{print $4}'`" >>$DATA_FILE
echo "$HOSTNAME disk.iostat.w `echo "$STATUS" | awk '{print $5}'`" >>$DATA_FILE
echo "$HOSTNAME disk.iostat.rkB `echo "$STATUS" | awk '{print $6}'`" >>$DATA_FILE
echo "$HOSTNAME disk.iostat.wkB `echo "$STATUS" | awk '{print $7}'`" >>$DATA_FILE
echo "$HOSTNAME disk.iostat.avgrq-sz `echo "$STATUS" | awk '{print $8}'`" >>$DATA_FILE
echo "$HOSTNAME disk.iostat.avgqu-sz `echo "$STATUS" | awk '{print $9}'`" >>$DATA_FILE
echo "$HOSTNAME disk.iostat.await `echo "$STATUS" | awk '{print $10}'`" >>$DATA_FILE
echo "$HOSTNAME disk.iostat.svctm `echo "$STATUS" | awk '{print $11}'`" >>$DATA_FILE
echo "$HOSTNAME disk.iostat.util `echo "$STATUS" | awk '{print $12}'`" >>$DATA_FILE

zabbix_sender -vv -z $ZABBIX_SERVER_HOST -p $ZABBIX_SERVER_PORT -i $DATA_FILE >>$LOG_FILE 2>&1

echo 0

