1.修改zabbix_agent.conf配置文件
	UnsafeUserParameters=1
	UserParameter=ck_proc[*],/usr/bin/bash /scripts/proc.sh $1


2.编写监控脚本
cat /scripts/proc.sh
#!/bin/bash
proc_count=$(ps -ef|grep -Ev "grep|$0" | grep -c $1)
echo ${proc_count}

修改监控脚本可执行权限
chown -R zabbix.zabbix /scripts/

3.zabbix-server web监控页面配置监控项、触发器、图形等参数
