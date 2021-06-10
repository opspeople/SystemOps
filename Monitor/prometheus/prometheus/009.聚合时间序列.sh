#!/bin/bash
选择一个指标
	promhttp_metric_handler_requests_total

(1).SUM 汇总HTTP请求
SUM(promhttp_metric_handler_requests_total)

(2).按作业类型分类 by
SUM(promhttp_metric_handler_requests_total) by (job)
# PromQL 的 without，可以不按特定维度进行聚合

(3).转换成一个速率
SUM(rate(promhttp_metric_handler_requests_total[5m])) by (job)

时间聚合单位：
	s 秒
	m 分钟
	h 小时
	d 天
	w 周
