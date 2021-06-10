# ListenPort=10051　　　　#<===默认侦听的端口及端口取值范围,默认即可
# SourceIP=　　　　　　　　 #<===使用哪个出口IP与外面通信，默认即可
# LogType=file　　　　　　　　#<===设置记录日志的类型，默认记录至文件
LogFile=/var/log/zabbix/zabbix_server.log　　　　#<===指定zabbix日志文件存放路径
LogFileSize=0           #<===指定日志文件大小及轮询相关，0表示禁用日志自动轮询，如果日志达到了限制，并且rotation失败，老日志文件将会被清空掉，重新生成一个新日志。
# DebugLevel=3 　　　　#<===指定debug调试信息级别，默认即可
PidFile=/var/run/zabbix/zabbix_server.pid　　#<===定义PID文件及路径
# DBHost=localhost　　　　#<===指定链接的数据库（默认为localhost，zabbix与数据库安装在一台机器上，直接使用localhost，这是通过socket链接mysql数据库的IP地址）
DBName=zabbix　　　　#<===默认链接数据库的名称(已事先创建好)
# DBSchema=　　　　#<===指定链接其他类型数据库
DBUser=zabbix　　　　#<===默认使用哪个用户链接数据库（已事先创建）
DBPassword=zabbix　　　　#<===用户链接数据库的密码（事先定义）
# DBSocket=/tmp/mysql.sock　　　　#<===zabbix数据库运行后，产生的socket文件及存放路径（主机为localhost）
# DBPort=3306　　　　#<===数据库侦听的端口（默认MySQL端口，socket链接默认即可，若网络链接，可更改为其他）
# StartPollers=5　　　　#<===pre-forked进程的数量，1.8.5之前，最大为255,默认为0，最大为1000，客户机较多可加大此值
# StartIPMIPollers=0 　　#<===用于IPmi技术用于获取硬件状态场景。若无相关监控项，建议设置为0
# StartPollersUnreachable=1　　#<===进程数量（主机不可达）
# StartTrappers=5　　　　#<===用于设置STRAPPER场景提交来的数据的接收进程数，若客户机被监控SNMP TRAPPER指标较多，建议加大此参数值（server端等待别人主动发送的其他监控选项）
# StartPingers=1　　　　#<===用于设置启用icmp协议PING主机方式启动线程数量，若单台代理所管理机器超过500台，建议加大此数值
# StartDiscoverers=1　　　　#<===用于设置自动发现主机的线程数量，若单台代理所管理机器超过500台，可以考虑加大此数值（仅适用于直接AGENT场景），很占用带宽，不建议使用
# StartHTTPPollers=1　　　　#<===用于设置WEB拨测监控线程数，可视具体情况增加或减少此数值。
# StartTimers=1　　　　    #<===pre-forked监控项计时器
# StartEscalators=1
# JavaGateway=　　　　#<===Zabbix Java gateway的主机名或者ip地址，需要启动Java pollers
# JavaGatewayPort=10052　　　　#<===Zabbix Java gateway监听端口
# StartJavaPollers=0　　#<===进程数相关
# StartVMwareCollectors=0　　#<===vmware的相关配置
# VMwareFrequency=60　　　　#<===监控vmware虚拟机频率
# VMwarePerfFrequency=60　　
# VMwareCacheSize=8M
# VMwareTimeout=10
SNMPTrapperFile=/var/log/snmptrap/snmptrap.log　　　　#<===指定StartSNMPTrapper日志路径
# StartSNMPTrapper=0　　　　#<===是否打开StartSNMPTrapper功能，默认关闭
# ListenIP=127.0.0.1　　　　#<===监听来自trapper的ip地址（默认监听所有ip地址）
# HousekeepingFrequency=1 　　　　#<===从数据库中移除过期数据，使用默认即可，housekeep执行频率，默认每小时回去删除一些过期数据。如果server重启，那么30分钟之后才执行一次，接下来，每隔一小时在执行一次。
# MaxHousekeeperDelete=5000　　#<===housekeeping一次删除的数据不能大于MaxHousekeeperDelete
# SenderFrequency=30　　　　#<===间隔多少秒，再尝试发送为发送的报警
# CacheSize=8M　　　　#<===配置缓存，用于存储host，item，trigger数据，2.2.3版本之前最大支持2G，最大支持8G
# CacheUpdateFrequency=60　　　　#<===设置多少秒更新一次配置缓存
# StartDBSyncers=4　　　　#<===预先foked DB Syncers的数量，1.8.5以前最大值为64
# HistoryCacheSize=16M　　　　#<===历史记录缓存大小，用于存储历史记录
# HistoryIndexCacheSize=4M　　　　
# TrendCacheSize=4M　　　　　　
# ValueCacheSize=8M　　　　0表示禁用，设置history value缓存大小，当缓存超标了，将会每隔5分钟往server日志里面记录（查看日志很重要）
Timeout=4　　　　#<===agent，snmp，external check的超时时间，单位为秒,默认值为3秒
# TrapperTimeout=300　　　　#<===处理trapper数据的超时时间
# UnreachablePeriod=45　　　　#<===当检测到主机不可用时，设置多少秒将它设置为不可达
# UnavailableDelay=60　　　　#<===指定间隔时间多少秒检测主机是否不可用
# UnreachableDelay=15　　　　#<===指定间隔时间多少秒检测主机是否不可达
AlertScriptsPath=/usr/lib/zabbix/alertscripts　　　　#<===指定告警脚本目录路径
# FpingLocation=/usr/sbin/fping　　　　#<===指定fping路径，如果zabbix非root启动，需给fping SUID特殊权限位
# Fping6Location=/usr/sbin/fping6　　　　#<===同上
# SSHKeyLocation=　　　　#<===指定SSH公钥私钥路径
LogSlowQueries=3000　　　#<===慢查询相关
# TmpDir=/tmp　　　　#<===默认即可
# StartProxyPollers=1　　　　#<===在zabbix proxy被动模式下用此参数,调整进程数量
# ProxyConfigFrequency=3600　　　　#<===zabbix proxy被动模式下，server多少秒同步配置文件至zabbix代理proxy。
# ProxyDataFrequency=1　　　　#<===被动模式下，zabbix server间隔多少秒向proxy请求历史数据,1-3600为取值范围
# AllowRoot=0　　　　#<===是否允许使用root身份运行zabbix服务，默认不允许
# User=zabbix　　　　#<===启动zabbix server服务的用户，在配置禁止root启动，并且当前shell用户是root得情况下有效。如果当前用户是test，那么zabbix server的运行用户是test
# Include=　　　　#<===支持include方式包含其他配置文件（可使用正则表达式匹配），即子配置文件
# SSLCertLocation=${datadir}/zabbix/ssl/certs　　　　#<===SSL证书目录，用于web监控
# SSLKeyLocation=${datadir}/zabbix/ssl/keys　　　　#<===SSL认证私钥路径,用于web监控
# SSLCALocation=　　　　　　#<===设置SSL认证,CA路径。如果为空，将会使用系统默认的CA
# LoadModulePath=${libdir}/modules　　　　#<===指定加载的模块目录，格式: LoadModule=，文件必须在指定的LoadModulePath目录下，如果需要加载多个模块，那么写多个即可
# LoadModule=
# TLSCAFile=　　　　#<===使用TLS认证及设置TLS认证相关
# TLSCRLFile=
# TLSCertFile=
# TLSKeyFile=