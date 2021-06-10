# 告警1 
WARNING overcommit_memory is set to 0! Background save may fail under low memory condition. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.
# 解决办法
echo "vm.overcommit_memory=1" >> /etc/sysctl.conf 	# 需要重启机器生效
echo 1 > /proc/sys/vm/overcommit_memory				# 无须重启机器，立即生效

# overcommit_memory参数说明：
设置内存分配策略（可选，根据服务器的实际情况进行设置）
/proc/sys/vm/overcommit_memory
可选值：0、1、2。
0， 表示内核将检查是否有足够的可用内存供应用进程使用；如果有足够的可用内存，内存申请允许；否则，内存申请失败，并把错误返回给应用进程。
1， 表示内核允许分配所有的物理内存，而不管当前的内存状态如何。
2， 表示内核允许分配超过所有物理内存和交换空间总和的内存


# 告警2
WARNING: The TCP backlog setting of 511 cannot be enforced because /proc/sys/net/core/somaxconn is set to the lower value of 128.
# 解决办法
echo 511 > /proc/sys/net/core/somaxconn

