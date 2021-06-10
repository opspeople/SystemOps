#!/usr/bin/bash
# 概述
Prometheus是一套开源的监控&报警&时间序列数据库的组合,起始是由SoundCloud公司开发的。
成立于2012年，之后许多公司和组织接受和采用prometheus,他们便将它独立成开源项目，并且有公司来运作.该项目有非常活跃的社区和开发人员，
目前是独立的开源项目，任何公司都可以使用它，2016年，Prometheus加入了云计算基金会，成为kubernetes之后的第二个托管项目.
google SRE的书内也曾提到跟他们BorgMon监控系统相似的实现是Prometheus。
现在最常见的Kubernetes容器管理系统中，通常会搭配Prometheus进行监控。

# 特性
自定义多维数据模型(时序列数据由metric名和一组key/value标签组成)

非常高效的存储 平均一个采样数据占 ~3.5 bytes左右，320万的时间序列，每30秒采样，保持60天，消耗磁盘大概228G。

在多维度上灵活且强大的查询语言(PromQl)

不依赖分布式存储，支持单主节点工作

通过基于HTTP的pull方式采集时序数据

可以通过push gateway进行时序列数据推送(pushing)

可以通过服务发现或者静态配置去获取要采集的目标服务器

多种可视化图表及仪表盘支持

pull方式
Prometheus采集数据是用的pull也就是拉模型,通过HTTP协议去采集指标，只要应用系统能够提供HTTP接口就可以接入监控系统，相比于私有协议或二进制协议来说开发、简单。
push方式
对于定时任务这种短周期的指标采集，如果采用pull模式，可能造成任务结束了，Prometheus还没有来得及采集，
这个时候可以使用加一个中转层，客户端推数据到Push Gateway缓存一下，由Prometheus从push gateway pull指标过来。
(需要额外搭建Push Gateway，同时需要新增job去从gateway采数据)

# prometheus适用于监控所有时间序列的项目
目前其生态中已经有很多exporter实现，例如：

	Node/system metrics exporter
	AWS CloudWatch exporter
	Blackbox exporter
	Collectd exporter
	Consul exporter
	Graphite exporter
	HAProxy exporter
	InfluxDB exporter
	JMX exporter
	Memcached exporter
	Mesos task exporter
	MySQL server exporter
	SNMP exporter
	StatsD exporter

# 组成及架构
Prometheus生态系统由多个组件组成。其中许多组件都是可选的
	prometheus server
		主要负责数据采集和存储，提供PromQL查询语言的支持
	Push Gateway
		支持临时性Job主动推送指标的中间网关
	PromDash
		使用rails开发的dashboard，用于可视化指标数据
	exporters
		支持其他数据源的指标导入到Prometheus，支持数据库、硬件、消息中间件、存储系统、http服务器、jmx等
	alertmanager
		告警
	prometheus_cli
		命令行工具

prometheus大多数组件都是用Go编写的，他们可以非常轻松的基于二进制文件部署和构建
它的服务过程是这样的 Prometheus Server 负责定时去目标上抓取 metrics(指标) 数据，每个抓取目标需要暴露一个http服务的接口给它定时抓取。
Prometheus支持通过配置文件、kubernetes、zookeeper、Consul、DNS SRV lookup等方式指定抓取目标。
Alertmanager 是独立于Prometheus的一个组件，可以支持Prometheus的查询语句编写规则，提供十分灵活的报警方式。
Prometheus支持很多方式的图表可视化，例如十分精美的Grafana，自带的Promdash，以及自身提供的模版引擎等等，还提供HTTP API的查询方式，自定义所需要的输出。
PushGateway这个组件是支持Client主动推送 metrics 到PushGateway，而Prometheus只是定时去Gateway上抓取数据。
如果有使用过statsd的用户，则会觉得这十分相似，只是statsd是直接发送给服务器端，而Prometheus主要还是靠进程主动去抓取。
