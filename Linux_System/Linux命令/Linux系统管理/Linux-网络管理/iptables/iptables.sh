# 相关概念
防火墙除了软件及硬件的分类，也可对数据封包的取得方式来分类，可分为代理服务器（proxy）及 封包过滤机制（IP Filter）

代理服务是一种网络服务，通常就架设在路由上面，可完整的掌控局域网的对外连接。

IP Filter这种方式可以直接分析最底层的封包表头数据来进行过滤，所以包括 MAC地址, IP, TCP, UDP, ICMP 等封包的信息都可以进行过滤分析的功能，
用途非常广泛。

其实Iptables服务不是真正的防火墙，只是用来定义防火墙规则功能的"防火墙管理工具"，将定义好的规则交由内核中的netfilter即网络过滤器来读取，
从而真正实现防火墙功能。

 
iptables抵挡封包的方式：
	拒绝让Internet的封包进入Linux主机的某些port
	拒绝让某些来源IP的封包进入
	拒绝让带有某些特殊标志(flag)的封包进入
	分析硬件地址(MAC)来提供服务

iptables命令中设置数据过滤或处理数据包的策略叫做规则，将多个规则合成一个链，叫规则链
规则链依处理数据包的位置不同分类：
	PREROUTING: 在进行路由判断之前所要进行的规则(DNAT/REDIRECT)
	INPUT: 处理入站的数据包
	OUTPUT: 处理出站的数据包
	FORWARD: 处理转发的数据包
	POSTROUTING: 在进行路由判断之后所要进行的规则(SNAT/MASQUERADE)

iptables中的规则表是用于容纳规则链，规则表默认是允许状态的，那么规则链就是设置被禁止的规则，
而反之如果规则表是禁止状态的，那么规则链就是设置被允许的规则

raw表: 确定是否对该数据包进行状态跟踪
mangle表: 为数据包设置标记(较少使用)
nat表: 修改数据包中的源、目标IP地址或端口
filter表: 确定是否放行该数据包(过滤)

raw表 		PREROUTING链 	OUTPUT链
mangle表		PREROUTING链 	POSTROUTING链	INPUT链		OUTPUT链 	FORWARD链
nat表		PREROUTING链		POSTROUTING链	OUTPUT链
filter表 	第一条规则 ... 	第n条规则 		FORWARD链 	OUTPUT链

规则表的先后顺序: raw -> mangle -> nat -> filter 

规则链先后顺序:
	入站顺序: PREROUTING -> INPUT 
	出站顺序: OUTPUT -> POSTROUTING
	转发顺序: PREROUTING -> FORWARD -> POSTROUTING

内检表与链的关系流程图：
封包进入 -> 		nat 	-> 	路由转发 	-> 	filter 	->  linux本机 -> nat 	-> 	filter -------->	nat 				-> 封包传出
			PREROUTING 		  				INPUT 					 OUTPUT 	OUTPUT 				POSTROUTING 		
										-> 	filter -------------------------------------------->  	nat 				-> 封包传出
											FORWARD   												POSTROUTING

另外注意：
	没有指定规则表则默认指filter表
	不指定规则链则指表内所有的规则链
	在规则链中匹配规则会依次检查，匹配即停止(LOG规则例外)，若没匹配项则按链的默认状态处理。

iptables命令中常见的控制类型有：
	accept 	允许通过
	log 	记录日志信息，然后传给下一条规则继续匹配
	reject 	拒绝通过，必要时会给出提示
	drop	直接丢弃，不给出任何回应

iptables命令基本参数和用法
iptables [-t 表名] 选项 [链名] [条件] [-j 控制类型]

更清晰写法：
iptables -[A|I 链] [-i|o 网络接口] [-p 协议] [-s 来源ip/网域] [-d 目标/网域] -j [ACCEPT|DROP]

常用参数：
	-P 设置默认策略：iptables -P INPUT (DROP|ACCEPT)
	-F 清空规则链
	-L 查看规则链
	-A 在规则链的末尾加入新规则
	-I num 在规则链的头部加入新规则
	-D num 删除某一条规则
	-s 匹配来源地址IP/MASK，加叹号"!"表示除这个IP外
	-d 匹配目标地址
	-i 网卡名称
	-o 网卡名称
	-p 匹配协议，如tcp,udp,icmp 
	--dport num 匹配目标端口号
	--sport num 匹配来源端口号

iptables规则查看
iptables [-t tables] [-L] [-nv]
	-t tables [nat|filter] 若省略此项目，则使用预设的filter
	-L 列出目前的table的规则
	-n 不进行IP与HOSTNAME的反查，显示讯息的速度会快很多
	-v 列出更多的信息，包括通过该规则的封包总位数，相关的网络接口等

iptables规则的清除
iptables [-t tables] [-FXZ]
	-F 清除所有的已订定的规则
	-X 杀掉所有使用者"自订"的chain
	-Z 将所有的chain的计数与流量统计都归零

策略(Policy)的清除
iptables [-t nat] -P [INPUT|OUTPUT|FORWARD] [ACCEPT,DROP]
	-P 定义策略，p为大写
iptables -P INPUT DROP
iptables -P OUTPPUT ACCEPT
iptables -P FORWARD ACCEPT

实例：
iptables 开放网口与IP来源
iptables -A INPUT -i ens192 -j ACCEPT
iptables -A INPUT -i ens192 -s 192.168.116.128 -j ACCEPT
iptables -A INPUT -i ens192 -s 192.168.116.0/24 -j ACCEPT
iptables -A INPUT -i ens192 -s 192.168.116.128 -j DROP

iptables 规则记录
iptables -A INPUT -s 192.168.116.128 -j LOG 
# 相关信息会被记录到/var/log/messages 中

iptables 开放tcp、udp端口
iptables -A INPUT -i ens192 -p udp -dport 137:138 -j ACCEPT 
iptables -A INPUT -i ens192 -p tcp -dport 80 -j ACCEPT


iptables 匹配ICMP端口和ICMP类型
iptables -A INPUT -p icmp --icmp-type 类型 -j ACCEPT
	--icmp-type 后面接ICMP的封包类型，也可以使用代号

iptables --syn的处理方式
指定tcp匹配扩展
--tcp-flags 根据tcp包的标志位进行过滤
iptables -A INPUT -p tcp --tcp-flags SYN,FIN,ACK SYN # 表示SYN,ACK,FIN的标志都检查，但是只有SYN匹配 
iptables -A FORWARD -p tcp --tcp-flags ALL SYN,ACK 		# 表示ALL所有标志都检查 ，仅(SYN,ACK)的匹配

iptables -A FORWARD -p tcp --syn 
--syn 相当于 "--tcp-flags SYN,RST,ACK SYN"的简写

iptables 状态模块
iptables -A INPUT -m state --state 状态
-m iptables的模块
	包括:
		state 	状态模块
		mac 	网络卡硬件地址(hardware address)

--state 封包的状态，主要有：
	INVALID 	无效的封包，如破损的封包状态
	ESTABLISHED 已经联机成功的联机状态
	NEW 		想要新建立联机的封包状态
	RELATED 	最常用，表示这个封包是与我们主机发送出去的封包有关
iptables -A INPUT -m state --state RELATED ESTABLISHED -j ACCEPT
iptables -A INPUT -m state --state INVALID -j DROP
# 对局域网内mac地址为00:0C:29:56:A6:A2主机开放其联机
iptables -A INPUT -m mac --mac-source 00:0C:29:56:A6:A2

iptables 保存与恢复
iptables-save > /etc/sysconfig/iptables.20200805
iptables-restore > /etc/sysconfig/iptables.20200805


iptables NAT (Network AddressTranslation网络地址转换)

# 局域网内封包的传送
	1.先经过NAT table的PREROUTING链
	2.经由路由判断确定这个封包是要进入本机与否，若不进入本机，则下一步
	3.再经过Filter table的FORWARD链；
	4.通过NAT table的POSTROUTING链，最后传送出去
NAT主机的重点就在于1,4两步
	PREROUTING 修改目的IP  	DNAT
	POSTROUTING 修改源IP 	SNAT

SNAT 源地址转换，能够让多个内网用户通过一个外网地址上网，解决了IP资源匮乏的问题
iptables -t nat -A POSTROUTING -s 192.168.116.129 -o ens192 -j SNAT --to-source 111.196.221.212
iptables -t nat -A POSTROUTING -d 192.168.116.129/32 -p tcp --sport 80 -j SNAT --to-source 111.196.221.212
外网地址不稳定的情况即可使用MASQUERADE(动态伪装),能够自动的寻找外网地址并改为当前正确的外网地址
iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -j MASQUERADE

DNAT 目的地址转换，则能够让外网用户访问局域网内不同的服务器
iptables -t nat -A PREROUTING -i ens192 -d 114.114.114.114 -p tcp --dport 80 -j DNAT --to-destination 192.168.10.6:80


iptables 使用REDIRECT单独进行端口转换
# 将 本机 80 端口的封包转递到 8080 端口
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8080










iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -t nat -A PREROUTING -d 198.203.187.150/32 -j DNAT --to-destination 198.203.182.116
iptables -t nat -A POSTROUTING -s 198.203.182.116/32 -j SNAT --to-source 198.203.187.150
