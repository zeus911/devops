#!/bin/bash
# Script to fetch phpfpm statuses
# Author: jaggerwang@gmail.com
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

STATUS=`curl "http://$HOST:$PORT/phpfpm_status"`
#echo "$STATUS" >>$LOG_FILE

echo "$ZABBIX_NAME phpfpm.start_time `echo "$STATUS" | awk NR==3 | awk '{{for(i=3;i<=NF;i++) printf $i" "; printf "\n";}}'`" >$DATA_FILE
echo "$ZABBIX_NAME phpfpm.start_since `echo "$STATUS" | awk NR==4 | awk '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME phpfpm.accepted_conn `echo "$STATUS" | awk NR==5 | awk '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME phpfpm.listen_queue `echo "$STATUS" | awk NR==6 | awk '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME phpfpm.max_listen_queue `echo "$STATUS" | awk NR==7 | awk '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME phpfpm.listen_queue_len `echo "$STATUS" | awk NR==8 | awk '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME phpfpm.idle_processes `echo "$STATUS" | awk NR==9 | awk '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME phpfpm.active_processes `echo "$STATUS" | awk NR==10 | awk '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME phpfpm.total_processes `echo "$STATUS" | awk NR==11 | awk '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME phpfpm.max_active_processes `echo "$STATUS" | awk NR==12 | awk '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME phpfpm.max_children_reached `echo "$STATUS" | awk NR==13 | awk '{print $NF}'`" >>$DATA_FILE

zabbix_sender -vv -z 127.0.0.1 -i $DATA_FILE >>$LOG_FILE 2>&1

echo 0

