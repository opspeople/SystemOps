#!/usr/bin/env ansible

# 1.安装途径
## 从GitHub获取Ansible
git clone git://github.com/ansible/ansible.git --recursive
cd ./ansible
source ./hacking/env-setup
easy_install pip
## 其他ansible依赖模块安装
pip install paramiko PyYAML Jinja2 httplib2 six

# 2.Yum安装
yum install -y epel-release
yum install -y ansible

# 3.apt安装
apt-get install software-properties-common
apt-add-repository ppa:ansible/ansible
apt-get update
apt-get install ansible

# 4.