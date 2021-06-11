#!/usr/bin/env sh
# 1.关闭防火墙
systemctl stop firewalld && systemctl disable firewalld

# 2.禁用selinux
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux 
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

# 3.配置dns
echo "nameserver 8.8.8.8" >> /etc/resolve.conf 
echo "nameserver 114.114.114.114" >> /etc/resolve.conf

# 4.禁用SSH服务的dns查询
sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
systemctl restart sshd 

# 5.yum源配置
# CentOS7
rm -rf /etc/yum.repos.d/*.repo
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
yum clean all
yum makecache 


# CentOS6
rm -rf /etc/yum.repos.d/*.repo
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-6.repo
yum clean all
yum makecache 


#CentOS8
rm -rf /etc/yum.repos.d/*.repo
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-8.repo
yum clean all
yum makecache 

# 6.常用软件安装
yum -y install lrzsz vim gcc-c++ wget net-tools zlib* lua* telnet
