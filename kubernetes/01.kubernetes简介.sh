#!/bin/bash

# 启动MySQL服务
apiVersion: v1
kind: ReplicationController
metadata:
  name: mysql
spec:
  replication: 1
  selector:
    app: mysql
  template:
    metadata:
      labels:
        app: mysql
    sepc:
      containers:
      - name: mysql
        image: mysql
        ports:
        - containerPort: 3306
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: '123456'

# service配置
apiVersion: v1
kind: Service
metadata:
  name: mysql 
spec:
  ports:
    - port: 3306
  selector:
    app: mysql

# kubernetes基本术语
Master
  集群控制节点，关键进程：
  kube-apiserver 提供了HTTP Rest接口的关键服务进程，是kubernetes里所有的资源的增删改查等操作的唯一入口
  kube-controller-manager kubernetes里所有资源对象的自动化控制中心
  kube-scheduler 负责资源调度的进程

Node
  k8s集群的工作负载节点
  关键进程
    kubelet 负责Pod对应的容器的创建、启停等任务，同时与Master节点密切协作，实现集群管理的功能
    kube-proxy 实现kubernetes Service的通信与负载均衡机制的重要组件
    docker engine 负载本机的容器的创建和管理工作

Pod
  pod的组成 根容器"Pause容器" + 业务容器

apiVersion: v1
kind: Pod
metadata:
  name: myweb
  labels:
    name: myweb
spec:
  containers:
  - name: myweb
    image: kubeguide/tomcat-app:v1
    ports:
    - containerPort: 8080
    env:
    - name: MYSQL_ROOT_PASSWORD
      value: '123456'
    - name: MYSQL_ROOT_HOST
      value: 'mysql'

Pod资源限制
apiVersion: v1
kind: Pod
metadata:
  name: myweb
  labels:
    name: myweb
spec:
  containers:
  - name: myweb
    image: kubeguide/tomcat-app:v1
    ports:
    - containerPort: 8080
    env:
    - name: MYSQL_ROOT_PASSWORD
      value: '123456'
    - name: MYSQL_ROOT_HOST
      value: 'mysql'
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "128Mi"
        cpu: "500m"

Label 标签
  一个Label是一个key=value的键值对，其中key与value由用户自己指定。
  Label可以附加到各种资源对象上，例如：Node、Pod、Service、RC等
  常用的Label实例：
  版本标签: "release":"stable","release":"canary"
  环境标签: "environment":"dev","environment":"production"
  架构标签: "tier":"frontend"
  分区标签: "partition":"customerA"

RC Replication Controller
  声明某种Pod的副本数量在任意时刻都复合某个预期值，所以RC的定义包括如下几个部分：
    replicas Pod期待的副本数量
    selector 用于筛选目标Pod的label selector
    template 当Pod的副本数量小于预期数量的时候，用于创建新Pod的Pod模板
apiVersion: v1
kind: ReplicationController
metadata:
  name: frontend
sepc:
  replicas: 1
  selector: 
    tier: frontend
  template:
    metadata:
      labels:
        app: app-demo
        tier: frontend
  spec:
    containers:
    - name: tomcat-demo
      image: tomcat
      imagePullPolicy: IfNotPresent
      env:
      - name: GET_HOSTS_FROM
        value: dns
      ports:
      - containerPort: 80
Scaling 动态缩放
kubectl scale rc redis-slave --replicas=3 # 动态修改Pod数量
在k8s1.2的时候ReplicationController升级为ReplicaSet
ReplicaSet 支持集合的Label selector，RC只支持等式的Label Selector
apiVersion: extensions/v1beta1
kind: ReplicaSet
metadata:
  name: frontend
spec:
  selector:
    matchLabels:
      tier: frontend
    matchExpressions:
      - {key: tier, operator: In, values: [frontend]}
  template:
    ...

Deployment
  kubernetes 1.2 引入的新概念，为了更好的解决Pod的编排问题，Deployment在内部使用了ReplicaSet来实现目的