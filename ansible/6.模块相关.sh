#!/usr/bin/env ansible
# 模块简介
# 每个模块都能接收参数. 几乎所有的模块都接受键值对(key=value)参数,空格分隔.一些模块 不接收参数,只需在命令行输入相关的命令就能调用.

# 在playbook中，ansible模块的执行方式
- name: reboot the servers
  action: command /sbin/reboot -t now

# 或者简写成：
- name: reboot the servers
  command: /sbin/reboot -t now

# yaml语法写模块
- name: restart webserver
  service:
    name: httpd
    state: restarted

# 模块帮助文档
ansible-doc yum

# 查看所有已安装模块
ansible-doc -l

# 模块执行结果返回值
# Ansible模块通常返回一个数据结构将其注册到变量中, 或者直接作为`ansible`程序的输出.
	facts
	status
	其他的共同返回
	
###################### ansible的模块 ###############
1.command

2.shell