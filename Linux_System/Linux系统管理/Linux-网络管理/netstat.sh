#!/usr/bin/env bash
# install netstat
yum -y install net-tools

netstat 

选项：
	-r --route 显示路由表
	-I --interfaces=<Iface> 显示接口表
	-i --interfaces 显示接口表
	-g --groups 显示多播组成员关系
	-s --statistics 显示网络状态