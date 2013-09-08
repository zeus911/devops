#!/bin/bash
# Script to fetch nginx statuses for tribily monitoring systems 
# Author: krish@toonheart.com
# License: GPLv2

# Set Variables
COMMAND_NAME=`basename $0`
if [ $# -ne 2 ]
then
  echo "Usage: $COMMAND_NAME zabbix_name"
  exit 1
fi
URL=$1
ZABBIX_NAME=$2
DATA_FILE="$HOME/data/zabbix/${COMMAND_NAME}_$ZABBIX_NAME.data"
LOG_FILE="$HOME/data/zabbix/${COMMAND_NAME}_$ZABBIX_NAME.log"

STATUS=`curl -s "$URL"`

echo "$STATUS" | awk -v ZABBIX_NAME=$ZABBIX_NAME '{print ZABBIX_NAME,$1,$2}' >$DATA_FILE

echo `date +"%F %T"` >>$LOG_FILE
#echo "$STATUS" | awk '{print $0}' >>$LOG_FILE
echo "$STATUS" | awk 'NF!=2 {print $0}' >>$LOG_FILE
zabbix_sender -vv -z 127.0.0.1 -i $DATA_FILE >>$LOG_FILE 2>&1

echo 0

