#!/usr/bin/env bash
1. 安装依赖软件
　　yum -y install policycoreutils openssh-server openssh-clients postfix

2.设置postfix开机自启，并启动，postfix支持gitlab发信功能
　　systemctl enable postfix && systemctl start postfix

3.下载gitlab安装包，然后安装
　　gitlab的下载地址：https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/
 
　　rpm -ivh gitlab-ce-8.0.0-ce.0.el7.x86_64.rpm

4.修改gitlab配置文件指定服务器ip和自定义端口      -->更改gitlab默认端口
　　vim  /etc/gitlab/gitlab.rb 
　　修改内容：external_url   后改为自己的http://ip:端口  ;    unicorn['port'] = 28080  修改 unicorn['port'] 端口    

 5：使用gitlab-ctl reconfigure 自动配置，并安装数据库，初始化信息，如下所示(第一次使用配置时间较长)：
命令：gitlab-ctl reconfigure 

 6：使用gitlab-ctl start 启动gitlab服务。
命令：gitlab-ctl start 
 sudo gitlab-ctl stop --停止服务
 sudo gitlab-ctl reconfigure --启动服务
 sudo gitlab-ctl start --启动所有gitlab组件

7：在浏览器中输入 http://ip:端口/ ，然后 change password: ，并使用root用户登录 即可 (后续动作根
