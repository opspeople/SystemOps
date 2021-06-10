#!/usr/bin/env bash

# 1.简介
	# kafka是Apache下的一个子项目，是一个高性能跨语言分布式发布/订阅消息队列系统，使用Scala编写，它以可水平扩展和高吞吐率而被广泛使用。
	# 目前越来越多的开源分布式处理系统如Cloudera、Apache Storm、Spark都支持与Kafka集成。

# 用途：
# 搭建实时数据流管道，在系统或应用之间可靠的获取数据
# 搭建对数据流进行转换或相应的实时流应用程序

# kafka实现的功能，相关概念：
# Kafka是作为集群，运行在一台或多台服务器上的.
# Kafka集群用主题（topics）来分类别储存数据流（records）.
# 每个记录（record）由一个键（key），一个值（value）和一个时间戳（timestamp）组成

# Kafka的4个核心APIs：
	# Producer API负责生产数据流，允许应用程序将记录流发布到一个或多个Kafka主题（topics）.
	# Consumer API负责使用数据流，允许应用程序订阅一个或多个主题并处理为其生成的数据流.
	# Streams API负责处理或转化数据流，允许应用程序充当数据流处理器的角色, 处理来自一个或多个主题的输入数据流，并产生输出数据流到一个或多个输出主题，一次来有效地将输入流转换成输出流.
	# Connector API负责将数据流与其他应用或系统结合，允许搭建建和运行可重复使用的生产者或消费者，将Kafka数据主题与现有应用程序或数据系统相连接的。 例如，关系数据库的连接器可能会将表的每个更改的事件，都捕获为一个数据流.

# 2.依赖环境安装部署

# 环境准备
# Kafka集群的搭建是建立在jdk和zookeeper集群环境之上的

# 2.1 搭建java环境
yum -y install java-1.8.0-openjdk.x86_64

# 2.2 搭建zookeeper集群

# 3.搭建kafka集群
# 下载kafka二进制包，解压到/usr/local/kafka
# 修改配置文件/usr/local/kafka/config/service.propertites如下配置
broker.id=1
listeners=PLAINTEXT://192.168.1.2:9092 # kafka监听地址，填写本机地址
zookeeper.connection=192.168.1.2:2181,192.168.1.3:2181,192.168.1.3:2181 # zookeeper集群地址

# 编写service文件
cat /etc/rc.d/init.d/kafka
#!/usr/bin/env bash
# chkconfig: 2345 90 10
# description: kafka server
case $1 in
	start)
		/usr/local/kafka/bin/kafka-server-start.sh -daemon /usr/local/kafka/config/service.propertites;;
	stop)
		/usr/local/kafka/bin/kafka-server-stop.sh;;
esac

systemctl daemon-reload
chkconfig --add kafka
systemctl start kafka
