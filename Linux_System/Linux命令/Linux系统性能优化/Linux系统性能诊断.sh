#!/bin/bash

# 诊断命令：
uptime 
dmesg | tail 
vmstat 1 
mpstat -P ALL 1 
pidstat 1 
iostat -xz 1 
free -m 
sar -n DEV 1 
sar -n TCP,ETCP 1 
top

uptime  
23:51:26 up 21:31, 1 user, load average: 30.02, 26.43, 19.02
# 这三个值是系统计算的 1 分钟、5 分钟、15 分钟的指数加权的动态平均值，可以简单地认为就是这个时间段内的平均值。

dmesg | tail 
# 这个命令显示了最新的几条系统日志。这里我们主要找一下有没有一些系统错误会导致性能的问题。

vmstat 1
procs ---------memory---------- ---swap-- -----io---- -system-- ------cpu----- 
r  b swpd   free   buff  cache   si   so    bi    bo   in   cs us   sy id wa st 
34  0    0 200889792  73708 591828    0    0     0     5    6   10  96  1  3  0  0 
32  0    0 200889920  73708 591860    0    0     0   592 13284 4282 98  1  1  0  0 
32  0    0 200890112  73708 591860    0    0     0     0  9501 2154 99  1  0  0  0 
32  0    0 200889568  73712 591856    0    0     0    48 11900 2459 99  0  0  0  0 
32  0    0 200890208  73712 591860    0    0     0     0 15898 4840 98  1  1  0  0
# vmstat 展示了虚拟内存、CPU 的一些情况。
#  1 表示每隔 1 秒钟显示一次。
# 指标分析
r
	处在 runnable 状态的任务，包括正在运行的任务和等待运行的任务。
	这个值比平均负载能更好地看出 CPU 是否饱和。
	这个值不包含等待 io 相关的任务。
	当 r 的值比当前 CPU 个数要大的时候，系统就处于饱和状态了。
free 
	以KB计算的空闲内存大小。
si，so
	换入换出的内存页。如果这两个值非零，表示内存不够了。
us，sy，id，wa，st
	用户态时间，内核态时间，空闲时间，等待 io，偷取时间(在虚拟化环境下系统在其它租户上的开销)
# 把用户态 CPU 时间(us)和内核态 CPU 时间(sy)加起来，我们可以进一步确认 CPU 是否繁忙。
# 等待 IO 的时间 (wa)高的话，表示磁盘是瓶颈;注意，这个也被包含在空闲时间里面(id)， CPU 这个时候也是空闲的，任务此时阻塞在磁盘 IO 上了。
# 你可以把等待 IO 的时间(wa)看做另一种形式的 CPU 空闲，它可以告诉你 CPU 为什么是空闲的。


mpstat -P ALL 1
# yum -y install sysstat 包含命令如下：
/usr/bin/cifsiostat
/usr/bin/iostat
/usr/bin/mpstat
/usr/bin/nfsiostat-sysstat
/usr/bin/pidstat
/usr/bin/sadf
/usr/bin/sar
/usr/bin/tapestat
执行结果：
Linux 3.10.0-957.el7.x86_64 (flask) 	11/22/2020 	_x86_64_	(1 CPU)
04:25:18 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
04:25:19 PM  all    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
04:25:19 PM    0    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
# 这个命令把每个 CPU 的时间都打印出来，可以看看 CPU 对任务的处理是否均匀。
# 比如，如果某一单个 CPU 使用率很高的话，说明这是一个单线程应用。

pidstat 1
# 查看进程可能存在的行为模式


iostat -xz 1
# iostat 是理解块设备(磁盘)的当前负载和性能的重要工具。几个指标的含义：
Linux 3.10.0-957.el7.x86_64 (flask) 	11/22/2020 	_x86_64_	(1 CPU)
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.12    0.00    0.17    0.12    0.00   99.59
Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
scd0              0.00     0.00    0.00    0.00     0.06     0.00   114.22     0.00   14.11   14.11    0.00  13.56   0.00
sda               0.00     0.03    0.59    0.11    29.97     5.53   101.47     0.01   11.27   11.27   11.28   4.34   0.30
dm-0              0.00     0.00    0.56    0.14    27.94     4.56    93.53     0.01   13.26   11.68   19.77   4.33   0.30
dm-1              0.00     0.00    0.01    0.00     0.15     0.00    54.67     0.00    0.22    0.22    0.00   0.20   0.00
r/s，w/s，rkB/s，wkB/s
	系统发往设备的每秒的读次数、每秒写次数、每秒读的数据量、每秒写的数据量。
	这几个指标反映的是系统的工作负载。
	系统的性能问题很有可能就是负载太大。
await
	系统发往 IO 设备的请求的平均响应时间。
	这包括请求排队的时间，以及请求处理的时间。
	超过经验值的平均响应时间表明设备处于饱和状态，或者设备有问题。
avgqu-sz
	设备请求队列的平均长度。
	队列长度大于 1 表示设备处于饱和状态。
%util
	设备利用率。
	设备繁忙的程度，表示每一秒之内，设备处理 IO 的时间占比。
	大于 60% 的利用率通常会导致性能问题(可以通过 await 看到)，但是每种设备也会有有所不同。
	接近 100% 的利用率表明磁盘处于饱和状态。

free -m 
              total        used        free      shared  buff/cache   available
Mem:           1.8G        105M        1.1G        9.5M        537M        1.5G
Swap:          2.0G          0B        2.0G
# buffers：用于块设备 I/O 的缓冲区缓存。
# cached：用于文件系统的页面缓存。


sar -n DEV 1
04:35:43 PM     IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s
04:35:44 PM        lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00
04:35:44 PM     ens33      2.97      0.99      0.17      0.16      0.00      0.00      0.00
# 查看网络接口的吞吐量：rxkB/s 和 txkB/s 可以测量负载，


sar -n TCP,ETCP 1
04:37:40 PM  active/s passive/s    iseg/s    oseg/s
04:37:41 PM      0.00      0.00      1.00      1.00
# active/s：每秒钟本地主动开启的 TCP 连接，也就是本地程序使用 connect() 系统调用
# passive/s：每秒钟从源端发起的 TCP 连接，也就是本地程序使用 accept() 所接受的连接
# retrans/s：每秒钟的 TCP 重传次数
atctive 和 passive 的数目通常可以用来衡量服务器的负载：接受连接的个数(passive)，下游连接的个数(active)。
可以简单认为 active 为出主机的连接，passive 为入主机的连接;但这个不是很严格的说法，比如 loalhost 和 localhost 之间的连接。


top
