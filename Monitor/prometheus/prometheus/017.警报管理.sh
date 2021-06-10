#!/bin/bash
警报插件：
	alertmanager

alertmanager如何工作
prometheus警报规则 -> alertmanager -> slack|电子邮件|Pager

安装alertmanager

配置Alertmanager
配置文件alertmanager.yml
mkdir /etc/alertmanager/
cat /etc/alertmanager/alertmanager.yml
# 配置电子邮件发送
global:
  smtp_smarthost: 'localhost:25'
  smtp_from: 'alertmanager@example.com'
  smtp_require_tls: false

templates:
  - '/etc/alertmanager/template/*.tmpl'

route:
  receiver: email

receivers:
- name: 'email'
  email_configs:
  - to: 'alerts@example.com'

运行alertmanager
alertmanager --config.file alertmanager.yml

prometheus配置alertmanager
alerting:
  alertnamagers:
  - static_configs:
    - targets:
      - alertmanager: 9093

prometheus自动发现alertmanager
alerting:
  alertnamagers:
  - dns_sd_configs:
    - names: ['_alertnamager._tcp.example.com']

监控alertmanager
- job_name: 'alertmanager'
  static_configs:
    - targets: ['localhost:9093']

从http://localhost:9093/metrics查看以alertnamager_为前缀的时间序列数据

