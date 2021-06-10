#!/bin/bash
001.更多规则
groups:
- name: node_alerts
  rules:
  - alert: DiskWillFillIn4Hours
    expr: predict_lines(node_filesystem_free_bytes{mountpoint="/"}[1h],4*3600<0)
    for: 5m
    labels:
      serverity: critical
    annotations:
      summary: Disk on {{ $labels.instance }} will fill in approximately 4 hours 
  - alert: InstanceDown
    expr: up{job="node"} == 0
    for: 10m
    labels:
      serverity: critical
    annotations:
      summary: Host {{ $labels.instance }} of {{ $labels.job }} is down!

002.模板
模板（template）是一种在警报中使用时间序列数据的标签和值的方法，可用于注解和标签。
模板使用标准的Go模板语法，并暴露一些包含时间序列的标签和值的变量。
标签以变量$labels形式表示，指标的值则是变量$value。
annotations:
  summary: High Node CPU of {{ humanize $value }}% for 1 hour 