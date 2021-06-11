#!/usr/bin/env sh
# 1.安装fping
$ wget https://fping.org/dist/fping-4.0.tar.gz
$ tar -xvf fping-4.0.tar.gz
$ cd fping-4.0/
$ ./configure
$ make && make install


# 使用
-4,--ipv4  	# 只ping IPv4 地址
-6,--ipv6	# 只ping IPv6 地址
-b,--size=BYTE	# 
-B,--backoff=N 	# 
-c,--count=N	# ping的次数
-f,--file=FILE 	# 从文件读取目标列表
-g,--generate	# 一个范围内的目标主机 -g 192.168.116.1 192.168.116.254

-H,--ttl=N		# 设置IP TTL值
-I,--iface=IFACE # 绑定一个接口
-l,--loop		# loop mode，一直发送ping
-m,--all		# 使用所有提供的IP地址
-M,--dontfrag	# set the don't fragment flag
-O,--tos=N		# 
-p,--period=MSEC	# 
-r,--retry=N	# 重试次数
-R,--random		# random packet data
-S,--src=IP 	# set source address
-t,--timeout=MSEC # individual target initial timeout ,默认500ms

# 输出选项
-a,--alive 		# 显示alive的目标
-A,--address	# 通过地址显示目标
-C,--vcount=N	# 在结果中详细输出目标
-D,--timestamp	# 在输出行前加上时间戳
-e,--elapsed	# show elapsed（过去） time on return packets
-i,--interval=MSEC # 发送ping的时间间隔
-n,--name		# 通过名字展示结果
-N,--netdata	# output compatible for netdata (-l -Q are required)
-o,--outage		# show the accumulated outage time (lost packets * packet interval)
-q,--quiet		# 退出
-Q,--squiet=SECS	# 和-q相同
-s,--stats		# 输出最后的状态
-u,--unreach	# 显示不可达的目标
-v,--version