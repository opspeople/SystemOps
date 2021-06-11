#!/bin/bash
# 内存占用过高
1.查看rsyslog日志状态
	systemctl status rsyslog
2.tail /var/log/messages 查看messages日志信息
3.journalctl --verify 检查系统日志卷文件损坏错误
# 解决办法
1.删除损坏的journal文件
2.删除/var/lib/rsyslog/imjournal.state文件
3.重启rsyslog
# 避免办法
1.修改配置/etc/rsyslog.conf，增加如下两行，然后重启systemctl restart rsyslog
$imjournalRatelimitInterval 0
$imjournalRatelimitBurst 0
2.关掉journal压缩配置
vi /etc/systemd/journald.conf，把#Compress=yes改成Compress=no，之后systemctl restart systemd-journald即可
3.升级systemd版本
升级到systemd-219-42.el7_4.4.x86_64，systemctl restart systemd-journald