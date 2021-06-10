#!/bin/bash
重新标记
# 删除不必要的指标
# 从指标中删除敏感或不需要的标签
# 添加、编辑或修改指标的标签值或标签格式

- job_name: 'docker'
  static_configs:
    - targets: ['192.168.1.2:8080', '192.168.1.3:8080', '192.168.1.4:8080']
  metric_relabel_configs:
    - source_labels: [__name__]
      searator: ',' 	# 覆盖分隔符配置
      regex: '(container_tasks_state|container_memory_failures_total)'
      action: drop		# 删除不必要的标签

