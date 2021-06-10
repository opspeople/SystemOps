#!/bin/bash
可靠性和容错性
可扩展性

Prometheus推荐的容错解决方案是并行运行两个配置相同的Prometheus服务器，并且这两个服务器同时处于活动状态。
该配置生成的重复警报可以交由上游Alertmanager使用其分组（及抑制）功能进行处理。
一个推荐的方法是尽可能使上游Alertmanager高度容错，而不是关注Prometheus服务器的容错能力
								server01
alertmanager01   prometheus01	server02
alertmanager02   prometheus02 	server03
								server04
设置alertmanager集群
alertmanager --config.file alertmanager.yml --cluster.listen-address 192.168.1.2:8001
alertmanager --config.file alertmanager.yml --cluster.listen-address 192.168.1.3:8001 --cluster.peer 192.168.1.2:8001
alertmanager --config.file alertmanager.yml --cluster.listen-address 192.168.1.4:8001 --cluster.peer 192.167.1.2:8001

查看集群状态
https://192.168.1.2:9093/status

为prometheus配置alertmanager集群
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      - 192.168.1.2:9093
      - 192.168.1.3:9093
      - 192.168.1.4:9093

可扩展性
