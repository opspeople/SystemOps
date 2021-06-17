#!/bin/sh
#
# Simple Redis init.d script conceived to work on Linux systems
# as it does use of the /proc filesystem.
 
#redis服务器监听的端口
REDISPORT=6379
 
#服务端所处位置
EXEC=/usr/local/bin/redis-server
 
#客户端位置
CLIEXEC=/usr/local/bin/redis-cli
 
#redis的PID文件位置，需要修改
PIDFILE=/var/run/redis_${REDISPORT}.pid
 
#redis的配置文件位置，需将${REDISPORT}修改为文件名
CONF="/etc/redis/${REDISPORT}.conf"
 
case "$1" in
    start)
        if [ -f $PIDFILE ]
        then
                echo "$PIDFILE exists, process is already running or crashed"
        else
                echo "Starting Redis server..."
                $EXEC $CONF
        fi
        ;;
    stop)
        if [ ! -f $PIDFILE ]
        then
                echo "$PIDFILE does not exist, process is not running"
        else
                PID=$(cat $PIDFILE)
                echo "Stopping ..."
                $CLIEXEC -p $REDISPORT shutdown
                while [ -x /proc/${PID} ]
                do
                    echo "Waiting for Redis to shutdown ..."
                    sleep 1
                done
                echo "Redis stopped"
        fi
        ;;
    *)
        echo "Please use start or stop as first argument"
        ;;
esac