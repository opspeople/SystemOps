NTP服务器监听的端口为UDP的123

本地防火墙开启运行客户端访问123端口，修改iptables配置文件
-A INPUT -m state --state NEW -m udp -p udp --dport 123 -j ACCEPT

安装时间服务器
yum -y install ntp ntpdate


修改ntp.conf配置文件
cp /etc/ntp.conf /etc/ntp.conf.bak

将如下两行#去掉即可
server 	127.127.1.0 	# local clock
fudge 	127.127.1.0 stratum 10
启动
systemctl start ntpd 


ntp客户机定时同步配置
10 06 * * * /usr/sbin/ntpdate ntp-server的IP >> /usr/local/logs/crontab/ntpdate.log 


ntp时间服务器的完整配置
driftfile /var/lib/ntp/drift
restrict default kod nomodify notrap nopeer noquery
restrict -6 default kod nomodify notrap nopeer noquery
restrict 127.0.0.1
restrict -6 ::1
server 127.127.1.0 	# local clock
fudge 127.127.1.0 stratum 10
includefile /etc/ntp/crypto/pw
keys /etc/ntp/keys


配置详解
restrict default ignore 	# 关闭所有的NTP要求封包
restrict 127.0.0.1 			# 开启内部递归网络接口lo
restrict 192.168.0.0 mask 255.255.255.0 nomodify # 在内部子网里面的客户端可以进行网络校时，但是不能修改NTP服务器的时间参数
server 198.123.30.132 		# 上级时间服务器
restrict 198.123.30.132 	# 开放server访问我们ntp的权限
driftfile /var/lib/ntp/drift # 在于上级服务器联系时所花费的时间，记录在driftfile参数后面的文件内
broadcastdelay 0.008 		# 广播延迟时间

客户端的配置
0 0 * * * /usr/sbin/ntpdate ntp-server的IP >> /usr/local/logs/crontab/ntpdate.log 2>&1
