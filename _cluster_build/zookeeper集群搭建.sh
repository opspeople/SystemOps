#!/usr/bin/env bash
# zookeeper
# 01 下载对应版本
# 02 解压到/usr/local/zookeeper
# 03 编辑配置文件 zoo.cfg
cat /usr/local/zookeeper/conf/zoo.cfg
tickTime=2000 				# 心跳间隔周期 毫秒
initLimit=10 				# 初始连接超时阈值=10*tickTime 指的是follower初始连接leader的超时时间。如果网络环境不好，适当调大
syscLimit=5					# 连接超时阈值=syncLimit*tickTime.指的是follower和leader做数据交互的超时时间。如果网络环境不好，适当调大
dataDir=/data/zookeeper 	# 数据目录指的是zookeeper znode树的持久化目录
clientPort=2181				# 配置的是客户端连接zk服务器的端口号
# 集群配置
server.1=192.168.1.2:2888:3888
server.2=192.168.1.3:2888:3888
server.3=192.168.1.4:2888:3888

# 防火墙开放端口
iptables -I INPUT -p tcp --dport 2888 -j ACCEPT
iptables -I INPUT -p tcp --dport 3888 -j ACCEPT

# 启动服务
/usr/local/zookeeper/bin/zkServer.sh start

# 查看状态
/usr/local/zookeeper/bin/zkServer.sh status

# 停止服务
/usr/local/zookeeper/bin/zkServer.sh stop

# service文件编写及启动
cat /etc/rc.d/init.d/zookeeper
#!/usr/bin/env bash
# chkconfig: 2345 90 10
# description: manager kafka server
case $1 in
	start)
		/usr/local/zookeeper/bin/zkServer.sh start;;
	stop)
		/usr/local/zookeeper/bin/zkServer.sh stop;;
	status)
		/usr/local/zookeeper/bin/zkServer.sh status;;
esac
# 其中2345是默认启动级别，级别有0-6共7个级别。

#　　等级0表示：表示关机 　　

#　　等级1表示：单用户模式 　　

#　　等级2表示：无网络连接的多用户命令行模式 　　

#　　等级3表示：有网络连接的多用户命令行模式 　　

#　　等级4表示：不可用 　　

#　　等级5表示：带图形界面的多用户模式 　　

#　　等级6表示：重新启动

# 10是启动优先级，90是停止优先级，优先级范围是0－100，数字越大，优先级越低。

systemctl daemon-reload
chkconfig --add zookeeper
systemctl start zookeeper