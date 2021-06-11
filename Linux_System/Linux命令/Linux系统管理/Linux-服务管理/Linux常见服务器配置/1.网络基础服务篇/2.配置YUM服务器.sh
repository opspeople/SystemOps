#!/usr/bin/env sh
# YUM(Yellow dog Update Modified)
# 3种设置Yum源的方式
# 第一种ftp：
(1)安装并配置vsftpd
(2)确认系统是否已经安装了YUM服务器工具，rpm -q | grep yum 
(3)安装createrepo，用于生存RPM依赖关系及分组信息
rpm -ivh createrepo-0.9.9-26.el7.rpm 
(4)将RHEL光盘中部分内容复制到/var/ftp/pub目录中
cp -rv Server /var/ftp/pub 

(5)生成RPM包依赖关系
createrepo -g /var/ftp/pub/Server/repodata/comp7-rhel7-server-core.xml /var/ftp/pub/Server

# 第二种：光盘作为YUM源
将光盘文件挂载到一个目录即可

# 第三种：ISO文件作为YUM源
mount -o loop rhel.iso /mnt/cdrom

# 第三方RPM包
mkdir /var/ftp/pub/OpenWebMail
cd /var/ftp/pub/OpenWebMail
wget ....
# 建立依赖关系
createrepo /var/ftp/pub/OpenWebMail # 这里不能通过createrepo -g 更新分组，因为OpenWebMail中没有分组定义文件

# 客户端配置
[yumtest]
name=Server
baseurl=ftp://192.168.0.3/pub/Server 
enabled=1
gpgcheck=1
gpgkey=file://etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

# yum.conf配置文件详解
cat /etc/yum.conf 
cachedir # 指定YUM缓存的目录，YUM在该目录中存储下载的RPM包和数据库，默认为/var/cache/yum
keepcache	# 指定安装完成后是否保留软件包，0表示不保留，1表示保留，默认为0
debuglevel 	# 指定排错级别，可用值0~10,默认为2
logfile		# 指定YUM的日志文件，默认为/var/log/yum.log
pkgpolicy	# 包的策略
distroverpkg	# 指定一个软件包，YUM会根据这个包判断系统的发行版本，默认为redhat-release
exactarch 	# 是否只升级与已安装软件包CPU体系一致的包，0表示可以安装不一致的包，1表示只安装一致的包，默认为1
retries		# 网络连接发生错误后的重试次数，如果设为0，会无限重试
exclude 	# 排除某些软件在升级名单之外，可以用通配符，列表中各个项目要用空格隔开
metadata_expire	# YUM源超时时间
pluging		# 是否允许使用插件，0表示不允许使用插件，1表示允许使用插件，默认为1



YUM常用命令：
yum -y install <软件名称> 	# 安装指定的软件包
yum -y update 				# 升级所有已安装的软件
yum -y update <软件名称>		# 升级指定的软件包
yum check-update			# 检查是否有需要升级的软件
yum info <软件名称>			# 显示指定的软件包相关信息
yum info updates 			# 显示所有可以更新的软件包的信息
yum info installed 			# 显示所有已经安装的软件包的信息
yum groupinfo <分组名称>		# 显示指定的分组信息
yum list 					# 显示所有已经安装和可以安装的软件
yum list <软件名称>			# 显示指定的软件包安装情况
yum list installed 			# 显示已经安装的软件包
yum grouplist 				# 显示所有YUM服务器定义的分组
yum search <关键>			# 在YUM源中查找指定关键字
yum clean packages 			# 清除缓存中RPM包文件
yum clean headers 			# 清除缓存中RPM头文件
yum clean [all]				# 清除所有YUM缓存
yum localinstall <RPM包名>	# 使用YUM方式安装本地RPM包
yum groupinstall <分组名称>	# 安装指定的分组所有软件
yum remove <软件名称>		# 删除指定的软件包
yum groupremove packagegroup <分组名称>	# 删除指定的分组所有软件

