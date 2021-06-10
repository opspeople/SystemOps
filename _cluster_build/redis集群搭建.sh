#!/usr/bin/env sh
1.编译安装
# cd /usr/local/src/
# wget http://download.redis.io/releases/redis-5.0.0.tar.gz
# tar zxvf redis-5.0.0.tar.gz
# apt-get update && apt-get install -y gcc automake make
# cd redis-5.0.0 && make && make install
# cp ./src/redis-server /usr/bin/
# cp ./src/redis-cli /usr/bin/

2.创建服务启停脚本
# cp ./utils/redis_init_script /etc/init.d/redisd
# service redisd start

3.创建目录及配置文件
# mkdir /tmp/redis-cluster/{7000,7001,7002,7003,7004,7005}/log -pv
# cp /usr/local/src/redis-5.0.0/redis.conf /data/redis-cluster/7000/redis.conf
# cd /data/redis-cluster/ && cat 7000/redis.conf
bind 0.0.0.0
protected-mode yes
port 7000
tcp-backlog 511
timeout 0
tcp-keepalive 300
daemonize yes
supervised no
pidfile /var/run/redis_7000.pid
loglevel notice
logfile "/data/redis-cluster/7000/log/redis-7000.log"
databases 16
always-show-logo yes
save 900 1
save 300 10
save 60 10000
stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes
dbfilename dump.rdb
dir ./
replica-serve-stale-data yes
replica-read-only yes
repl-diskless-sync no
repl-diskless-sync-delay 5
repl-disable-tcp-nodelay no
replica-priority 100
lazyfree-lazy-eviction no
lazyfree-lazy-expire no
lazyfree-lazy-server-del no
replica-lazy-flush no
appendonly yes
appendfilename "appendonly.aof"
appendfsync everysec
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
aof-load-truncated yes
aof-use-rdb-preamble yes
lua-time-limit 5000
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 15000
slowlog-log-slower-than 10000
slowlog-max-len 128
latency-monitor-threshold 0
notify-keyspace-events ""
hash-max-ziplist-entries 512
hash-max-ziplist-value 64
list-max-ziplist-size -2
list-compress-depth 0
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
hll-sparse-max-bytes 3000
stream-node-max-bytes 4096
stream-node-max-entries 100
activerehashing yes
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit replica 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60
hz 10
dynamic-hz yes
aof-rewrite-incremental-fsync yes
rdb-save-incremental-fsync yes
masterauth AuDdQdpuEZpXgNthP6CjYjPb
requirepass AuDdQdpuEZpXgNthP6CjYjPb
修改其他端口配置文件
# cp 7000/redis.conf 7001/
# cp 7000/redis.conf 7002/
# cp 7000/redis.conf 7003/
# cp 7000/redis.conf 7004/
# cp 7000/redis.conf 7005/
# sed -i 's/7000/7001/g' 7001/redis.conf
# sed -i 's/7000/7002/g' 7002/redis.conf
# sed -i 's/7000/7003/g' 7003/redis.conf
# sed -i 's/7000/7004/g' 7004/redis.conf
# sed -i 's/7000/7005/g' 7005/redis.conf

4.调整内存分配使用方式并使其生效
#此参数可用的值为0,1,2 
#0表示当用户空间请求更多的内存时，内核尝试估算出可用的内存 
#1表示内核允许超量使用内存直到内存用完为止 
#2表示整个内存地址空间不能超过swap+(vm.overcommit_ratio)%的RAM值 
echo "vm.overcommit_memory=1">>/etc/sysctl.conf
sysctl -p

5.制作启动脚本
# cat start-redis-cluster.sh
#!/bin/bash

cd /data/redis-cluster

cd 7000 && /usr/bin/redis-server /data/redis-cluster/7000/redis.conf
cd ../7001 && /usr/bin/redis-server /data/redis-cluster/7001/redis.conf
cd ../7002 && /usr/bin/redis-server /data/redis-cluster/7002/redis.conf
cd ../7003 && /usr/bin/redis-server /data/redis-cluster/7003/redis.conf
cd ../7004 && /usr/bin/redis-server /data/redis-cluster/7004/redis.conf
cd ../7005 && /usr/bin/redis-server /data/redis-cluster/7005/redis.conf

6.启动服务
# bash start-redis-cluster.sh
# ps -ef|grep redis
root     30192     1  0 06:54 ?        00:00:04 /usr/bin/redis-server 0.0.0.0:7000 [cluster]
root     30194     1  0 06:54 ?        00:00:05 /usr/bin/redis-server 0.0.0.0:7001 [cluster]
root     30196     1  0 06:54 ?        00:00:04 /usr/bin/redis-server 0.0.0.0:7002 [cluster]
root     30201     1  0 06:54 ?        00:00:04 /usr/bin/redis-server 0.0.0.0:7003 [cluster]
root     30206     1  0 06:54 ?        00:00:05 /usr/bin/redis-server 0.0.0.0:7004 [cluster]
root     30211     1  0 06:54 ?        00:00:04 /usr/bin/redis-server 0.0.0.0:7005 [cluster]


7.创建集群
# redis-cli --cluster create 10.20.71.215:7000 10.20.73.204:7001 10.20.71.67:7002 10.20.71.215:7003 10.20.73.204:7004 10.20.71.67:7005 --cluster-replicas 1 -a AuDdQdpuEZpXgNthP6CjYjPb

8.查看集群信息
root@mgo-db01cn-t001:/usr/local/src/redis-5.0.0# redis-cli -c -p 7000
127.0.0.1:7000> auth AuDdQdpuEZpXgNthP6CjYjPb
OK
127.0.0.1:7000> cluster nodes
ab8eeb87cc65dd14d03b8ac1b1e8cf7956cec1f5 10.20.71.67:7005@17005 slave 113373eeb8450caf99f8bef80f7cf5e8be41f370 0 1556958626898 6 connected
387497dd41e34c90f4ccfa5909e2c63987d2f0d6 10.20.71.67:7002@17002 master - 0 1556958624893 3 connected 10923-16383
356ac5e0988889a793c055b99c1abff6579ba322 10.20.73.204:7004@17004 slave 387497dd41e34c90f4ccfa5909e2c63987d2f0d6 0 1556958625000 5 connected
3c1d7c057ac1d325fcf63895ae52733242abc72b 10.20.73.204:7001@17001 master - 0 1556958625000 2 connected 5461-10922
113373eeb8450caf99f8bef80f7cf5e8be41f370 10.20.71.215:7000@17000 myself,master - 0 1556958625000 1 connected 0-5460
54c72a2901af3dd72cbbb816bd6c5283eec6eec9 10.20.71.215:7003@17003 slave 3c1d7c057ac1d325fcf63895ae52733242abc72b 0 1556958625894 4 connected

# 控制台信息显示: 当前集群中存在3个主节点和3个从节点，说明我们的集群已经搭建成功 至此，Redis Cluster集群就搭建完成了!

9.测试数据
root@mgo-db01cn-t001:~# redis-cli -h 10.20.73.204 -p 7001
10.20.73.204:7001> auth AuDdQdpuEZpXgNthP6CjYjPb
OK
10.20.73.204:7001>
10.20.73.204:7001>
10.20.73.204:7001>
10.20.73.204:7001> set name shuke
OK
10.20.73.204:7001>
10.20.73.204:7001>
10.20.73.204:7001>
10.20.73.204:7001> get name
"shuke"

10.cluster saveconfig
将节点的配置文件保存到硬盘里面.
试一下：
127.0.0.1:7009> cluster saveconfig
OK
ok说明成功了,它会覆盖配置文件夹里的nodes.conf文件.这样做是为了某种情况下nodes文件丢失,这样就会生成一个最新的节点配置文件。

