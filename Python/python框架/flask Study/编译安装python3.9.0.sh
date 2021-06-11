#!/bin/bash
1.下载
	wget https://www.python.org/ftp/python/3.9.0/Python-3.9.0.tar.xz

2.解压
	tar -xJf Python-3.9.0.tar.xz

3.安装openssl
	yum -y install openssl

4.编译安装
	./configure --prefix=/usr/local/python3.9.0 --with-openssl=/usr/bin/openssl
	make && make install
	