#!/bin/bash

1.基础环境
# CentOS 8.2
# kubernetes 1.15.7
	# k8s 下载地址 https://storage.googleapis.com/kubernetes-release/release/v1.15.7/kubernetes-server-linux-amd64.tar.gz
# etcd 3.3.11
	# wget https://github.com/etcd-io/etcd/releases/download/3.3.11/etcd-3.3.11-linux-amd64.tar.gz
# flanneld 
# 服务器架构: x86_64
# 

2.依赖工具
# 


flanneld启动参数
# flanneld 启动参数
  -etcd-cafile string
    	SSL Certificate Authority file used to secure etcd communication
  -etcd-certfile string
    	SSL certification file used to secure etcd communication
  -etcd-endpoints string
    	a comma-delimited list of etcd endpoints (default "http://127.0.0.1:4001,http://127.0.0.1:2379")
  -etcd-keyfile string
    	SSL key file used to secure etcd communication
  -etcd-password string
    	password for BasicAuth to etcd
  -etcd-prefix string
    	etcd prefix (default "/coreos.com/network")
  -etcd-username string
    	username for BasicAuth to etcd
  -healthz-ip string
    	the IP address for healthz server to listen (default "0.0.0.0")
  -healthz-port int
    	the port for healthz server to listen(0 to disable)
  -iface value
    	interface to use (IP or name) for inter-host communication. Can be specified multiple times to check each option in order. Returns the first match found.
  -iface-regex value
    	regex expression to match the first interface to use (IP or name) for inter-host communication. Can be specified multiple times to check each regex in order. Returns the first match found. Regexes are checked after specific interfaces specified by the iface option have already been checked.
  -ip-masq
    	setup IP masquerade rule for traffic destined outside of overlay network
  -iptables-forward-rules
    	add default accept rules to FORWARD chain in iptables (default true)
  -iptables-resync int
    	resync period for iptables rules, in seconds (default 5)
  -kube-annotation-prefix string
    	Kubernetes annotation prefix. Can contain single slash "/", otherwise it will be appended at the end. (default "flannel.alpha.coreos.com")
  -kube-api-url string
    	Kubernetes API server URL. Does not need to be specified if flannel is running in a pod.
  -kube-subnet-mgr
    	contact the Kubernetes API for subnet assignment instead of etcd.
  -kubeconfig-file string
    	kubeconfig file location. Does not need to be specified if flannel is running in a pod.
  -log_backtrace_at value
    	when logging hits line file:N, emit a stack trace
  -public-ip string
    	IP accessible by other nodes for inter-host communication
  -subnet-file string
    	filename where env variables (subnet, MTU, ... ) will be written to (default "/run/flannel/subnet.env")
  -subnet-lease-renew-margin int
    	subnet lease renewal margin, in minutes, ranging from 1 to 1439 (default 60)
  -v value
    	log level for V logs
  -version
    	print version and exit
  -vmodule value
    	comma-separated list of pattern=N settings for file-filtered logging

    	