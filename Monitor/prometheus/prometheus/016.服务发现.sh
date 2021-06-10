#!/bin/bash
服务发现实现机制：
	从配置管理工具生成的文件中接收目标列表
	查询API以获取目标列表
	使用DNS记录已返回目标列表

基于文件的服务发现
	基于文件的发现只比静态配置更先进一小步，但它非常适合配置管理工具。
	借助基于文件的服务发现，Prometheus会使用文件中指定的目标。
	这些文件通常由另一个系统生成，例如Puppet、Ansible或Chef等配置管理系统，或者从其他源（如CMDB）查询。
	定期执行脚本或进行查询可以（重新）生成这些文件。
	Prometheus会按指定的时间计划从这些文件重新加载目标。
	这些文件可以是YAML或JSON格式，包含定义的目标列表，就像我们在静态配置中定义它们一样。
	让我们从将现有作业迁移到基于文件的服务发现开始。
- job_name: code
  file_sd_configs:
    - files:
      - targets/nodes/*.json
      refresh_interval: 5m

- job_name: docker
  file_sd_configs:
    - files:
      - targets/docker/*.json
      refresh_interval: 5m

mkdir targets/nodes/ targets/docker/
cd targets/nodes/
touch node.json
[{
  "targets":[
    "192.168.1.2:9100",
    "192.168.1.3:9100",
    "192.168.1.4:9100"
  ]
}]

touch docker.yml
- targets:
  - "192.168.1.2:9100"
  - "192.168.1.3:9100"
  - "192.168.1.4:9100"
- labbels:
  - datacerter: "nj" # 添加标签


基于API的服务发现


基于DNS的服务发现
- job_name: webapp
  dns_sd_configs:
    - name: ['prometheus01.com']
      type: A 
      port: 9100