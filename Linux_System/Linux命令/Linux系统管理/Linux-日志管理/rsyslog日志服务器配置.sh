#!/bin/bash


#服务器端设定（192.168.0.210）：

[root@localhost ~]# vi /etc/rsyslog.conf
…省略部分输出…
# Provides TCP syslog reception
$ModLoad imtcp
$InputTCPServerRun 514
#取消这两句话的注释，允许服务器使用TCP 514端口接收日志
…省略部分输出…
[root@localhost ~]# service rsyslog restart
#重启rsyslog日志服务
[root@localhost ~]# netstat -tlun | grep 514
tcp 0 0 0.0.0.0：514 0.0.0.0：* LISTEN
#查看514端口已经打开



#客户端设置（192.168.0.211）：

[root@www1 ~]# vi /etc/rsyslog.conf
#修改日志服务配置文件
*.* @@192.168.0.210：514
#把所有日志采用TCP协议发送到192.168.0.210的514端口上
[root@www1 ~]# service rsyslog restart
#重启日志服务