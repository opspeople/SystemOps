#!/bin/bash
1.下载prometheus二进制版本

2.解压

3.将可执行文件复制到/usr/local/bin目录即可

4.配置prometheus
	配置文件 prometheus.yml
	包括4个板块：
		global
			包含了控制Prometheus服务器行为的全局配置
		alerting
		rule_files
		scrape_configs

5.启动Prometheus
prometheus --config.file "/etc/prometheus/prometheus.yml"

6.使用promtool验证配置文件
promtool check config prometheus.yml

