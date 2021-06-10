#!/usr/bin/env bash
iptables IP包过滤器管理

iptables命令选项输入顺序
iptables -t 表名 <-A/I/D/R> 规则链名 [规则号] <-i/o 网卡名> -p 协议名 <-s 源IP/源子网> --sport 源端口 <-d 目标IP/目标子网> --dport 目的端口 -j 动作

配置总览
iptables -ADC 指定链的规则 [-A 添加 -D 删除 -C 修改]
iptables - RI
iptables -D chain rule num[option]
iptables -LFZ 链名 [选项]
iptables -[NX] 指定链 
iptables -P chain target[option]
iptables -E old-chain-name new-chain-name

targets
	# 防火墙的规则指定所检查包的特征，和目标。如果包不匹配，将送往该链中
	# 下一条规则检查；如果匹配,那么下一条规则由目标值确定.该目标值可以是
	# 用户定义的链名,或是某个专用值,如ACCEPT[通过],      DROP[删除],
	# QUEUE[排队],或者 RETURN[返回]。
	ACCEPT 	通过
	DROP 	丢弃
	QUEUE 	将包传递到用户空间
	RETURN  停止这条链的匹配，到前一个链的规则重新开始

tables
	-t table 

	filter	 默认表，包含了内建的链INPUT(进入)、FORWORD(通过)、OUTPUT(处理本地产生的包)
	nat 	 PREROUTING(修改到来的包)、OUTPUT(修改路由之前本地的包)、POSTROUTING(修改准备出去的包)
	mangle 	 对指定的包进行修改，两个内建链PREROUTING(修改路由之前进入的包)OUTPUT(修改路由之前本地的包)
	raw 	高级功能，如网址过滤

规则链名
	INPUT链 处理输入数据包
	OUTPUT链 处理输出数据包
	PORWARD链 处理转发数据包
	PREROUTING链 用于目标地址转换（DNAT）
	POSTOUTING链 用于源地址转换(SNAT)

动作包括
	accept 接收数据包
	DROP 丢弃数据包
	REDIRECT 重定向、映射、透明代理
	SNAT 源地址转换
	DNAT 目标地址转换
	MASQUERADE IP伪装(NAT),用于ADSL
	LOG 日志记录

options
	-A --append 在所选择的链末尾加一条或更多规则
	-D --delete 从所选链中删除一条或更多规则
	-R --replace 从选择的链中取代一条规则
	-I --insert 根据给出的规则序号向所选链中插入一条或更多规则，如果规则序号为1，规则会被插入链的头部。这也是不指定规则序号时的默认方式。
	-L --list	显示所选链的所有规则，如果没有选择链，所有链将被显示
	-F --flush 	清空所选链。这等于吧所有规则一个个的删除
	-Z --zero 	把所有链的包及字节的计数器清空
	-N --new-chain 根据给出的名称建立一个新的用户定义链
	-X --delete-chain 删除指定的用户自定义链。这个链必须没有被引用，如果被引用，在删除之前你必须删除或者替换与之有关的规则。如果没有给出参数，这条命令将试着删除每个非内建的链。
	-P --policy 设置链的目标规则
	-E --rename-chain 根据用户给出的名字对指定链进行重命名，这仅仅是修饰，对整个表的结构没有影响。
	-p 指定要匹配的数据包协议类型
	-s 指定要匹配的数据源ip地址

参数
	以下参数构成规则详述，如用于add、delete、replace、append和check命令

### 实例
清除已有iptables规则
	iptables -F 
	iptables -X
	iptables -Z

开放指定的端口
	iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT # 允许本地回环接口
	iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT # 允许已建立的或相关连的通行
	iptables -A OUTPUT -j ACCEPT # 允许所有本机向外的访问
	iptables -A INPUT -p tcp --dport 22 -j ACCEPT # 允许访问22端口
	iptables -A INPUT -j reject # 禁止其他未允许的规则访问
	iptables -A FORWORD -j REJECT # 禁止其他未允许的规则访问

屏蔽IP
	iptables -I INPUT -s 192.168.116.7 -j DROP # 屏蔽单个IP的命令
	iptables -I INPUT -s 192.168.116.0/8 -j DROP # 屏蔽整个网段

查看已添加的iptables规则
	iptables -L -n -v

删除已添加的iptables规则
	将所有的iptables以序号标记显示
	iptables -L -n --line-numbers

	删除序号为8的规则
		iptables -D INPUT 8