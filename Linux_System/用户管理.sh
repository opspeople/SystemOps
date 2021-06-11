#!/bin/bash
# 用户和组
# 用户的角色
	超级用户 root
	普通用户 只能对自己目录下的文件进行访问和修改，具有登录系统的权限
	虚拟用户 不能登录系统，方便管理系统，满足相应的系统进程对文件属主的要求
# 用户和组
	一对一
	一对多
	多对一
	多对多
# 用户配置文件
	/etc/passwd
	# 字段格式：
		用户名:口令:用户标识号:组标识号:注释性描述:主目录:默认shell
	/etc/shadow 用户密码文件
		# 字段描述
		用户名:加密口令:最后一次修改时间:最小时间间隔:最大时间间隔:警告时间:不活动时间:失效时间:保留字段
# 组配置文件
	/etc/group
	# 格式
		组名:口令:组标识号:组内用户列表
# 其他文件
	/etc/login.defs 定义创建一个用户时的默认设置
	# 配置简介
		MAIL_DIR /var/spool/mail  当创建用户时，在该目录下创建一个用户mail文件
		PASS_MAX_DAYS 99999 指定密码保持有效的最大天数
		PASS_MIN_DAYS 0 	表示自从上次修改密码以来多少天后用户才被允许修改口令
		PASS_MIN_LEN  5  	密码的最小长度
		PASS_WARN_AGE 7 	口令到期前多少天系统开始通知用户口令即将到期
		UID_MIN 	  1000  uid最小值
		UID_MAX 	  60000 uid最大值
		CREATE_HOME	  yes 	是否创建家目录
		UMASK 		  077
	/etc/default/useradd 添加的用户默认配置
	# 配置简介
		GROUP=100 
		HOME=/home 新建用户的主目录放在/home目录下
		INACTIVE=-1 表示是否启用账户过期禁用，-1表示不启用
		EXPIRE=		表示账号过期日期，不设置表示不启用
		SHELL=/bin/bash 新建用户的默认shell
		SKEL=/etc/skel 	用来指定用户主目录默认文件的来源，即新建用户主目录的文件都是从这个目录下复制而来的
		CREATE_MAIL_SPOOL=no
	/etc/skel
	# 主目录的默认文件配置，如.bash_profile、.bashrc、.bash_logout等

# 新建用户组
groupadd [-g -o] groupname
	-g 指定新建组的id
	-o 同-g一起使用，表示新建组的gid可以与系统已有用户组的gid相同

# 修改组
groupmod
# 删除用户组
groupdel groupname
	需要先删除组下的用户才能删除组
# 新建用户
useradd
	-u uid 用户标识，唯一
	-g group 指定组
	-G group 附加组，此组必须存在
	-b home 默认家目录
	-s /bin/bash 默认shell
	-f 过期多长时间后永久禁用,0:立即禁用，-1，关闭此功能
	-e expire 账户过期时间
	-D 不加任何参数，显示/etc/default/useradd文件配置
# 修改用户信息
usermod
	-u uid
	-g group
	-G group
	-d home
	-s shell
	-c 注释
	-l 新名称
	-f 失效日
	-e 过期日
	-L 锁定用户密码，使密码无效
	-U 解除密码锁定
	Name 要修改属性的系统用户
# 修改用户默认shell
chsh -s /bin/sh username
# 管理用户账户的有效期
chage	
	-d 设置上次修改密码到现在的天数
	-E 设置密码过期的日期
	-I 设置密码过期到锁定账户的天数
	-m 设置修改密码之间最少要多少天
	-W 设置密码过期前多久开始出现提醒信息

# 删除用户
userdel username
	-r 删除用户，并删除用户的主目录以及目录下的所有文件

RHEL7 重置root密码
	# 1.重启Linux系统主机并出现引导界面时，按下键盘上的e键进入内核编辑页面
	# 2.在Linux16参数这行的末尾追加"rb.break"参数，按Ctrl+X 组合键运行修改后的内核程序
	# 然后进入系统紧急救援模式，依次输入如下命令重置root密码：
		mount -o remount,rw /sysroot
		chroot /sysroot
		passwd
		touch /.autorelabel
		exit
		reboot
