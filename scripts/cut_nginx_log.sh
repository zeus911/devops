#!/usr/bin/env bash
# This script run at 00:00
# cut yesterday log and gzip the day before yesterday log files.
# yesterday logs to awstats
 
LOGS_DIR="$HOME/data/nginx/logs"
DAY_DIR=$LOGS_DIR/$(date -d "yesterday" +"%Y")/$(date -d "yesterday" +"%m")/$(date -d "yesterday" +"%d")
DAY_GZIP_DIR=$LOGS_DIR/$(date -d "-2 day" +"%Y")/$(date -d "-2 day" +"%m")/$(date -d "-2 day" +"%d")
 
if [ ! -d $DAY_DIR ]
then
  mkdir -p $DAY_DIR
fi
mv $LOGS_DIR/*access.log $DAY_DIR/

sudo /home/worker/nginx/sbin/nginx -s reopen
#sudo /bin/kill -USR1 `cat /home/worker/data/nginx/logs/nginx.pid`

if [ -d $DAY_GZIP_DIR ]
then
  /usr/bin/gzip $DAY_GZIP_DIR/*.log
fi
