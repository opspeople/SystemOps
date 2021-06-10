#!/usr/bin/sh


一、RDB的持久化配置

# 时间策略
save 900 1
save 300 10
save 60 10000
# 文件名称
dbfilename dump.rdb
# 文件保存路径
dir /home/work/app/redis/data/
# 如果持久化出错，主进程是否停止写入
stop-writes-on-bgsave-error yes
# 是否压缩
rdbcompression yes
# 导入时是否检查
rdbchecksum yes
# 当然如果你想要禁用RDB配置，也是非常容易的，只需要在save的最后一行写上：save ""


二、AOF的配置

# 是否开启aof
appendonly yes
# 文件名称
appendfilename "appendonly.aof"
# 同步方式
appendfsync everysec
# aof重写期间是否同步
no-appendfsync-on-rewrite no
# 重写触发配置
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
# 加载aof时如果有错如何处理
aof-load-truncated yes
# 文件重写策略
aof-rewrite-incremental-fsync yes

# 还是重点解释一些关键的配置：
# appendfsync everysec 它其实有三种模式:
	always：把每个写命令都立即同步到aof，很慢，但是很安全
	everysec：每秒同步一次，是折中方案
	no：redis不处理交给OS来处理，非常快，但是也最不安全
# aof-load-truncated yes 如果该配置启用，在加载时发现aof尾部不正确是，会向客户端写入一个log，但是会继续执行，
# 如果设置为 no ，发现错误就会停止，必须修复后才能重新加载。


三、工作原理

# 关于原理部分，我们主要来看RDB与AOF是如何完成持久化的，他们的过程是如何。

# 在介绍原理之前先说下Redis内部的定时任务机制，定时任务执行的频率可以在配置文件中通过 hz 10 来设置（这个配置表示1s内执行10次，
# 也就是每100ms触发一次定时任务）。该值最大能够设置为：500，但是不建议超过：100，因为值越大说明执行频率越频繁越高，
# 这会带来CPU的更多消耗，从而影响主进程读写性能。

RDB的原理

在Redis中RDB持久化的触发分为两种：自己手动触发与Redis定时触发。

针对RDB方式的持久化，手动触发可以使用：

save：会阻塞当前Redis服务器，直到持久化完成，线上应该禁止使用。
bgsave：该触发方式会fork一个子进程，由子进程负责持久化过程，因此阻塞只会发生在fork子进程的时候。
而自动触发的场景主要是有以下几点：

根据我们的 save m n 配置规则自动触发；
从节点全量复制时，主节点发送rdb文件给从节点完成复制操作，主节点会触发 bgsave；
执行 debug reload 时；
执行 shutdown时，如果没有开启aof，也会触发。

AOF的原理

AOF的整个流程大体来看可以分为两步，一步是命令的实时写入（如果是 appendfsync everysec 配置，会有1s损耗），第二步是对aof文件的重写。

对于增量追加到文件这一步主要的流程是：命令写入=》追加到aof_buf =》同步到aof磁盘。那么这里为什么要先写入buf在同步到磁盘呢？如果实时写入磁盘会带来非常高的磁盘IO，影响整体性能。

aof重写是为了减少aof文件的大小，可以手动或者自动触发，关于自动触发的规则请看上面配置部分。fork的操作也是发生在重写这一步，也是这里会对主进程产生阻塞。

手动触发： bgrewriteaof，自动触发 就是根据配置规则来触发，当然自动触发的整体时间还跟Redis的定时任务频率有关系。

