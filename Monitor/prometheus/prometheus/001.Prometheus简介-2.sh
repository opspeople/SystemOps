#!/bin/bash
Prometheus架构

1.节点
	Server端： Prometheus 
	Client端： exporter or push gateway

2.收集指标
	prometheus抓取的指标来源称为端点(endpoint),包括：单个进程、主机、服务或应用程序。
	prometheus定义了名为目标(target)的配置。这是执行抓取所需的信息，如：如何进行连接，要应用哪些元数据，连接需要哪些身份验证，定义抓取将如何执行...
	一组目标被称作为(job)作业。