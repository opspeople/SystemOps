#!/bin/bash
mkdir /etc/alertmanager/rules

rule_files:
  - "rules/*_rules.yml"
  - "rules/*_alerts.yml"

添加第一条警报规则
groups:
- name: node_alerts
  rules:
  - alert:
    expr: instance:node_cpu:avg_rate5m > 80
    for: 60m
    labels:
      serverity: warning
    annotations:
      summary: High Node CPU for 1 hour
      console: You might want to check the Node Dashboard at http://grafana.example.com/dashboard/db/node-dashboard

警报触发
状态：
	Inactive 	警报未激活
	Pending 	警报已满足测试表达式条件，但仍等待for子句中指定的持续时间
	Firing		警报已满足测试表达式条件，并且Pending的时间已超过for子句的持续时间。

alertmanager的警报
我们的警报现在处于Firing状态，并且已将通知推送到Alertmanager。
可以在Prometheus Web界面http://localhost:9090/alerts中看到这个警报及其状态。
Prometheus将为Pending和Firing状态中的每个警报创建指标，这个指标被称为ALERT，并且会像
HighNodeCPU警报示例那样构建。
ALERT{alertname="HighNodeCPU",alertstate="firing",serverity=warning,instance="192.168.1.3:9100"}
每个alert指标都具有固定值1，并且在警报处于Pending或Firing状态期间存在。
在此之后，它将不接收任何更新，并且最终会过期。
