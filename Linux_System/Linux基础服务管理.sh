#!/bin/bash

# NFS 网络文件系统管理
# 安装nfs
yum -y install nfs-utils rpcbind

# Server端配置
cat /etc/exports
/usr/local/share/nfs  192.168.85.131(rw,no_root_squash)

# 配置解释
	/usr/local/share/nfs 	共享资源路径，供nfs客户端挂载使用
	192.168.85.131			允许挂载使用的主机地址，可以是主机名、域名、IP地址等，支持通配符
	(rw,no_root_squash)		选项
		ro read only，只读权限
		rw read write 读写权限
		no_root_squash	信任客户端，根据用户UID进行判断，如果登录到NFS主机的是root，那么此用户就拥有对共享资源的最高权限。此参数很不安全，不建议使用
		root_squash 	系统预设值，当登录NFS主机的用户时root时，这个使用者的权限将被缩成匿名使用者，也就是它的UID与GID都会变成nfsnobody身份，只有可读权限
		all_squash		不管登录NFS主机的是什么用户，都会将共享文件的UID和GID映射为匿名用户nfsbody身份
		no_all_squash	系统预设值，保留共享文件的UID和GID默认权限。也就是客户端用户的UID和GID与服务端共享文件的UID和GID相同时，才有对共享文件的读写权限。这种选项保证了共享问价你的用户和组权限不会改变
		anonuid			将登录NFS主机的用户都设定成指定的UID，此UID必须存在于NFS Server端/etc/passwd中
		anongid 		于anonuid含义类似
		sync			资料同步写入磁盘中，默认选择
		async			资料会先暂时存放在内存中，不会直接写入硬盘

# 启动停止NFS服务
	systemctl start nfs
	# 启动NFS服务后用修改/etc/exports文件，重载nfs使配置生效
		exportsfs [-aruv] [Host:/path]
			-a 全部mount或者umount /etc/exports中的内容
			-r 重新mount /etc/exports中分享出来的目录
			-u umount目录
			-v 在export的时候，将详细的信息输出到屏幕上
			Host NFS客户端主机地址
			/path 指定NFS Server上需要共享出来的目录的完整路径
	# 通过exportfs命令临时增加一个共享策略
		exportfs 192.168.60.108:/home/test_user

# NFS客户端的设定
	yum -y install nfs-utils rpcbind
	systemctl enable rpcbind
	# 开始挂载目录
		mount -t nfs 192.168.85.130:/usr/local/share /mnt/130share
# 开机自动挂载NFS目录
	vim /etc/fstab
	192.168.85.130:/usr/local/share /mnt/130share nfs defaults 0 0
# NFS 的 NFSD的COPY数目设定
	# 参数为 /etc/sysconfig/nfs 中的 RPCNFSDCOUNT=
	# 修改后，重载配置
	systemctl restart nfs-config
	systemctl restart nfs 

#################################
# 任务调度进程crond
# crond简介
	crond是Linux下用来周期性地执行某种任务或等待处理某些事件的一个守护进程
	# 分类：
		系统任务调度
			配置文件： /etc/crontab
			# 文件内容如下：
				SHELL=/bin/bash							# SHELL变量指定了系统要使用哪个shell
				PATH=/sbin:/bin:/usr/sbin:/usr/bin		# 系统执行命令的路径
				MAILTO=root 							# 任务执行信息将通过电子邮件发送给root用户
				HOME=/									# 执行命令或者脚本时使用的主目录
				# For details see man 4 crontabs

				# Example of job definition:
				# .---------------- minute (0 - 59)
				# |  .------------- hour (0 - 23)
				# |  |  .---------- day of month (1 - 31)
				# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
				# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
				# |  |  |  |  |
				# *  *  *  *  * user-name  command to be executed

		用户任务调度
			用户定期要执行的工作，如用户数据备份、定时邮件提醒等
			使用crontab工具来定制自己的计划任务
			所有用户定义的crontab文件都被保存在/var/spool/cron目录中，其文件名与用户名一致
# crontab工具使用说明
crontab [-u user] [file]
crontab [-u user] [-e|-l|-r|-i]
	-u user 设定某个用户的crontab服务
	file 	file是命令文件的名字，表示将file作为crontab的任务列表文件并载入crontab
	-e 		编辑某个用户的crontab文件内容
	-l 		显示某个文件的crontab文件内容
	-r 		从/var/spool/cron目录中删除某个用户的crontab文件
	-i 		在删除用户的crontab文件时给确认提示
# crontab格式
	minute hour day month week command
	各字段可使用特殊字符：
		* 代表所有可能值
		, 用逗号隔开的值指定一个列表范围
		- 整数之间，表示一个整数范围
		/ 指定时间的间隔频率
# 例
	01 */3 * * * /usr/local/apache2/apachectl restart
	每隔3个小时重启一次apache服务
# 注意事项
	（1）注意环境变量问题
	（2）注意清理系统用户的邮件日志
		0 */3 * * * /usr/local/apache2/apachectl restart > /dev/null 2>&1
		