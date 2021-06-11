# init 的 7 个级别
	0 完全关闭系统
	1 单用户模式
	2~5 多用户级别
	6 重新引导级别

# 实例启动脚本,管理sshd
#!/bin/sh
test -f /usr/bin/sshd || exit 0
case "$1" in
	start)
		echo -n "Starting sshd: sshd"
		/usr/sbin/sshd
		echo "."
		;;
	stop)
		echo -n "Stopping sshd: sshd"
		kill `cat /var/run/sshd.pid`
		echo "."
		;;
	restart)
		echo -n "Stopping sshd: sshd"
		kill `cat /var/run/sshd.pid`
		echo "."
		echo -n "Starting sshd: sshd"
		/usr/sbin/sshd
		echo "."
		;;
	*)
		echo "Usage: /etc/init.d/sshd start|stop|restart"
		exit 1
		;;
esac