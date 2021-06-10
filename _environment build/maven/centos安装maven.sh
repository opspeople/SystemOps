#!/usr/bin/env bash
1.下载
Maven下载地址：http://maven.apache.org/download.cgi
http://mirrors.shu.edu.cn/apache/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz

2.解压
 tar -zxvf apache-maven-3.5.4-bin.tar.gz

3.配置环境变量

在/etc/profile中保存Maven的环境变量：

export M2_HOME=/opt/server/apache-maven-3.5.4

export PATH=$PATH:$M2_HOME/bin

通过source使配置文件生效：

# source /etc/profile

4、查看版本号

# mvn -version
