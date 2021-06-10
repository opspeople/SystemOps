# 值的查询
# 1.单个变量的值prometheus
promhttp_metric_handler_requests_total

# 2.查看单个变量等于某个值
promhttp_metric_handler_requests_total{code='200'}

# 3.统计某个变量的时间序列
count(promhttp_metric_handler_requests_total)

# grafana接口展示
rate(promhttp_metric_handler_requests_total{code='200'}[1m])
