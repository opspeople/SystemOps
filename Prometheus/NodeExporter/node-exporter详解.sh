#!/bin/bash
# Exporter是Prometheus的指标数据收集组件。它负责从目标Jobs收集数据，并把收集到的数据转换为Prometheus支持的时序数据格式。 
# 和传统的指标数据收集组件不同的是，他只负责收集，并不向Server端发送数据，而是等待Prometheus Server 主动抓取，
# node-exporter 默认的抓取url地址：http://ip:9100/metrics 

# 另外，如果因为环境原因，网络不可达的场景，Prometheus可以使用Pushgateway这个组件推送node-exporter的指标数据到远端Prometheus

# 功能
	# node-exporter用于采集类UNIX内核的硬件以及系统指标
	--collectors.enabled 指定node_exporter收集的功能模块
	--no-collector 指定不需要的模块

# 配置Node Exporter
node_exporter --help # 查看帮助
	# 默认情况下， node_exporter 在端口 9100 上运行，并在路径 /metrics 上暴 露指标。
	# 你可以通过--web.listen-address 和 --web.telemetry-path 参数来设置端口和路径，如下所示：

node_exporter --web.listen-address=":9600" --web.telemetry-path="/node_metrics"

--no-collector.arp # 禁用收集器 

# 启用systemd收集器
node_exporter --collector.systemd --collector.systemd.unit-whitelist="(docker|sshd|rsyslog).service"


# Prometheus抓取node Exporter指标
scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

# 过滤收集器
scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
    params:
      collect[]:
        - cpu
        - meminfo
        - diskstats
        - netdev
        - filefd
        - filesystem
        - xfs
        - systemd


# 测试收集指标
curl -g -X GET http://localhost:9090/metrics?collect[]=cpu

