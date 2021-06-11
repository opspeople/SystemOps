# RHEL YUM
# 查看以安装的软件包
yum list installed

# 查看某个软件包是否安装
yum list 软件包名

# 查找系统上的某个特定文件属于哪个软件包
yum provides filename

# 卸载软件包
yun remove package_name # 保留配置文件和数据文件
yum erase package_name	# 删除软件和它所有的文件

# 显示软件仓库
yum repolist

# 列出所有仓库
yum repolist all

# 列出仓库中所有软件包
yum list all

# 检查更新
yum check-update

# 从源码安装软件
./configure --prefix=...
make && make install

# RPM包管理器
rpm -ivh filename.rpm # 安装软件包
rpm -Uvh filename.rpm # 升级
rpm -e filename.rpm # 卸载
rpm -qpi filename.rpm # 查询软件描述信息的命令格式
rpm -qpl filename.rpm # 列出软件文件信息的命令格式
rpm -qf filename.rpm  # 查询文件属于哪个RPM的命令格式
