#!/usr/bin/env sh
1.etcd依赖环境Golang环境搭建
go*.tar.gz 方式
解压
添加配置到文件 ~/.bash_profile
export GOROOT=/Users/xxx/Documents/go
export GOBIN=$GOROOT/bin
export GOARCH=x86_64
export GOOS=darwin
export GOPATH=/Users/xxx/Documents/GOProject
export PATH=$PATH:$GOBIN:$GOPATH/bin
source ~/.bash_profile

2.etcd简介
	单机模式
	集群模式

	etcd监听2379和2380端口
		2379 用于与客户端的交互
		2380 用户etcd节点内部交互

	etcd集群启动：
	./bin/etcd --name infra0 --initial-advertise-peer-urls http://192.168.1.2:2380 \
		--listen-peer-urls http://192.168.1.2:2380 \
		--listen-client-urls http://192.168.1.2:2379 \
		--advertise-client-urls http://192.168.1.2:2380 \
		--initial-cluster-token etcd-cluster-1 \
		--initial-cluster infra0=http://192.168.1.2:2380, \
			infra1=http://192.168.1.3:2380,infra2=http://192.168.1.4:2380 \
		--initial-cluster-state new

		./bin/etcd --name infra0 --initial-advertise-peer-urls http://192.168.1.3:2380 \
		--listen-peer-urls http://192.168.1.3:2380 \
		--listen-client-urls http://192.168.1.3:2379 \
		--advertise-client-urls http://192.168.1.3:2380 \
		--initial-cluster-token etcd-cluster-1 \
		--initial-cluster infra0=http://192.168.1.2:2380, \
			infra1=http://192.168.1.3:2380,infra2=http://192.168.1.4:2380 \
		--initial-cluster-state new

		./bin/etcd --name infra0 --initial-advertise-peer-urls http://192.168.1.4:2380 \
		--listen-peer-urls http://192.168.1.4:2380 \
		--listen-client-urls http://192.168.1.4:2379 \
		--advertise-client-urls http://192.168.1.4:2380 \
		--initial-cluster-token etcd-cluster-1 \
		--initial-cluster infra0=http://192.168.1.2:2380, \
			infra1=http://192.168.1.3:2380,infra2=http://192.168.1.4:2380 \
		--initial-cluster-state new

	写入配置文件：
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"  #etcd数据保存目录
ETCD_LISTEN_CLIENT_URLS="http://10.25.72.164:2379,http://localhost:2379"  #供外部客户端使用的url
ETCD_ADVERTISE_CLIENT_URLS="http://10.25.72.164:2379,http://localhost:2379" #广播给外部客户端使用的url
ETCD_NAME="etcd1"   #etcd实例名称

ETCD_LISTEN_PEER_URLS="http://10.25.72.164:2380"  #集群内部通信使用的URL
ETCD_INITIAL_ADVERTISE_PEER_URLS="http://10.25.72.164:2380"  #广播给集群内其他成员访问的URL
ETCD_INITIAL_CLUSTER="etcd1=http://10.25.72.164:2380,etcd2=http://10.25.72.233:2380,etcd3=http://10.25.73.196:2380"    #初始集群成员列表
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster" #集群的名称
ETCD_INITIAL_CLUSTER_STATE="new"  #初始集群状态，new为新建集群
