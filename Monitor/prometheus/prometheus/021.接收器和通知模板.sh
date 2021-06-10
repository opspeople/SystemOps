#!/bin/bash
现在已经有了一些基本规则，让我们添加一个非电子邮件的接收器.
我们将添加Slack接收器，它会消息发送到Slack实例。
让我们在alertmanager.yml配置文件中查看新接收器配置。
receivers:
- name: 'pager'
  email_configs:
  - to: 'alert-pager@example.com'
  slack_configs:
  - api_url: http://hooks.slack.com/services/ABC123/ABC123/EXAMPLE
    channel: #monitoring
    text: '{{ .CommonAnnotations.summary }}'

通知模板
/etc/alertmanager/templates/slack.tmpl
{{ define "slack.example.txt" }}{{ .CommonAnnotations.summary }}{{ end }}

添加Slack接收器
slack_configs:
  - api_url: http://hooks.slack.com/services/ABC123/ABC123/EXAMPLE
    channel: #monitoring
    text: '{{ template "slack.example.text" . }}'

