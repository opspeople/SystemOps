#!/usr/bin/env sh
# 1.下载
cd /usr/local/src/
wget https://src.fedoraproject.org/repo/pkgs/haproxy/haproxy-2.1.4.tar.gz/sha512/fd029ac1ec877fa89a9410944439b66795b1392b6c8416aaa7978943170530c3826ba50ea706366f3f7785b7cffed58497cb362fc2480dd6920a99af4f920d98/haproxy-2.1.4.tar.gz

# 2.安装依赖
yum -y install openssl openssl-devel systemd-devel

# 3.解压
tar -zxf haproxy-2.1.4.tar.gz

# 4.编译安装
cd haproxy-2.1.4/
make -j $(nproc) TARGET=linux-glibc USE_OPENSSL=1 USE_ZLIB=1 USE_LUA=1 USE_PCRE=1 USE_SYSTEMD=1 PREFIX=/usr/local/haproxy
make install PREFIX=/usr/local/haproxy

# 5.拷贝服务配置文件到服务配置文件目录
cp /usr/local/src/haproxy-2.1.4/contrib/systemd/haproxy.service.in /usr/lib/systemd/system/haproxy.service
# 修改文件内容为如下内容
[Unit]
Description=HAProxy Load Balancer
After=network.target

[Service]
EnvironmentFile=-/etc/haproxy/haproxy.cfg
# EnvironmentFile=-/etc/sysconfig/haproxy
Environment="CONFIG=/etc/haproxy/haproxy.cfg" "PIDFILE=/run/haproxy.pid" "EXTRAOPTS=-S /run/haproxy-master.sock"
ExecStartPre=/usr/local/haproxy/sbin/haproxy -f $CONFIG -c -q $EXTRAOPTS
ExecStart=/usr/local/haproxy/sbin/haproxy -Ws -f $CONFIG -p $PIDFILE $EXTRAOPTS
ExecReload=/usr/local/haproxy/sbin/haproxy -f $CONFIG -c -q $EXTRAOPTS
ExecReload=/bin/kill -USR2 $MAINPID
KillMode=mixed
Restart=always
SuccessExitStatus=143
Type=notify

[Install]
WantedBy=multi-user.target

# 6.开启haproxy日志： vim /etc/rsyslog.conf
# Provides UDP syslog reception
#解开注释
$ModLoad imudp
#解开注释
$UDPServerRun 514
#添加
local0.*                                      /var/log/haproxy.log

# 7.编辑rsyslog：vim /etc/sysconfig/rsyslog
SYSLOGD_OPTIONS="-r -m 0 -c 2"

# 8.创建配置文件并启动目录
mkdir -p /var/lib/haproxy
touch /var/lib/haproxy/stats 
mkdir /etc/haproxy
vim /etc/haproxy/haproxy.cfg

global
    log 127.0.0.1   local0 info
    chroot      /var/lib/haproxy
    pidfile     /var/run/haproxy.pid
    maxconn     1020   # See also: ulimit -n
    user        haproxy
    group       haproxy
    daemon
    # turn on stats unix socket
    stats socket /var/lib/haproxy/stats.sock mode 600 level admin
    stats timeout 2m
defaults
    mode    tcp
    log     global
    option  dontlognull
    option  redispatch
    timeout http-request      10s
    retries                   3
    timeout queue             45s
    timeout connect           10s
    timeout client            1m
    timeout server            1m
    timeout http-keep-alive   10s
    timeout check             10s
    maxconn                   1020
listen stats
    mode http
    bind 0.0.0.0:8089
    stats enable
    stats uri     /admin?stats
    stats realm   Haproxy\ Statistics
    stats auth    admin:admin
    stats admin if TRUE

frontend mysql
    description "MySQL"
    bind *:3306
    mode tcp
    log global
    default_backend mysql

backend mysql
    description "MySQL"
    balance leastconn
    server mysql1 192.168.88.8:3307 check
    server mysql2 192.168.88.10:3307 check

# 9.启动haproxy
systemctl start haproxy

# 10.浏览器监控校验
http://192.168.116.141:8080/admin?stats
用户名  admin
密码	   admin