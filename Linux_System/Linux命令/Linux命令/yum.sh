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


yun provides */<库文件名|命令...> # 反向查找包含某库文件或命令的包名