#!/bin/bash

1.基础环境
# CentOS 8.2
# MySQL 8.0

2.配置MySQL8.0Yum源
wget https://repo.mysql.com/mysql80-community-release-el8-1.noarch.rpm
yum -y install mysql80-community-release-el8-1.noarch.rpm

3.配置系统镜像源
# 方案一
cp -a /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
wget -O /etc/yum.repos.d/CentOS-Base.repo https://repo.huaweicloud.com/repository/conf/CentOS-8-reg.repo
# 方案二
# 修改CentOS-Base.repo文件，取消baseurl开头的行的注释，并增加mirrorlist开头的行的注释。将文件中的http://mirror.centos.org替换成https://repo.huaweicloud.com，可以参考如下命令：
# sed -i "s/#baseurl/baseurl/g" /etc/yum.repos.d/CentOS-Base.repo
# sed -i "s/mirrorlist=http/#mirrorlist=http/g" /etc/yum.repos.d/CentOS-Base.repo
# sed -i "s@http://mirror.centos.org@https://repo.huaweicloud.com@g" /etc/yum.repos.d/CentOS-Base.repo

4.下载mysql
yum install mysql-server-8.0.20* --downloadonly --downloaddir=./mysql8.0.21
tar -czf mysql8.0.21.tar.gz mysql8.0.21/
sz mysql8.0.21.tar.gz
