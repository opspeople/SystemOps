#!/usr/bin/bash
# 主题：
	# kubernetes对node label的管理.sh

# kubectl 管理node
kubectl get node
kubectl delete node

# 更新资源对象的label
# label作为用户可灵活定义的对象属性，在已创建的对象上仍然可以通过kubectl label命令对其进行增删改等操作
# 给一个node添加一个label
kubectl label node k8s-node1 role=kube-node

# 查看label
kubectl get node -a -l "role=kube-labeltest"

# 删除label
# 删除label，只需要在命令行最后指定label的key名，并加一个减号即可
kubectl label node k8s-node1 role-

# 将pod调度到指定的node
# 通过Node的标签（Label）和Pod的nodeSelector属性相匹配，来达到目的
# 在pod中加入nodeSelector定义，
apiVersion: v1
kind: ReplicationController
metadata:
  name: mongo
spec:
  replication: 1
  template:
    metadata:
      labels:
        run: mongo
spec:
  containers:
  - name: mongo
    image: daocloud.io/library/mongo:3.2.4
    ports:
      - containerPort: 27017
    volumeMounts:
      - mountPath: /data/db
        name: mongo
  volumes: [{"name": "mongo", "hostPath":{"path":"/root/volumes/mongo"}}]
  nodeSelector:
    node: kube-labeltest

