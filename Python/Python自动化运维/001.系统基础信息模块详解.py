#!/usr/local/python3.7.9/bin/python3
###########################
psutil
# 系统性能信息模块 
# 获取系统性能信息
# 能够实现获取系统运行进程和系统利用率（CPU、内存、磁盘、网络）信息
import psutil
# cpu信息
psutil.cpu_times()
psutil.cpu_times().user	# 用户的cpu时间比
psutil.cpu_count(logical=False)
# 内存信息
psutil.virtual_memory()	
psutil.virtual_memory().total
# 磁盘信息
psutil.disk_partitions()
psutil.disk_usage('/')
psutil.disk_io_counters(perdisk=True)
# 网络信息
psutil.net_io_counters()
psutil.net_io_counters(pernic=True)
# 其他信息
psutil.users()
psutil.boot_time()

# 系统进程管理方法
# 进程信息
psutil.pids()	# 列出进程id
psutil.exists()
p = psutil.Process(2555) # 实例化一个Process对象，参数为进程ID
p.name()
p.exe()		# 进程bin路径
p.status()
p.create_time()
p.uids()
p.cpu_times()
p.cpu_affinity()	# get进程CPU亲和度，如要设置CPU亲和度，将CPU号作为参数即可
p.memory_info()
p.io_counters()
p.connections()
p.num_threads()
## popen类
# psutil 提供的popen类的作用是获取用户启动的应用程序进程信息
import psutil
from subprocess import PIPE
p = psutil.Popen(["/usr/bin/python", "-c", "print('hello')"], stdout=PIPE)
p.name()
p.username()
p.communicate()
p.cpu_times()

##########################################
IPy
# 实用的IP地址处理模块
from IPy import IP 
ip = IP('192.168.1.0/24')
print ip.len()	# 包含IP地址数量
for x in ip:
	print(x)	# 输出包含的全部IP

IP.reverseNames()	# 反向解析IP地址
IP.iptype()
IP.int()
IP.strHex()
IP.strBin()
IP(0x8080808)	# 转换成真实IP

