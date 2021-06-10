Linux服务器默认网卡配置文件在/etc/sysconfig/network-scripts/下


网卡配置内容
# 动态地址
DEVICE=eth0
BOOTPROTO=dhcp
HWADDR=[32位mac地址]
ONBOOT=yes
TYPE=Ethernet

# 静态地址
DEVICE=eth0
BOOTPROTO=static
HWADDR=[32位mac地址]
ONBOOT=yes
IPADDR=192.168.116.129
GATEWAY=192.168.116.1
NETMASK=255.255.255.0
TYPE=Ethernet

