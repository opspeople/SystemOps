计算机常用端口
DHCP：服务器端的端口号是67 
DHCP：客户机端的端口号是68 

POP3：POP3仅仅是接收协议，POP3客户端使用SMTP向服务器发送邮件。POP3所用的端口号是110。
 
SMTP：端口号是25。SMTP真正关心的不是邮件如何被传送，而只关心邮件是否能顺利到达目的地。

SMTP具有健壮的邮件处理特性，这种特性允许邮件依据一定标准自动路由，SMTP具有当邮件地址不存在时立即通知用户的能力，并且具有在一定时间内将不可传输的邮件返回发送方的特点。
 
Telnet：端口号是23。Telnet是一种最老的Internet应用，起源于ARPNET。它的名字是“电信网络协议（Telecommunication Network Protocol）”的缩写。
 
FTP：FTP使用的端口有20和21。20端口用于数据传输，21端口用于控制信令的传输，控制信息和数据能够同时传输，这是FTP的特殊这处。FTP采用的是TCP连接。

TFTP：端口号69，使用的是UDP的连接。 

DNS:53，名称服务 NetBIOS:137,138,139,其中137、138是UDP端口，当通过网上邻居传输文件时用这个端口。而139端口：通过这个端口进入的连接试图获得NetBIOS/SMB服务。这个协议被用于windows文件和打印机共享和SAMBA。还有WINS Regisrtation也用它。

NNTP 网络新闻传输协议:119 

SNMP（简单网络管理协议）:161端口 

RPC（远程过程调用）服务:135端口 

QQ:使用8000(服务端)和4000端口（客户端）

21 端口：21 端口主要用于FTP（File Transfer Protocol，文件传输协议）服务。

22 端口：SSH 为 Secure shell 的缩写，专为远程登录会话和其他网络服务提供安全性的协议。
 
23 端口：23 端口主要用于Telnet（远程登录）服务，是Internet上普遍采用的登录和仿真程序。
 
25 端口：25 端口为SMTP（Simple Mail Transfer Protocol，简单邮件传输协议）服务器所开放，主要用于发送邮件，如今绝大多数邮件服务器都使用该协议。
 
53 端口：53 端口为DNS（Domain Name Server，域名服务器）服务器所开放，主要用于域名解析，DNS 服务在NT 系统中使用的最为广泛。
 
67、68 端口：67、68 端口分别是为Bootp 服务的Bootstrap Protocol Server（引导程序协议服务端）和Bootstrap Protocol Client（引导程序协议客户端）开放的端口。
 
69 端口：TFTP 是Cisco 公司开发的一个简单文件传输协议，类似于FTP。
 
79 端口：79 端口是为Finger 服务开放的，主要用于查询远程主机在线用户、操作系统类型以及是否缓冲区溢出等用户的详细信息。
 
80 端口：80 端口是为HTTP（HyperText Transport Protocol，超文本传输协议）开放的，这是上网冲浪使用最多的协议，主要用于在WWW（World Wide Web，万维网）服务上传输信息的协议。 

99 端口：99 端口是用于一个名为“Metagram Relay”（亚对策延时）的服务 
该服务比较少见，一般是用不到的。 

109、110 端口：109 端口是为POP2（Post Office Protocol Version2，邮局协议2）服务开放的，110 端口是为POP3（邮件协议3）服务开放的，POP2、POP3 都是主要用于接收邮件的。 

111 端口：111 端口是SUN 公司的RPC（Remote Procedure Call，远程过程调用）服务所开放的端口，主要用于分布式系统中不同计算机的内部进程通信，RPC 在多种网络服务中都是很重要的组件。 

113 端口：113 端口主要用于Windows 的“Authentication Service”（验证服务）。 

119 端口：119 端口是为“Network News Transfer Protocol”（网络新闻组传输协议，简称NNTP）开放的。
 
135 端口：135 端口主要用于使用RPC（Remote Procedure Call，远程过程调用）协议并提供DCOM（分布式组件对象模型）服务。
 
137 端口：137 端口主要用于“NetBIOS Name Service”（NetBIOS名称服务）。 

139 端口：139 端口是为“NetBIOS Session Service”提供的，主要用于提供Windows 文件和打印机共享以及Unix 中的Samba 服务。
 
143 端口：143 端口主要是用于“Internet Message Access Protocol”v2（Internet 消息访问协议，简称IMAP）。
 
161 端口：161 端口是用于“Simple Network Management Protocol”（简单网络管理协议，简称SNMP）。 

443 端口：443 端口即网页浏览端口，主要是用于HTTPS 服务，是提供加密和通过安全端口传输的另一种HTTP。
 
554 端口：554 端口默认情况下用于“Real Time Streaming Protocol”（实时流协议，简称RTSP）。 

1024 端口：1024 端口一般不固定分配给某个服务，在英文中的解释是“Reserved”（保留）。 

1080 端口：1080 端口是Socks 代理服务使用的端口，大家平时上网使用的WWW 服务使用的是HTTP 协议的代理服务。
 
1755 端口：1755 端口默认情况下用于“Microsoft Media Server”（微软媒体服务器，简称MMS）。 

1158端口：Oracle EMCTL

1521端口：Oracle 数据库

2100端口：Oracle XDB FTP服务

8080端口：Oracle XDB（ XML 数据库）

3389端口：远程桌面 

7001端口：WebLogic

8080端口：Tomcat

9080端口：WebSphere应用程序

9090端口： WebSphere管理工具