#!/bin/bash
一、监控主机
监控插件为
	node_exporter
	默认情况下，node_exporter在端口9100上运行，并在路径/metrics上暴露指标。
	node_exporter --web.listen-address=":9600" --web.telemetry-path="/node_metrics"
	这些参数还可以控制启用哪些收集器，许多收集器默认都是启用的.
	它们的状态要么是启用要么是禁用，你可以通过使用no-前缀来修改状态。
配置textfile收集器
	textfile收集器非常有用，因为它允许我们暴露自定义指标。
	这些自定义指标可能是批处理或cron作业等无法抓取的，可能是没有exporter的源，甚至可能是为主机提供上下文的静态指标。
	收集器通过扫描指定目录中的文件，提取所有格式为Prometheus指标的字符串，然后暴露它们以便抓取。
	现在让我们设置收集器，首先创建一个目录来保存指标定义文件。
	mkdir -p /var/lib/node_exporter/textfile_collector
	现在在这个目录中创建一个新的指标。刚创建的目录中，指标在以.prom结尾的文件内定义，并且使用Prometheus特定文本格式
	我们使用此格式创建一个包含有关此主机的元数据指标。
	metadata{role="docker_server",datacenter="NJ"} 1
	echo 'metadata{role="docker_server",datacenter="NJ"} 1' | sudo tee /var/lib/node_exporter/textfile_collector/metadata.prom
	在这里，我们将指标传递到名为metadata.prom的文件中
	要启用textfile收集器，我们不需要配置参数，它默认就会被加载。但我们需要指定textfile_exporter
	目录，以便Node Exporter知道在哪里可以找到自定义指标。
	为此，我们需要指定 --collector.textfile.directory 参数。

启用systemd收集器
	它记录systemd[1]中的服务和系统状态。这个收集器收集了很多指标，
	但我们并不想收集systemd管理的所有内容，而只想收集某些关键服务。为了保持简洁，
	我们可以将特定服务列入白名单，只收集以下服务的指标：
	docker.service
	ssh.service
	rsyslog.service
	使用--collector.systemd.unit-whitelist参数进行配置，它会匹配systemd的正则表达式。

运行node_exporter
	node_exporter --collector.textfile.directory /var/lib/node_exporter/textfile_collector \
				--collector.systemd --collector.systemd.unit-whitelist="(docker|ssh|rsyslog).service"

抓取Node Exporter 
	scrape_configs:
	  - job_name: 'prometheus'
	    static_configs:
	      - targets: ['localhost:9090']
	  - job_name: 'node'
	    static_configs:
	      - targets: ['192.168.1.2:9100']
	      - targets: ['192.168.1.3:9100']
	      - targets: ['192.168.1.4:9100']

过滤收集器
	scrape_configs:
	  - job_name: 'prometheus'
	    static_configs:
	      - targets: ['localhost:9090']
	  - job_name: 'node'
	    static_configs:
	      - targets: ['192.168.1.2:9100']
	      - targets: ['192.168.1.3:9100']
	      - targets: ['192.168.1.4:9100']
	    params:
	      collect[]:
	        - cpu 
	        - meminfo
	        - diskstats
	        - netdev
	        - netstat
	        - filefd
	        - filesystem
	        - xfs
	        - systemd

	curl -g -X GET http://192.168.1.2:9100/metrics?collect[]=cpu
CPU监控
内存监控
磁盘监控
可用性监控


二、监控容器
Prometheus提供了几种方法来监控Docker，包括一些自定义的exporter。
推荐的方法是Google提供的cAdvisor工具。
在Docker守护进程上，cAdvisor作为Docker容器运行，单个cAdvisor容器返回针对Docker守护进程和所有正在运行的容器的指标。
Prometheus支持通过它导出指标，并将数据传输到其他各种存储系统，如InfluxDB、Elasticsearch和Kafka。

运行cAdvisor
docker run \
	--volume=/:/rootfs:ro \
	--volume=/var/run:/var/run:rw \
	--volume=/sys:/sys:ro \
	--volume=/var/lib/docker:/var/lib/docker:ro \
	--volume=/dev/disk:/dev/disk:ro \
	--publish=8080:8080 \
	--detach=true \
	--name=cadvisor \
	google/cadvisor:latest

抓取cAdvisor
	scrape_configs:
	  - job_name: 'prometheus'
	    static_configs:
	      - targets: ['localhost:9090']
	  - job_name: 'docker'
	    static_configs:
	      - targets: ['192.168.1.2:8080', '192.168.1.3:8080', '192.168.1.4:8080']

