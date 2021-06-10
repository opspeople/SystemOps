监控系统
	组成部分
		客户端 数据采集部分 
		服务器端 数据存储分析告警展示部分

	工作模式
		被动模式 服务器端到客户端采集数据
		主动模式 客户端主动将采集到的的数据发送到服务器端

	数据采集协议
		专用客户端采集
		公用协议采集 SNMP、SSH、Telnet等

	规模
		小规模 C/S架构
		大规模 C/P/S (Client/Proxy/Server)

监控软件开源现状
	流量监控 MRTG、Cacti、SmokePing、Graphite等
	性能监控 Nagios、Zabbix、Zenoss Core、Ganglia、OpenTSDB等

	MRTG 
		可用来绘制网络流量图的软件
		Perl语言，可跨平台
		数据采集协议 SNMP协议

	Cacti 
		基于PHP、MySQL、SNMP和RRDtool开发的网络流量监测图形分析工具
		snmpget获取数据
		RRDtool绘图

	SmokePing 
		监视网络性能

	Graphite 
		采集网站实时信息并进行统计的开源项目

	Nagios 
		企业级的监控系统，可监控服务的运行状态和网络信息等
		监控本地或远程主机的参数及服务，同时提供异常告警通知功能

	Zabbix 
		分布式监控系统，支持多种采集方式和采集客户端；
		有专用的Agent；
		也可以支持SNMP、IPMI、JMX、Telnet、SSH等多种协议