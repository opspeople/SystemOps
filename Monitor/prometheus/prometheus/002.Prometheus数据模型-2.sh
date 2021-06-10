#!/bin/bash
Prometheus收集时间序列数据。为了处理这些数据，它使用一个多维时间序列数据模型。
这个时间序列数据模型结合了，时间序列名称和标签(label)的键值对，这些标签提供了维度。

指标名称
	包含：
		ASCII字符、数字、下划线和冒号
	如：	
		website_visits_total 网站方位总数

标签
	标签为Prometheus数据模型提供了维度。他们为特定时间序列添加上下文。

	分类：
		插桩标签(instrumentation label)
		目标标签(target label)

采样数据
	时间序列的真实值是采样的结果，包括：
		一个float64类型的数值
		一个毫秒精度的时间戳

符号表示
	Prometheus将时间序列表示为符号(notation)
	<time series name>{<label name>=<label value>, ...}
	例：
	total_website_visits{site="MegaApp", location="NJ", instance="webserver", job="web"}
	首先是时间序列名称，后面跟着一组键值对标签。
	通常所有的时间序列都有一个instance标签(标识源主机或应用程序)以及一个job标签

