查询持久化的三种方式：
	记录规则 根据查询创建新指标
	警报规则 从查询生成警报
	可视化 	使用Grafana等仪表板可视化查询


记录规则
	好处：
		跨多个时间序列生成聚合
		预先计算消耗大的查询
		产生可用于生成警报的时间序列

规则文件在Prometheus配置文件的rules_files块中指定
在prometheus.yml文件的同一文件夹中创建一个名为rules的子文件夹，用于保存我们的记录规则
新建一个名为node_rules.yml的文件。

prometheus配置文件prometheus.yml的rule_files块中添加这个文件：
rule_files:
  - "rules/node_rules.yml"

添加记录规则
groups:
  - name: node_rules
    interval: 10s # 记录规则时间间隔
    rules:
    - record: instance:node_cpu:avg_rate5m
      expr: 100 - avg(irate(node_cpu_seconds_total{job='node',mode='idle'}[5m])) by (instance) * 100

记录规则的命名格式：
level:metric:operations
其中level表示聚合级别，以及规则输出的标签。metric是指标名称，除了使用rate()或irate()函数剥离_total计数器之外，应该保持不变。
这样的命名可以帮助你更轻松地找到新指标。最后，operations 是应用于指标的操作列表，一般最新的操作放在前面。

向记录规则添加标签
groups:
  - name: node_rules
    interval: 10s # 记录规则时间间隔
    rules:
    - record: instance:node_cpu:avg_rate5m
      expr: 100 - avg(irate(node_cpu_seconds_total{job='node',mode='idle'}[5m])) by (instance) * 100
    labels:
      metric_type: aggregation

