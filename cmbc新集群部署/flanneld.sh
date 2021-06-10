#!/bin/bash

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


If the –kube-subnet-mgr argument is true, flannel reads its configuration from /etc/kube-flannel/net-conf.json.
kubectl edit cm -n kube-system kube-flannel-cfg
kubectl get pod -n kube-system -l app=flannel
cat /run/flannel/subnet.env
cat /etc/cni/net.d/10-flannel.conflist

If the –kube-subnet-mgr argument is false, flannel reads its configuration from etcd. By default, it will read the configuration from /coreos.com/network/config (which can be overridden using –etcd-prefix).
# etcd 写入集群Pod网段
etcdctl --endpoints=${ETCD_ENDPOINTS} \
  --ca-file=ca.pem --cert-file=flanneld.pem --key-file=flanneld-key.pem \
  set /coreos.com/network/config '{"Network": "172.30.0.0/16", "SubnetLen": 21, "Backend": {"Type": "vxlan"}}'
etcdctl get /coreos.com/network/config
cat /run/flannel/subnet.env
sudo iptables -I INPUT -p udp -m udp --dport 8472 -j ACCEPT
sudo iptables -I INPUT 1 -p udp --dport 8472 -j ACCEPT -m comment --comment "vxlan"
sudo iptables -I FORWARD 1 -i flannel.1 -j ACCEPT -m comment --comment "flannel subnet"
sudo iptables -I FORWARD 1 -o flannel.1 -j ACCEPT -m comment --comment "flannel subnet"
sudo iptables -L -n | grep 8472
sudo ip -d link show cni0
bridge vlan show
ip -d link show flannel.1
kubectl get node -o jsonpath='{.items[*].spec.podCIDR}'
kubectl get node -o jsonpath='{range .items[*]}{@.metadata.name}{"\t"}{@.spec.podCIDR}{"\n"}{end}'
kubectl get node -o jsonpath='{range .items[*]}{@.metadata.name}{"\t"}{@.spec.podCIDR}{"\t"}{@.status.addresses[?(@.type=="InternalIP")].address}{"\n"}{end}'
kubectl get node -o custom-columns='NAME:.metadata.name,EXTERNAL-IP:.status.addresses[?(@.type=="ExternalIP")].address,INTERNAL-IP:.status.addresses[?(@.type=="InternalIP")].address,POD-CIDR:.spec.podCIDR'
kubectl get node -o go-template --template '{{range .items}}{{.metadata.name}}{{"\t"}}{{.spec.podCIDR}}{{"\n"}}{{end}}'
kubectl -n kube-system get configmap kube-flannel-cfg -o yaml
kubectl get po -o json | jq .items[].status.podIP -r
# If your nodes do not have a podCIDR, then either use 
# the --pod-cidr kubelet command-line option or 
# the --allocate-node-cidrs=true --cluster-cidr=<cidr> kube-controller-manager command-line options.
######################################
# the --cluster-cidr string kube-proxy command-line options.
# The CIDR range of pods in the cluster. When configured, traffic sent to a Service cluster IP from outside this range will be masqueraded and traffic sent from pods to an external LoadBalancer IP will be directed to the respective cluster IP instead
# flannel uses UDP port 8285 for sending encapsulated IP packets. Make sure to enable this traffic to pass between the hosts. If you find that you can't ping containers across hosts, this port is probably not open.

# -iface value和-iface-regex value可以指定网卡
      containers:
      - name: kube-flannel
        image: quay.io/coreos/flannel:v0.11.0-amd64
        command:
        - /opt/bin/flanneld
        args:
        - --ip-masq
        - --kube-subnet-mgr
        - --iface=ens32
        #- --iface=eth0
        - --iface-regex=eth*|ens*

cat /run/flannel/subnet.env 
FLANNEL_NETWORK=4.0.0.0/16
FLANNEL_SUBNET=4.0.34.1/24
FLANNEL_MTU=1472
FLANNEL_IPMASQ=false

cat /run/flannel/docker 
DOCKER_OPT_BIP="--bip=4.0.34.1/24"
DOCKER_OPT_IPMASQ="--ip-masq=true"
DOCKER_OPT_MTU="--mtu=1472"
DOCKER_NETWORK_OPTIONS=" --bip=4.0.34.1/24 --ip-masq=true --mtu=1472 "

## flanneld.service
ExecStartPost=/usr/local/bin/mk-docker-opts.sh -k DOCKER_NETWORK_OPTIONS -d /run/flannel/docker
ExecStartPost=/usr/local/bin/mk-docker-opts.sh -k DOCKER_NETWORK_OPTIONS -d /run/docker_opts.env

## docker.service
EnvironmentFile=-/run/flannel/docker
ExecStartPost=/sbin/iptables -I FORWARD -s 0.0.0.0/0 -j ACCEPT
ExecStopPost=/bin/bash -c '/sbin/iptables -D FORWARD -s 0.0.0.0/0 -j ACCEPT &> /dev/null || :'
ExecStart=/usr/local/bin/dockerd $DOCKER_NETWORK_OPTIONS

