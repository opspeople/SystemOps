#!/bin/bash
rute:
  group_by: ['instance','cluster']   	# 路由分组警报的方式
  group_wait: 30s						# 如果引发了新警报，那么Alertmanager将等待下一个选项group_wait中指定的时间段，以便在触发警报之前查看是否收到该组中的其他警报。
  										# 你可以将其视为警报缓冲。
  group_interval: 5m					# Alertmanager将等待group_interval选项中指定的时间段（即5分钟），然后再发送新警报。
  repeat_interval: 3h					# 这个暂停并不适用于我们的警报组，而是适用于单个警报，并且是等待重新发送相同警报的时间段，我们指定为3个小时。
  receiver: email
  routes:								# 分支路由，Alertmanager路由是后序遍历的。
  - match:
      serverity: critical
    receiver: pager
    continue: true						# continue的值默认是false
  - mathch_re:
      serverity: ^(warning|critical)$
    receiver: support_team
receivers:
- name: 'email'
  email_configs:
  - to: 'alerts@example.com'
- name: 'support_team'
  email_configs:
  - to: 'support@example.com'
- nmae: 'pager'
  email_configs:
  - to: 'alert-pager@example.com'

