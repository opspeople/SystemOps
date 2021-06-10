#!/bin/bash

node
kubectl get node # 查看有哪些node节点
kubectl describe node k8s-node1 # 查看k8s-node1节点的详细信息


Scaling 动态缩放
kubectl scale rc redis-slave --replicas=3 # 动态修改Pod数量
