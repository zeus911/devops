#!/bin/bash
# Script to fetch mongodb statuses for tribily monitoring systems 
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
HOSTNAME=$3
DATA_FILE="$HOME/data/zabbix/${COMMAND_NAME}_$HOSTNAME.data"
LOG_FILE="$HOME/data/zabbix/${COMMAND_NAME}_$HOSTNAME.log"

unit_conversion() {
  VALUE=$(trim $1)
  if [ `echo "$VALUE" | grep -E '^[0-9\.]+g$'` ]   
  then
    VALUE=`echo ${VALUE%g}*1024*1024*1024 | bc`
  elif [ `echo "$VALUE" | grep -E '^[0-9\.]+m$'` ]
  then
    VALUE=`echo ${VALUE%m}*1024*1024 | bc`
  elif [ `echo "$VALUE" | grep -E '^[0-9\.]+k$'` ]
  then
    VALUE=`echo ${VALUE%k}*1024 | bc`
  elif [ `echo "$VALUE" | grep -E '^[0-9\.]+$'` ]
  then
    VALUE=$VALUE
  else
    VALUE=0
  fi
  echo `echo "($VALUE+0.5)/1" | bc`
}

trim() {
  trimmed=`echo "$1" | sed 's/^[[:space:]]*//g'`
  trimmed=`echo "$1" | sed 's/[[:space:]]*$//g'`
  echo $trimmed
}

STATUS=`mongostat --host $HOST --port $PORT --rowcount 1 | tail -n 1`
if [ `echo "$STATUS" | awk '{print NF}'` -eq 21 ]
then
  echo "$HOSTNAME mongodb.mongostat.insert `echo "$STATUS" | awk '{print $1}'`" >$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.query `echo "$STATUS" | awk '{print $2}'`" >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.update `echo "$STATUS" | awk '{print $3}'`" >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.delete `echo "$STATUS" | awk '{print $4}'`" >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.getmore `echo "$STATUS" | awk '{print $5}'`" >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.command `echo "$STATUS" | awk '{print $6}'`" >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.flushes `echo "$STATUS" | awk '{print $7}'`" >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.mapped" $(unit_conversion `echo "$STATUS" | awk '{print $8}'`) >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.vsize" $(unit_conversion `echo "$STATUS" | awk '{print $9}'`) >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.res" $(unit_conversion `echo "$STATUS" | awk '{print $10}'`) >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.faults `echo "$STATUS" | awk '{print $11}'`" >>$DATA_FILE
  locked_db=`echo "$STATUS" | awk '{print $12}' | cut -d: -f2`
  echo "$HOSTNAME mongodb.mongostat.locked_db ${locked_db%%%}" >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.idx_miss `echo "$STATUS" | awk '{print $13}'`" >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.qr `echo "$STATUS" | awk '{print $14}' | cut -d'|' -f1`" >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.qw `echo "$STATUS" | awk '{print $14}' | cut -d'|' -f2`" >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.ar `echo "$STATUS" | awk '{print $15}' | cut -d'|' -f1`" >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.aw `echo "$STATUS" | awk '{print $15}' | cut -d'|' -f2`" >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.net_in" $(unit_conversion `echo "$STATUS" | awk '{print $16}'`) >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.net_out" $(unit_conversion `echo "$STATUS" | awk '{print $17}'`) >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.conn `echo "$STATUS" | awk '{print $18}'`" >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.set `echo "$STATUS" | awk '{print $19}'`" >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.repl `echo "$STATUS" | awk '{print $20}'`" >>$DATA_FILE
else
  echo "$HOSTNAME mongodb.mongostat.insert `echo "$STATUS" | awk '{print $1}'`" >$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.query `echo "$STATUS" | awk '{print $2}'`" >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.update `echo "$STATUS" | awk '{print $3}'`" >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.delete `echo "$STATUS" | awk '{print $4}'`" >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.getmore `echo "$STATUS" | awk '{print $5}'`" >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.command `echo "$STATUS" | awk '{print $6}'`" >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.vsize" $(unit_conversion `echo "$STATUS" | awk '{print $7}'`) >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.res" $(unit_conversion `echo "$STATUS" | awk '{print $8}'`) >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.faults `echo "$STATUS" | awk '{print $9}'`" >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.net_in" $(unit_conversion `echo "$STATUS" | awk '{print $10}'`) >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.net_out" $(unit_conversion `echo "$STATUS" | awk '{print $11}'`) >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.conn `echo "$STATUS" | awk '{print $12}'`" >>$DATA_FILE
  echo "$HOSTNAME mongodb.mongostat.repl `echo "$STATUS" | awk '{print $13}'`" >>$DATA_FILE
fi

zabbix_sender -vv -z 127.0.0.1 -i $DATA_FILE >>$LOG_FILE 2>&1

echo 0

