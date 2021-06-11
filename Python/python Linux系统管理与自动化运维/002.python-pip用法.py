# 1.pip安装
yum -y install pip3 
apt-get -y install pip3

# 2.升级
pip install -U pip 

# 3.pip命令
pip install
pip download 下载安装包
pip uninstall 
pip freeze 安装requirements格式输出安装包，可以到其他服务器上执行pip install -r requirements.txt 直接安装软件
pip list 列出当前系统中的安装包
pip show 查看安装包的信息，包扩版本、依赖、许可证等
pip check 检查安装包的依赖是否完整
pip search
pip wheel 打包软件到whell格式
hash 计算安装包的hash值
completion 生成命令补全配置

# 4.pip加速配置
vim ~/.pip/pip.conf 
[global]
https://pypi.douban.com/simple

# 5.下载到本地
pip install --download=`pwd` -r requirements.txt 

# 6.本地安装
pip install --no-index -f file://`pwd` -r requirements.txt 

