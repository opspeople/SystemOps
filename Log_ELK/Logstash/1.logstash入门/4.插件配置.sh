#!/usr/bin/env sh
# 1.输入插件
# 标准输入
input {
	stdin {
		add_field => {"key" =>"value"}
		codec =>"plain"
		tags =>["add"]
		type =>"std"
	}
}

# 文件输入
input {
	file {
		path => ["/var/log/*.log", "/var/log/message"]
		type =>"system"
		start_position =>"beginning"
	}
}
# 常用配置项：
	discover_interval
	exclude
	sincedb_path
	sincedb_write_interval
	stat_interval
	start_position
	close_older
	ignore_older

# TCP输入
input {
	tcp {
		port => 8888
		mode =>"server"
		ssl_enable => false
	}
}
# 在启动Logstash进程后，在另一个终端运行如下命令即可导入数据：
nc 127.0.0.1 8888 < olddata

# syslog输入
input {
	syslog {
		port =>"514"
	}
}

# http_poller抓取

# 2.编解码配置
# JSON编解码
# 多行事件编码
# 网络流编码
# collectd输入

# 3.过滤器配置
# date时间处理
# grok正则捕获
# dissect解析
# GeoIP地址查询
# JSON编解码
# key-value切分
# metrics数值统计
# mutate数据修改
# 随心所欲的Ruby处理
# split拆分事件
# 交叉日志合并


# 4.输出插件
# 输出到Elasticsearch
output {
	elasticsearch {
		hosts => ["192.168.0.2:9200"]
		index => "logstash-%{type}-%{+YYYY.MM.dd}"
		document_type =>"%{type}"
		flush_size => 20000
		idle_flush_time => 10
		snifing => true
		template_overwrite => true
	}
}
