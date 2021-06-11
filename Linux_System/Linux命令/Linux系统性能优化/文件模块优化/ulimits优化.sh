#!/usr/bin/env sh
一、修改最大连接数
1、查看当前文件描述符的限制数目的命令：
ulimit -n
2、修改文件描述符的限制数目
2.1 临时改变当前会话：
ulimit -n 65536
2.2 永久变更需要下面两个步骤：
1) 修改/etc/security/limits.conf 文件，如下：
vi /etc/security/limits.conf
*               soft    nofile           570000
*               hard    nofile           570000
保存退出后重新登录，其最大文件描述符已经被永久更改了；但是需要经过下面的步骤2）之后才能生效。
2) 重新加载库：
打开文件：
vi /etc/pam.d/login
在最后加上：
session    required /lib64/security/pam_limits.so
即可


一、修改最大连接数
1、查看当前文件描述符的限制数目的命令：
ulimit -n
2、修改文件描述符的限制数目
2.1 临时改变当前会话：
ulimit -n 65536
2.2 永久变更需要下面两个步骤：
1) 修改/etc/security/limits.conf 文件，如下：
vi /etc/security/limits.conf
*               soft    nofile           65535
*               hard    nofile          65535
保存退出后重新登录，其最大文件描述符已经被永久更改了；但是需要经过下面的步骤2）之后才能生效。
2) 重新加载库：
打开文件：
vi /etc/pam.d/login
在最后加上：
session    required /lib64/security/pam_limits.so
即可