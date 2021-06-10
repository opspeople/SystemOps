#!/bin/bash

内存规划
必须参数设置：
	maxmemory # 最大内存参数，否则物理内存用超了就会大量使用swap，写RDB文件时的速度很慢，这个参数指的是info中的 used_memory 
	          # 预留55%内存是最安全的。重写AOF文件和RDB文件的进程（即使不做持久化，复制到Slave的时候也要写RDB）会fork出一条新进程来，采用了操作系统的Copy-On-Write策略
	          # 需要考虑内存碎片，假设碎片为1.2，如果机器内存是64G，那么64*45%/1.2=24G作为maxmemory是比较安全的规划
	          # Console打出来的报告，如”RDB: 1215 MB of memory used by copy-on-write”。在系统极度繁忙时，如果父进程的所有Page 在子进程写RDB过程中都被修改过了，就需要两倍内存
	          # 按照Redis启动时的提醒，设置：
	            echo "vm.overcommit_memory = 1" >> /etc/sysctl.conf
	          # 关闭THP，这个默认的Linux内存页面大小分配策略会导致RDB时出现巨大的latency和巨大的内存占用。关闭方法为：
	            echo never > /sys/kernel/mm/transparent_hugepage/enabled
                echo never > /sys/kernel/mm/transparent_hugepage/defrag
              # 当最大内存到达时，按照配置的Policy进行处理，默认策略为volatile-lru，对设置了expire time的key进行LRU清除（不是实际的expire time）
              # 如果数据没有设置expire time或者policy为noeviction，则直接报错，但此时系统仍支持get之类的读操作。
              # 其他过期策略：
                  # volatile-ttl 最接近expire time的
                  # allkeys-lru 对所有key都做LRU
                  注意 在一般的缓存系统中，如果没有设置超时时间，则lru的策略需要设置为 allkeys-lru，并且应用需要做好未命中的异常处理。
                  注意 特殊的，当redis当做DB时，请使用noneviction策略，但是需要对系统内存监控加强粒度
CPU规划
	CPU不求核数多，但求主频高，Cache大，因为redis主处理模式是单进程的。同时避免使用虚拟机。

网卡RPS设置
	RPS就是让网卡使用多核CPU的
	传统方法就是网卡多队列（RSS，需要硬件和驱动支持），RPS则是在系统层实现了分发和均衡。
	如果对redis网络处理能力要求高或者在生产上发现cpu0的，可以在OS层面打开这个内核功能。
	设置脚本：
#!/bin/bash
# Enable RPS (Receive Packet Steering)

rfc=32768
cc=$(grep -c processor /proc/cpuinfo)
rsfe=$(echo $cc*$rfc | bc)
sysctl -w net.core.rps_sock_flow_entries=$rsfe
for fileRps in $(ls /sys/class/net/eth*/queues/rx-*/rps_cpus)
do
	echo fff > $fileRps
done

for fileRfc in $(ls /sys/class/net/eth*/queues/rx-*/rps_flow_cnt)
do
	echo $rfc > $fileRfc
done

tail /sys/class/net/eth*/queues/rx-*/{rps_cpus,rps_flow_cnt}




服务器部署位置
	port 0 # 0 = do not listen on a port
	bind 127.0.0.1
	unixsocket /tmp/redis.sock # create a unix doain socket to listen on
	unixsocketperm 755         # set permissions for the socket


持久化设置
	RDB和AOF两者毫无关系，独立运行，如果使用了AOF，重启时只会从AOF文件载入数据，不会再管RDB文件
	持久化选择：
	    不持久化
	    RDB
	    RDB+AOF

	注意 官方不推荐只开启AOF持久化，AOF持久化恢复慢
	注意 开启AOF时应当关闭AOF自动rewrite，并在crontab中启动在业务低峰时段进行的bgrewrite。
	注意 如果在一台机器上部署多个redis实例，则关闭RDB和AOF的自动保存（save “”, auto-aof-rewrite-percentage 0），通过crontab定时调用保存
	    m h * * * redis-cli -p <port> BGSAVE
        m h */4 * * redis-cli -p <port> BGREWRITEAOF
    注意 持久化的部署规划上，如果为主从复制关系，建议主关闭持久化


多实例配置
    如果一台机器上防止多个redis实例，为了防止上下文切换导致的开销，可以采用taskset。
    taskset是linux提供的一个命令，可以让某个程序运行在某个或某些cpu上。
    显示进程运行的cpu
        taskset -p 6379
        pid 21629's current affinity mask: 3         '
        3是二进制2个低位均为1的bitmask，每个1对应一个cpu，表示该进程在2个cpu上运行
    指定进程运行在某个特定的CPU上
        taskset -pc 1 21629
        1表示进程只会运行在第二个cpu上，从0开始计数
    启动进程时指定cpu
         taskset -c 1 ./redis-server ../redis.conf
   
具体设置参数
	Daemonize 这个参数在使用supervisord这种进程管理工具时一定要设置为no，否则无法使用这些工具将redis启动。
	Dir RDB的位置，一定要事先创建好
	include 如果是多实例的话可以将公共的设置放在一个conf文件中，然后引用即可： include /redis/conf/redis-common.conf
	