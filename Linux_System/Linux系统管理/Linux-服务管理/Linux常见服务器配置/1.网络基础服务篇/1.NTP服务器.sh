#!/usr/bin/env sh
# NTP(Network Time Protocol,网络时间协议)
# 服务器可以同时与到过时间服务器连接，利用统计学的算法过滤来自不同服务器的时间，以选择最佳的路径和来源来校正主机时间。
# 时间服务器与其他服务器进行时间校对的3中方式：
	# 1.broadcast/multicast 主要适用于局域网环境，时间服务器周期性地以广播的方式将时间信息传送给其他网络中的时间服务器，其时间仅会有少许的延迟，而且配置非常简单，
		# 该方式的精确度不高，对时间精确度要求不是很高的情况下可以采用
	# 2.symmetric 该方式一台服务器可以从远端时间服务器获取时钟，如果需要也可以提供时间信息给远端的时间服务器。
		# 适用于配置冗余的时间服务器，可以提供更高的精确度给主机
	# client/server 与symmetric方式相似，只是不提供给其他时间服务器时间信息
		# 此方式适用于一台时间服务器接收上层时间服务器的时间信息，并提供时间信息给下层的用户。

1.安装
# 检查是否安装
rpm -ql | grep ntp 
# 使用rpm包安装
rpm -ivh ntp-*.rpm
# rpm 卸载
rpm -e ntp*.rpm 

# 使用yum安装
yum -y install ntp
# yum 卸载
yum remove -y ntp 


2.服务管理
# centos 6
service ntpd start 
service ntpd stop
service ntpd restart 
service ntpd reload
service ntpd status
# centos 6 自启动
chkconfig ntpd on 		# 在运行级别2、3、4、5设置自动运行
chkconfig ntpd off 		# 在运行级别2、3、4、5设置自动运行
chkconfig ntpd --level 35 on # 在运行级别3、5设置自动运行
chkconfig ntpd --level 35 off # 在运行级别3、5设置不自动运行

# centos 7
systemctl start ntpd
systemctl stop ntpd
systemctl restart ntpd
systemctl reload ntpd
systemctl status ntpd

systemctl enable ntpd
systemctl disable ntpd

3.配置文件详解
driftfile 文件名 	# 默认情况下NTP服务器的时间计算是依据BIOS的芯片震动周期频率来计算的，但是这个数值与上层NTP服务器可能不一致，所以NTP服务器会自动去计算NTP服务器的频率与上层NTP服务器的频率，并且将两个频率的误差记录在driftifile参数指定的文件中。保持默认即可
restrict default nomodify notrap nopeer noquery
restrict <IP> <子网掩码> | <网段> <子网掩码> [ignore|nomodify|noquery|notrap|notrust|nokod]
	ignore 关闭所有的NTP服务
	nomodify 表示客户端不能更改NTP服务器的时间参数，但可以通过NTP服务器进行时间校对
	noquery 不提供NTP服务
	notrap 	不提供trap远程事件登陆的功能
	notrust 拒绝没有通过认证的客户端
	kod 	kod技术可以阻止"Kiss of Death"包对服务器的破坏
	nopeer 不与其他同一层的NTP服务器进行时间同步

server [IP|FQDN] [prefer] # 指定NTP服务器上层NTP服务器，也就是为该服务器对自身进行时间校对的NTP服务器。如果指定多个上层NTP服务器时，使用prefer参数的服务器优先级最高。在没有prefer参数时，上层NTP服务器的优先级根据在配置文件的顺序从上到下，依次由高到低。在指定上层NTP服务器后，默认情况下至少15min后才会与上层NTP服务器进行时间校对

fudge 修改NTP服务器相关参数

broadcast 网段 子网掩码 # 指定进行NTP时间广播的网段，在不指定此参数时NTP服务器会对所有能访问的网段广播

logfile 文件名 # 指定NTP服务日志文件

# 默认配置
restrict default nomodify notrap nopeer noquery # 默认拒绝所有NTP客户端所有的操作，并打开kod功能

restrict 127.0.0.1 # 允许本地所有操作

server 127.127.1.0 # 如无法与这行之前定义的上传NTP服务器通信时，以本地时间为准

fudge 127.127.1.1 stratum 10 # 指定本地NTP服务器的层

# 与NTP服务有关的配置文件
/usr/share/zoneinfo/ # 该目录中的文件是规定了各主要时区的时间配置文件
/etc/sysconfig/clock # 该文件是指定熊中当前时区的信息
/etc/localtime 			# 该文件是系统通过/etc/sysconfig/clock将/usr/share/zoneinfo/下指定的时间配置文件复制为/etc/localtime

# 每个用户设置单独的时区,在该用户的家目录下修改配置文件.bashrc
export TZ=/usr/share/zoneinfo/<timezone_directory>/<timezone_file>

4.NTP配置实例

（1）/etc/ntp.conf 
restrict default kod nomodify notrap nopeer noquery

restrict 127.0.0.1
restrict -6 ::1

restrict 192.168.0.0 mask 255.255.255.0 nomodify notrap
restrict 192.168.1.0 mask 255.255.255.0 nomodify notrap

# 指定Internet上的时间服务器
restrict 207.46.232.182 mask 255.255.255.255 nomodify notrap noquery
server 207.46.232.182

server 127.127.1.0
fudge 127.127.1.0 stratum 10

keys /etc/ntp/keys

logfile /var/log/ntp # 指定NTP服务器的日志文件

（2）修改/etc/ntp/step-tickers文件，内容如下（当ntp服务启动时，会自动与该文件中记录的上传NTP服务进行时间校对）
207.46.232.182
127.127.1.0

（3）修改/etc/sysconfig/ntpd文件，内容如下：
# 允许 BIOS与系统花四溅同步，也可以通过hwclock -w命令
SYNC_HWCLOCK=yes

（4）在配置完成并重启启动服务后，可以通过ntpstat命令显示本机上一次与上层NTP服务器同步时间的情况。
ntpstat
# 结果解释
第一行 进行时间校对的NTP服务器
第二行 本地主机与上层NTP服务器的时间差
第三行 下次同步时间

也可以使用 ntpq -p 查看本机与上层NTP服务器通信情况
ntpq -p 
     remote           refid      st t when poll reach   delay   offset  jitter
==============================================================================
 210.72.145.44   .INIT.          16 u    -   64    0    0.000    0.000   0.000
 185.216.231.25  17.253.16.253    2 u    1   64    1  251.828  2425684   2.182
 ntp-3.arkena.ne 138.96.64.10     2 u    2   64    1  391.948  2425683   0.320
 ntp7.flashdance 194.58.202.20    2 u    1   64    1  316.254  2425684   3.242

各列含义：
remote 	# 本地主机所连接的上传NTP服务器
refid 	# 指的是给上层NTP服务器提供时间校对的服务器
st 		# 上层NTP服务器的级别
when 	# 上一次与上层NTP服务器进行时间校对的时间
poll 	# 下一次本地主机与上层NTP服务器进行时间校对的时间
reach 	# 一个八进制值记录已成功与上层NTP服务器进行时间校对的时间
delay 	# 从本地主机发送同步要求到上层NTP服务器的循环时间差
offset 	# 时间补偿的结果，单位10-6s,这个值非常关键，它是本地主机与上层NTP服务器的时间差，offset越接近于0，与上层NTP服务器的时间越接近
jitter 	# 一个做统计的值，该值统计在特定个连接数里offset的分布情况

# 相关命令
ntpstat 	# 显示ntp服务器相关状态
ntpq 		# 启动标注你的NTP查询
	# 选项
	-n 	# 以点十进制格式x.x.x.x显示所有的主机地址，而不是规范的主机名称
	-p 	# 显示服务器同级别设备的列表，及连接状态

ntpdate	# 指定立即进行时间校对的NTP服务器，以root身份在本地执行

ntptrace	# 跟踪网络计时协议主机链到他们的控制时间源
ntptrace [-n] [server]

hwclock # 显示与设定硬件时钟
