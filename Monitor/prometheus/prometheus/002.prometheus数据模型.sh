#!/usr/bin/bash
# metrics name & label 指标名称和标签
每条时间序列是由唯一的 指标名称 和 一组 标签 （key=value）的形式组成。

# 指标名称
一般是给监测对像起一名字，例如 http_requests_total 这样，它有一些命名规则，可以包字母数字之类的的。通常是以应用名称开头监测对像数值类型单位这样。例如：
    - push_total
    - userlogin_mysql_duration_seconds
    - app_memory_usage_bytes
# 标签
就是对一条时间序列不同维度的识别了，例如 一个http请求用的是POST还是GET，它的endpoint是什么，这时候就要用标签去标记了。最终形成的标识便是这样了
    http_requests_total{method="POST",endpoint="/api/tracks"}


# Prometheus的四种数据类型
# 001 Counter 
Counter 用于累计值，例如 记录 请求次数、任务完成数、错误发生次数。

一直增加，不会减少。

重启进程后，会被重置。

    例如：http_response_total{method="GET",endpoint="/api/tracks"} 10
    10秒后抓取 http_response_total{method="GET",endpoint="/api/tracks"} 100

# 002 Gauge

Gauge 常规数值，例如 温度变化、CPU,内存,网络使用变化。

可变大，可变小。

重启进程后，会被重置

  例如：memory_usage_bytes{host="master-01"} 100 < 抓取值
  memory_usage_bytes{host="master-01"} 30
  memory_usage_bytes{host="master-01"} 50
  memory_usage_bytes{host="master-01"} 80 < 抓取值

# 003 Histogram

Histogram 可以理解为柱状图的意思，常用于跟踪事件发生(通常是请求持续时间或响应大小)的规模，例如：请求耗时、响应大小。它特别之处是可以对记录的内容进行分组，提供 count 和 sum 全部值的功能。

例如：{小于10=5次，小于20=1次，小于30=2次}，count=7次，sum=7次的求和值

# 004 Summary

Summary和Histogram十分相似，常用于跟踪事件(通常是要求持续时间和响应大小)发生的规模，例如：请求耗时、响应大小。同样提供 count 和 sum 全部值的功能。
例如：count=7次，sum=7次的值求值
它提供一个quantiles的功能，可以按%比划分跟踪的结果。例如：quantile取值0.95，表示取采样值里面的95%数据。

# Jobs and Instances

在prometheus中，任何被采集的目标被称为instance,通常对应于单个进程，而相同类型(可扩展性和可靠性的复制)的instance集合被称为Job。例如:Api server job由4个复制instance组成:

- job: api-server
    - instance1: 1.2.3.4:5670
    - instance2: 1.2.3.4:5671
    - instance3: 5.6.7.8:5670
    - instance3: 5.6.7.8:5671

# 自动生成标签和时间序列

当prometheus采集目标时，它会自动附加某些标签，用于识别被采集的目标。

job: 配置目标所属的job名称
instance: 目标 HTTP URL
:部分
如果任何一个标签已经存在于采集的数据中，则此行为依赖honor_labels 配置选项。

对于每个被采集的instance,prometheus存储如下的时间序列样本：

up{job="",instance=""} 1 		# 如果实例处于health，为1，否则为0
scrape_duration_seconds{job="",instance=""} # 持续采集时间
“up”时间序列metric对于instance可用性监控是有效的。
