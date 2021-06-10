#!/bin/bash
pip3 install virtualenv

# 为一个工程创建一个虚拟环境
cd my_project_dir
virtualenv venv　　#venv为虚拟环境目录名，目录名自定义

# 选择使用一个Python解释器
virtualenv -p /usr/bin/python2.7 venv　　　　# -p参数指定Python解释器程序路径

# 要开始使用虚拟环境，其需要被激活
source venv/bin/activate　　
# 从现在起，任何你使用pip安装的包将会放在 venv 文件夹中，与全局安装的Python隔绝开


# 如果你在虚拟环境中暂时完成了工作，则可以停用它
. venv/bin/deactivate



virtualenvwrapper
# 鉴于virtualenv不便于对虚拟环境集中管理，所以推荐直接使用virtualenvwrapper。
# virtualenvwrapper提供了一系列命令使得和虚拟环境工作变得便利。它把你所有的虚拟环境都放在一个地方。
# 安装virtualenvwrapper
pip install virtualenvwrapper
pip install virtualenvwrapper-win　　#Windows使用该命令

# 安装完成后，在~/.bashrc写入以下内容
export WORKON_HOME=~/Envs
source /usr/local/bin/virtualenvwrapper.sh

source ~/.bashrc　　　　#读入配置文件，立即生效

virtualenvwrapper基本使用
# 创建虚拟环境　mkvirtualenv
mkvirtualenv venv　　　

mkvirtualenv --python=/usr/local/python3.5.3/bin/python venv

# 查看当前的虚拟环境目录
[root@localhost ~]# workon
py2
py3

# 切换到虚拟环境
[root@localhost ~]# workon py3
(py3) [root@localhost ~]# 

# 退出虚拟环境
(py3) [root@localhost ~]# deactivate
[root@localhost ~]# 

# 删除虚拟环境
rmvirtualenv venv
