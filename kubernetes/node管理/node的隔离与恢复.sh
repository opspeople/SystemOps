#!/usr/bin/bash
# 通过配置文件将node脱离调度范围
cat unschedule_node.yaml
apiVersion: v1
kind: Nodemetadata:
  name: k8s-node1
  labels:
    namne: k8s-node1spec:
    unschedulable: true
# 执行
kubectl replace -f unschedule_node.yaml

# 通过命令行的方式
kubectl patch node k8s-node1 -p '{"spec": "{"unschedulable": "true"}"}'

# 恢复
# 无论上面哪一种方法，其实都是将unsechdulable的值改为true，实现 了隔离，同理，恢复时，只需要将unschedulable的值改为false即可。
# 当然这里还有另一种更简单的方式：
kubectl cordon k8s-node1 	# 将k8s-node1节点设置为不可调度模式
kubectl drain k8s-node1 	# 将当前运行在k8s-node1节点上的容器驱离
kubectl uncordon k8s-node1 	# 执行完维护后，将节点重新加入调度
