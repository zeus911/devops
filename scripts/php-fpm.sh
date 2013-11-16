#!/bin/sh

ulimit -SHn 65535

function stop_php()
{
	printf "Stoping PHP...\n"
	pid=`ps -ef |grep php-fpm |grep master |awk '{print $2}'`
	/bin/kill ${pid}
}

function start_php()
{
	printf "Starting PHP...\n"
	/home/worker/php/sbin/php-fpm
}

function kill_php()
{
	pid=`ps -ef |grep php-fpm |grep master |awk '{print $2}'`
	/bin/kill ${pid}
}

function restart_php()
{
	printf "Restarting PHP...\n"
	stop_php
	sleep 5
	start_php
}

if [ "$1" = "start" ]; then
    start_php
elif [ "$1" = "stop" ]; then
    stop_php
elif [ "$1" = "restart" ]; then
	restart_php
elif [ "$1" = "kill" ]; then
	kill_php
else
    printf "Usage: /home/worker/php/sbin/php-fpm {start|stop|restart|kill}\n"
fi