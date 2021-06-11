#!/bin/bash
# 格式
日志设备(类型).(连接符号)日志级别   日志处理方式(action)
日志设备(可以理解为日志类型):
———————————————————————-
auth        –pam产生的日志
authpriv    –ssh,ftp等登录信息的验证信息
cron        –时间任务相关
kern        –内核
lpr         –打印
mail        –邮件
mark(syslog)–rsyslog服务内部的信息,时间标识
news        –新闻组
user        –用户程序产生的相关信息
uucp        –unix to unix copy, unix主机之间相关的通讯
local 1~7   –自定义的日志设备

日志级别:
———————————————————————-
debug       –有调式信息的，日志信息最多
info        –一般信息的日志，最常用
notice      –最具有重要性的普通条件的信息
warning     –警告级别
err         –错误级别，阻止某个功能或者模块不能正常工作的信息
crit        –严重级别，阻止整个系统或者整个软件不能正常工作的信息
alert       –需要立刻修改的信息
emerg       –内核崩溃等严重信息
none        –什么都不记录
从上到下，级别从低到高，记录的信息越来越少
详细的可以查看手册: man 3 syslog

连接符号：
———————————————————————-
.xxx: 表示大于等于xxx级别的信息
.=xxx：表示等于xxx级别的信息
.!xxx：表示在xxx之外的等级的信息

Actions:
———————————————————————
1. 记录到普通文件或设备文件::
*.*     /var/log/file.log   # 绝对路径
*.*     /dev/pts/0
测试: logger -p local3.info ‘KadeFor is testing the rsyslog and logger ‘   logger 命令用于产生日志
2. 转发到远程::
*.* @192.168.0.1            # 使用UDP协议转发到192.168.0.1的514(默认)端口
*.* @@192.168.0.1:10514     # 使用TCP协议转发到192.168.0.1的10514(默认)端口
3. 发送给用户(需要在线才能收到)::
*.*   root
*.*   root,kadefor,up01     # 使用,号分隔多个用户
*.*   *     # *号表示所有在线用户
4. 忽略,丢弃::
local3.*   ~    # 忽略所有local3类型的所有级别的日志
5. 执行脚本::
local3.*    ^/tmp/a.sh      # ^号后跟可执行脚本或程序的绝对路径
# 日志内容可以作为脚本的第一个参数.
# 可用来触发报警
.. note::
日志记录的顺序有先后关系!
