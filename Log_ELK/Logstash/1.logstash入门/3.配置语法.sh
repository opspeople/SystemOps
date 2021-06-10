#!/usr/bin/env sh
# Logstash设计了自己的DSL，都是用Ruby语言写的
# 区域、注释、数据类型（布尔值、字符串数值、数组、哈希）都类似，条件判断、字段引用等也一样

# 1.区段 section
# Logstash用{}来定义区域。区域内可以包括插件区域定义，可以在一个区域内定义多个插件。
# 插件区域内则可以定义键值对设置
input {
	stdin {}
	syslog {}
}

# 2.数据类型
	# 希儿值 bool
	debug => true
	# 字符串 string
	host => "hostname"
	# 数值 number
	port => 514
	# 数组 array
	match => ["datetime", "UNIX", "ISO8601"]
	# 哈希 hash
	options => {
		key1 => "value1",
		key2 => "value2"
	}

# 3.字段引用
# 字段是Logstash::Event对象的属性
# 在logstash配置总使用字段的值，只需把字段的名字写在中括号[]里就行了，这就叫字段引用
[geoip][location][0]

# 4.条件判断 condition
# 支持的操作符
	equality,etc: ==, !=, <, >, <=, >=
	regexp: =~, !=
	inclusion: in, not, in
	boolean: and, or, nand, xor
	unary: !()

# 5.logstash命令行参数
-e 执行
bin/logstash -e 'input{stdin{}}output{stdout{}}'

--config或-f 文件

--configtest或-t

--log或-l

--pipeline-workers或-w

--pipeline-batch-size或-b

--pipeline-batch-delay或-u

--pluginpath或-P

--verbose

--debug

# 6.插件安装
/usr/share/logstash/bin/logstash-plugin -h
	install
	uninstall
	list
	update

# 7.长期运行方式
# 标准的service方式

# 最基础的nohup方式

# 优雅的screen方式
	# 创建独立的screen命令如下：
	screen -dmS elkscreen_1
	# 连接进入已创建的elkscreen_1的命令
	screen -r elkscreen_1
	# 退出screen而不中断服务，Ctrl+A+D
	# 查看创建的screen
	screen -list
# 最推荐的方式daemontools方式
	# 以supervisord为例，通过epel仓库安装
	yum -y install supervisord --enablerepo=epel
	# 修改配置文件/etc/supervisord.conf内容，定义要启动的程序
	[program:elkpro_1]
	environment=LS_HEAP_SIZE=5000m
	directory=/opt/logstash
	command=/opt/lostash/bin/logstash -f /etc/logstash/pro1.conf -w 10 -l /var/log/logstash/rpro1.log
	[program:elkpro_2]
	environment=LS_HEAP_SIZE=5000m
	directory=/opt/logstash
	command=/opt/lostash/bin/logstash -f /etc/logstash/pro2.conf -w 10 -l /var/log/logstash/rpro2.log
	# 然后启动supervisord即可
	systemctl start supervisord
	# Logstash会以supervisord子进程的身份运行，还可以使用supervisorctl命令，单独控制一系列子进程中某一个子进程的启停操作：
	supervisorctl stop elkpro_2

