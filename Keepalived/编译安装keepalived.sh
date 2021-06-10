#!/usr/bin/evn sh
# 1.下载
cd /usr/local/src
wget https://www.keepalived.org/software/keepalived-2.0.20.tar.gz 

# 2.安装依赖软件
yum -y install gcc-c++ openssl openssl-devel 

# 3.解压
tar -xzf keepalived-2.0.20.tar.gz
cd keepalived-2.0.20/
./configure --prefix=/usr/local/keepalived

### 编译报错
### *** WARNING - this build will not support IPVS with IPv6. Please install libnl/libnl-3 dev libraries to support IPv6 with IPVS.
### 解决办法
	yum -y install libnl libnl-devel

make && make install 

# 4.拷贝相关文件到指定文件夹
cp /usr/local/src/keepalived-2.0.20/keepalived/etc/init.d/keepalived /etc/init.d/

cp /usr/local/keepalived/etc/sysconfig/keepalived /etc/sysconfig/

mkdir /etc/keepalived

cp /usr/local/keepalived/etc/keepalived/keepalived.conf /etc/keepalived/

cp /usr/local/keepalived/sbin/keepalived /usr/bin/

# 5.修改keepalived.conf配置文件

# 6.启动keepalived服务
systemctl start keepalived 

# 7.检查
ip a
