#!/bin/bash
[root@localhost ~]# chattr +a /var/log/alert.log #先给日志文件赋予chattr的a属性，保证日志的安全
[root@localhost ~]# vi /etc/logrotate.d/alter
#创建alter轮替文件,把/var/log/alert.log加入轮替
/var/log/alert.log {
    weekly
    #每周轮替一次
    rotate 6
    #保留6个轮替曰志
    sharedscripts
    #以下命令只执行一次
    prerotate
    #在日志轮替之前执行
        /usr/bin/chattr -a /var/log/alert.log
        #在日志轮替之前取消a属性,以便让日志可以轮替
    endscript
    #脚本结朿
    sharedscripts
    postrotate
    #在日志轮替之后执行
        /usr/bin/chattr +a /var/log/alert.log
        #在日志轮替之后,重新加入a属性
    endscript
    sharedscripts
    postrotate
    /bin/kill -HUP $(/bin/cat /var/run/syslogd.pid 2>/dev/null) fi>/dev/null
    endscript
    #重启rsyslog服务，保证日志轮替正常进行
}
