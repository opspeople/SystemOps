#!/bin/bash
# Document
# https://blog.csdn.net/weixin_43769772/article/details/103838433

一、安装libressl-2.8.0（这里以2.8.0版本的为例）
1、安装libressl 前先安装下面的环境：
yum -y install zlib zlib-devel
yum -y install bzip2 bzip2-devel
yum -y install ncurses ncurses-devel
yum -y install readline readline-devel
yum -y install openssl openssl-devel
yum -y install openssl-static
yum -y install xz lzma xz-devel
yum -y install sqlite sqlite-devel
yum -y install gdbm gdbm-devel
yum -y install tk tk-devel
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel
yum install -y libffi-devel zlib1g-dev
yum -y install libffi-devel
yum install zlib* -y
2、在/usr/local/下新建文件夹ssl
3、下载libressl并解压，进入解压后的目录libressl-2.8.0
运行以下命令：

./config --prefix=/usr/local/ssl （此文件夹必须存在）
make
make insatll
备份当前openssl：
mv /usr/bin/openssl /usr/bin/openssl.bak
mv /usr/include/openssl /usr/include/openssl.bak
5、配置使用新版本：
ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl
ln -s /usr/local/ssl/include/openssl /usr/include/openssl
6、新建配置文件
cd /etc/ld.so.conf.d
新建文件
vim libressl-2.8.0.conf
#将以下行加入文件，并保存
/usr/local/ssl/lib
ldconfig -v #重新加载库文件

验证是否安装完成
[root@testmachine hadoop_software]# openssl version
LibreSSL 2.8.0

./configure --prefix=/usr/local/python3 --enable-optimizations --with-openssl=/usr/local/ssl
make && make install

修改pip安装源（pip下载模块原下载地址容易超时，按以下方法修改）
修改系统pip安装源
在家目录下新建.pip文件夹,进入文件夹新建文件pip.conf之后写入相应镜像网站地址
cd ~
mkdir .pip
cd .pip
vim pip.conf
#进入后添加以下内容,保存退出.
[global]
index-url = https://mirrors.aliyun.com/pypi/simple