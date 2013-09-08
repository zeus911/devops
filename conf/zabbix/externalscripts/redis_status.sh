#!/bin/bash
# Script to fetch redis statuses for tribily monitoring systems 
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

unit_conversion() {
  VALUE=$(trim $1)
  if [ `echo "$VALUE" | grep -E '^[0-9\.]+G$'` ]   
  then
    VALUE=`echo ${VALUE%G}*1024*1024*1024 | bc`
  elif [ `echo "$VALUE" | grep -E '^[0-9\.]+M$'` ]
  then
    VALUE=`echo ${VALUE%M}*1024*1024 | bc`
  elif [ `echo "$VALUE" | grep -E '^[0-9\.]+K$'` ]
  then
    VALUE=`echo ${VALUE%K}*1024 | bc`
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

STATUS=`redis-cli -h $HOST -p $PORT info`

echo "$ZABBIX_NAME redis.server.redis_version `echo "$STATUS" | grep 'redis_version:' | awk -F":" '{print $NF}'`" >$DATA_FILE
echo "$ZABBIX_NAME redis.server.redis_git_sha1 `echo "$STATUS" | grep 'redis_git_sha1:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.server.redis_git_dirty `echo "$STATUS" | grep 'redis_git_dirty:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.server.redis_mode `echo "$STATUS" | grep 'redis_mode:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.server.uptime_in_seconds `echo "$STATUS" | grep 'uptime_in_seconds:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.server.uptime_in_days `echo "$STATUS" | grep 'uptime_in_days:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.server.lru_clock `echo "$STATUS" | grep 'lru_clock:' | awk -F":" '{print $NF}'`" >>$DATA_FILE

echo "$ZABBIX_NAME redis.clients.connected_clients `echo "$STATUS" | grep 'connected_clients:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.clients.client_longest_output_list `echo "$STATUS" | grep 'client_longest_output_list:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.clients.client_biggest_input_buf `echo "$STATUS" | grep 'client_biggest_input_buf:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.clients.blocked_clients `echo "$STATUS" | grep 'blocked_clients:' | awk -F":" '{print $NF}'`" >>$DATA_FILE

echo "$ZABBIX_NAME redis.memory.used_memory" $(unit_conversion `echo "$STATUS" | grep 'used_memory:' | awk -F":" '{print $NF}'`) >>$DATA_FILE
echo "$ZABBIX_NAME redis.memory.used_memory_human" $(unit_conversion `echo "$STATUS" | grep 'used_memory_human:' | awk -F":" '{print $NF}'`) >>$DATA_FILE
echo "$ZABBIX_NAME redis.memory.used_memory_rss" $(unit_conversion `echo "$STATUS" | grep 'used_memory_rss:' | awk -F":" '{print $NF}'`) >>$DATA_FILE
echo "$ZABBIX_NAME redis.memory.used_memory_peak" $(unit_conversion `echo "$STATUS" | grep 'used_memory_peak:' | awk -F":" '{print $NF}'`) >>$DATA_FILE
echo "$ZABBIX_NAME redis.memory.used_memory_peak_human" $(unit_conversion `echo "$STATUS" | grep 'used_memory_peak_human:' | awk -F":" '{print $NF}'`) >>$DATA_FILE
echo "$ZABBIX_NAME redis.memory.used_memory_lua" $(unit_conversion `echo "$STATUS" | grep 'used_memory_lua:' | awk -F":" '{print $NF}'`) >>$DATA_FILE
echo "$ZABBIX_NAME redis.memory.mem_fragmentation_ratio `echo "$STATUS" | grep 'mem_fragmentation_ratio:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.memory.mem_allocator `echo "$STATUS" | grep 'mem_allocator:' | awk -F":" '{print $NF}'`" >>$DATA_FILE

echo "$ZABBIX_NAME redis.persistence.loading `echo "$STATUS" | grep 'loading:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.persistence.rdb_changes_since_last_save `echo "$STATUS" | grep 'rdb_changes_since_last_save:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.persistence.rdb_bgsave_in_progress `echo "$STATUS" | grep 'rdb_bgsave_in_progress:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.persistence.rdb_last_save_time `echo "$STATUS" | grep 'rdb_last_save_time:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.persistence.rdb_last_bgsave_status `echo "$STATUS" | grep 'rdb_last_bgsave_status:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.persistence.rdb_last_bgsave_time_sec `echo "$STATUS" | grep 'rdb_last_bgsave_time_sec:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.persistence.rdb_current_bgsave_time_sec `echo "$STATUS" | grep 'rdb_current_bgsave_time_sec:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.persistence.aof_enabled `echo "$STATUS" | grep 'aof_enabled:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.persistence.aof_rewrite_in_progress `echo "$STATUS" | grep 'aof_rewrite_in_progress:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.persistence.aof_rewrite_scheduled `echo "$STATUS" | grep 'aof_rewrite_scheduled:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.persistence.aof_last_rewrite_time_sec `echo "$STATUS" | grep 'aof_last_rewrite_time_sec:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.persistence.aof_current_rewrite_time_sec `echo "$STATUS" | grep 'aof_current_rewrite_time_sec:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.persistence.aof_last_bgrewrite_status `echo "$STATUS" | grep 'aof_last_bgrewrite_status:' | awk -F":" '{print $NF}'`" >>$DATA_FILE

echo "$ZABBIX_NAME redis.stats.total_connections_received `echo "$STATUS" | grep 'total_connections_received:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.stats.total_commands_processed `echo "$STATUS" | grep 'total_commands_processed:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.stats.instantaneous_ops_per_sec `echo "$STATUS" | grep 'instantaneous_ops_per_sec:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.stats.rejected_connections `echo "$STATUS" | grep 'rejected_connections:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.stats.expired_keys `echo "$STATUS" | grep 'expired_keys:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.stats.evicted_keys `echo "$STATUS" | grep 'evicted_keys:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.stats.keyspace_hits `echo "$STATUS" | grep 'keyspace_hits:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.stats.keyspace_misses `echo "$STATUS" | grep 'keyspace_misses:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.stats.pubsub_channels `echo "$STATUS" | grep 'pubsub_channels:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.stats.pubsub_patterns `echo "$STATUS" | grep 'pubsub_patterns:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.stats.latest_fork_usec `echo "$STATUS" | grep 'latest_fork_usec:' | awk -F":" '{print $NF}'`" >>$DATA_FILE

echo "$ZABBIX_NAME redis.replication.role `echo "$STATUS" | grep 'role:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.replication.connected_slaves `echo "$STATUS" | grep 'connected_slaves:' | awk -F":" '{print $NF}'`" >>$DATA_FILE

echo "$ZABBIX_NAME redis.cpu.used_cpu_sys `echo "$STATUS" | grep 'used_cpu_sys:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.cpu.used_cpu_user `echo "$STATUS" | grep 'used_cpu_user:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.cpu.used_cpu_sys_children `echo "$STATUS" | grep 'used_cpu_sys_children:' | awk -F":" '{print $NF}'`" >>$DATA_FILE
echo "$ZABBIX_NAME redis.cpu.used_cpu_user_children `echo "$STATUS" | grep 'used_cpu_user_children:' | awk -F":" '{print $NF}'`" >>$DATA_FILE

zabbix_sender -vv -z 127.0.0.1 -i $DATA_FILE >>$LOG_FILE 2>&1

echo 0

