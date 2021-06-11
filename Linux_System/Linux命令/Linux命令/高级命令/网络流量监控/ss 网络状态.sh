ss
ss命令用于显示socket状态. 他可以显示PACKET sockets, TCP sockets, UDP sockets, DCCP sockets, RAW sockets, Unix domain sockets等等统计

SS命令可以提供如下信息：
	所有的TCP sockets
	所有的UDP sockets
	所有ssh/ftp/ttp/https持久连接
	所有连接到Xserver的本地进程
	使用state（例如：connected, synchronized, SYN-RECV, SYN-SENT,TIME-WAIT）、地址、端口过滤
	所有的state FIN-WAIT-1 tcpsocket连接以及更多

常用ss命令
	ss -l 显示本地打开的所有端口
	ss -pl 显示每个进程具体打开的socket
	ss -t -a 显示所有tcp socket
	ss -u -a 显示所有的UDP Socekt
	ss -o state established '( dport = :smtp or sport = :smtp )' 显示所有已建立的SMTP连接
	ss -o state established '( dport = :http or sport = :http )' 显示所有已建立的HTTP连接
	ss -x src /tmp/.X11-unix/* 找出所有连接X服务器的进程
	ss -s 列出当前socket详细信息:
		显示sockets简要信息，列出当前已经连接，关闭，等待的tcp连接

	列出当前监听端口
	# ss -lRecv-Q Send-Q Local Address:Port Peer Address:Port
		0 10 :::5989 :::*
		0 5 *:rsync *:*
		0 128 :::sunrpc :::*
		0 128 *:sunrpc *:*
		0 511 *:http *:*
		0 128 :::ssh :::*
		0 128 *:ssh *:*
		0 128 :::35766 :::*
		0 128 127.0.0.1:ipp *:*
		0 128 ::1:ipp :::*
		0 100 ::1:smtp :::*
		0 100 127.0.0.1:smtp *:*
		0 511 *:https *:*
		0 100 :::1311 :::*
		0 5 *:5666 *:*
		0 128 *:3044 *:*

	ss列出所有http连接中的连接
		# ss -o state established '( dport = :http or sport = :http )'

ss常用的state状态：
	established
	syn-sent
	syn-recv
	fin-wait-1
	fin-wait-2
	time-wait
	closed
	close-wait
	last-ack
	listen
	closing
	all : All of the above states
	connected : All the states except for listen and closed
	synchronized : All the connected states except for syn-sent
	bucket : Show states, which are maintained as minisockets, i.e. time-wait and syn-recv.
	big : Opposite to bucket state.

ss使用IP地址筛选
	ss src ADDRESS_PATTERN
	src：表示来源
	ADDRESS_PATTERN：表示地址规则

	ss src 120.33.31.1 
	# 列出来之20.33.31.1的连接

ss使用端口筛选
	ss dport OP PORT
	OP:是运算符
	PORT：表示端口
	dport：表示过滤目标端口、相反的有sport

	OP运算符如下：
		<= or le : 小于等于 >= or ge : 大于等于
		== or eq : 等于
		!= or ne : 不等于端口
		< or lt : 小于这个端口 > or gt : 大于端口


