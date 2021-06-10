# 问题： rsyslogd服务占用内存过多
# 解决办法：
vim /usr/lib/systemd/system/rsyslogd.service
# 在service配置项下新增配置
[Service]
MemoryMax=80M 			# 内存绝对上线80M
MemoryHigh=8M 			# 默认5M，设置上限为8M

systemctl daemon-reload
systemctl restart rsyslogd 