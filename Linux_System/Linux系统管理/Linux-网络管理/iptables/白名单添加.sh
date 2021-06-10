# Firewall configuration written by system-config-firewall
# Manual customization of this file is not recommended.
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
#这里开始增加白名单服务器ip(请删除当前服务器的ip地址)
-N whitelist
-A whitelist -s 192.168.111.xxx -j ACCEPT
-A whitelist -s 192.168.111.xxx -j ACCEPT
-A whitelist -s 192.168.111.xxx -j ACCEPT
-A whitelist -s 192.168.111.xxx -j ACCEPT
-A whitelist -s 192.168.111.xxx -j ACCEPT
#这里结束白名单服务器ip
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p icmp -j ACCEPT

-A INPUT -i lo -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 13020 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 1000:8000 -j ACCEPT  //开放1000到8000之间的所有端口
//上面这些 ACCEPT 端口号，公网内网都可以访问

//下面这些 whitelist 端口号，仅限服务器之间通过内网访问
#这里添加为白名单ip开放的端口
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j whitelist
-A INPUT -m state --state NEW -m tcp -p tcp --dport 13009 -j whitelist
-A INPUT -m state --state NEW -m tcp -p tcp --dport 10080 -j whitelist
#这结束为白名单ip开放的端口
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited

COMMIT