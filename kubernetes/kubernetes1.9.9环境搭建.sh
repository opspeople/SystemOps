二. 创建tls证书和秘钥
1.安装cfssl工具
master节点部署即可
$wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
$wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
$wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64
$ chmod +x cfssl*
$mv cfssl_linux-amd64 cfssl
$mv cfssljson_linux-amd64 cfssljson
$mv cfssl-certinfo_linux-amd64 cfssl-certinfo
$mv cfssl* /usr/bin/
$ll /usr/bin/cfssl*
2.创建CA配置文件
$mkdir /root/ssl
$cd ssl/
$cfssl print-defaults config > config.json
$cfssl print-defaults csr > csr.json
3.创建ca-config.json文件
$cat > ca-config.json <<EOF
 {
   "signing": {
     "default": {
       "expiry": "87600h"
     },
     "profiles": {
       "kubernetes": {
         "usages": [
             "signing",
             "key encipherment",
             "server auth",
             "client auth"
         ],
         "expiry": "87600h"
       }
     }
   }
 }
EOF
4.创建CA证书签名请求
 $cat > ca-csr.json <<EOF
 {
   "CN": "kubernetes",
   "key": {
     "algo": "rsa",
     "size": 2048
   },
   "names": [
     {
       "C": "CN",
       "ST": "BeiJing",
       "L": "BeiJing",
       "O": "k8s",
       "OU": "System"
     }
   ]
 }
EOF
5.生成 CA 证书和私钥
$cfssl gencert -initca ca-csr.json | cfssljson -bare ca
$ ls ca*
ca-config.json  ca.csr  ca-csr.json  ca-key.pem  ca.pem
6.创建 kubernetes 证书
注：红色内容写入k8s集群环境中所有节点的IP地址。
$cat > kubernetes-csr.json <<EOF
 {
     "CN": "kubernetes",
     "hosts": [
       "127.0.0.1",
      "192.168.7.191",
      "192.168.7.192",
      "192.168.7.193",
       "10.254.0.1",
       "kubernetes",
       "kubernetes.default",
       "kubernetes.default.svc",
       "kubernetes.default.svc.cluster",
       "kubernetes.default.svc.cluster.local"
     ],
     "key": {
         "algo": "rsa",
         "size": 2048
     },
     "names": [
         {
             "C": "CN",
             "ST": "BeiJing",
             "L": "BeiJing",
             "O": "k8s",
             "OU": "System"
         }
     ]
 }
EOF
注：下图是我验证文档可用性时，重新搭建的环境，上文红色中地址仅写了master的地址，后面查看etcd集群健康状态时失败，原因是没有其它两个从节点的认证。所以这里建议写k8s集群中所有节点地址。
7.生成 kubernetes 证书和私钥
$cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes kubernetes-csr.json | cfssljson -bare kubernetes
$ls kubernetes*
kubernetes.csr  kubernetes-csr.json  kubernetes-key.pem  kubernetes.pem
8.创建 admin 证书
$cat > admin-csr.json <<EOF  
 {
   "CN": "admin",
   "hosts": [],
   "key": {
     "algo": "rsa",
     "size": 2048
   },
   "names": [
     {
       "C": "CN",
       "ST": "BeiJing",
       "L": "BeiJing",
       "O": "system:masters",
       "OU": "System"
     }
   ]
 }
EOF
9.生成 admin 证书和私钥
$cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes admin-csr.json | cfssljson -bare admin
$ls admin*
admin.csr  admin-csr.json  admin-key.pem  admin.pem
10.创建 kube-proxy 证书
$cat > kube-proxy-csr.json <<EOF
 {
   "CN": "system:kube-proxy",
   "hosts": [],
   "key": {
     "algo": "rsa",
     "size": 2048
   },
   "names": [
     {
       "C": "CN",
       "ST": "BeiJing",
       "L": "BeiJing",
       "O": "k8s",
       "OU": "System"
     }
   ]
 }
EOF
11.生成 kube-proxy 客户端证书和私钥
$cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes  kube-proxy-csr.json | cfssljson -bare kube-proxy
$ls kube-proxy*
kube-proxy.csr  kube-proxy-csr.json  kube-proxy-key.pem  kube-proxy.pem
12.校验证书
$ openssl x509  -noout -text -in  kubernetes.pem
13.分发证书
$mkdir -p /etc/kubernetes/ssl  #所有节点创建该目录
$cp *.pem /etc/kubernetes/ssl
$scp *.pem root@192.168.7.132:/etc/kubernetes/ssl
$scp *.pem root@192.168.7.133:/etc/kubernetes/ssl
三. 创建高可用etcd集群
1.etcd集群认证文件确认
#确认三个节点目录下都有下面文件。
$ll /etc/kubernetes/ssl/kubernetes*
-rw------- 1 root root 1675 Dec 28 12:24 /etc/kubernetes/ssl/kubernetes-key.pem
-rw-r--r-- 1 root root 1627 Dec 28 12:24 /etc/kubernetes/ssl/kubernetes.pem
2.安装Etcd
三个节点使用yum安装etcd服务。
#yum info etcd 
                      Version     : 3.3.11  我这里的版本。
$yum -y install etcd
3.创建etcd的systemd unit文件
注：
1、IP除了initial-cluster 配置项是配置集群内3个地址的IP外，其他IP均为本机的IP。
2、配置里--name必须与--initial-cluster的名称相对应。
3、通过不同方式安装的软件Execstart配置项下的程序启动命令路径注意修改。
4、WorkingDirectory工作目录需要实现创建，否则启动会报错，yum安装的方式是自动创建的。
3.1.master131节点:
$cat > /usr/lib/systemd/system/etcd.service <<eof
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target
Documentation=https://github.com/coreos
[Service]
Type=notify
WorkingDirectory=/var/lib/etcd/
EnvironmentFile=-/etc/etcd/etcd.conf
ExecStart=/usr/bin/etcd   --name etcd1  --cert-file=/etc/kubernetes/ssl/kubernetes.pem   --key-file=/etc/kubernetes/ssl/kubernetes-key.pem   --peer-cert-file=/etc/kubernetes/ssl/kubernetes.pem   --peer-key-file=/etc/kubernetes/ssl/kubernetes-key.pem   --trusted-ca-file=/etc/kubernetes/ssl/ca.pem   --peer-trusted-ca-file=/etc/kubernetes/ssl/ca.pem   --initial-advertise-peer-urls https://192.168.7.131:2380   --listen-peer-urls https://192.168.7.131:2380   --listen-client-urls https://192.168.7.131:2379,http://127.0.0.1:2379   --advertise-client-urls https://192.168.7.131:2379   --initial-cluster-token etcd-cluster-0   --initial-cluster etcd1=https://192.168.7.131:2380,etcd2=https://192.168.7.132:2380,etcd3=https://192.168.7.133:2380   --initial-cluster-state new   --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
eof
3.2 .node132节点
$cat > /usr/lib/systemd/system/etcd.service <<eof
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target
Documentation=https://github.com/coreos
[Service]
Type=notify
WorkingDirectory=/var/lib/etcd/
EnvironmentFile=-/etc/etcd/etcd.conf
ExecStart=/usr/bin/etcd   --name etcd2   --cert-file=/etc/kubernetes/ssl/kubernetes.pem   --key-file=/etc/kubernetes/ssl/kubernetes-key.pem   --peer-cert-file=/etc/kubernetes/ssl/kubernetes.pem   --peer-key-file=/etc/kubernetes/ssl/kubernetes-key.pem   --trusted-ca-file=/etc/kubernetes/ssl/ca.pem   --peer-trusted-ca-file=/etc/kubernetes/ssl/ca.pem   --initial-advertise-peer-urls https://192.168.7.132:2380   --listen-peer-urls https://192.168.7.132:2380   --listen-client-urls https://192.168.7.132:2379,http://127.0.0.1:2379   --advertise-client-urls https://192.168.7.132:2379   --initial-cluster-token etcd-cluster-0   --initial-cluster etcd1=https://192.168.7.131:2380,etcd2=https://192.168.7.132:2380,etcd3=https://192.168.7.133:2380   --initial-cluster-state new   --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
eof
3.3 .node133节点
$cat > /usr/lib/systemd/system/etcd.service <<eof
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target
Documentation=https://github.com/coreos
[Service]
Type=notify
WorkingDirectory=/var/lib/etcd/
EnvironmentFile=-/etc/etcd/etcd.conf
ExecStart=/usr/bin/etcd   --name etcd3   --cert-file=/etc/kubernetes/ssl/kubernetes.pem   --key-file=/etc/kubernetes/ssl/kubernetes-key.pem   --peer-cert-file=/etc/kubernetes/ssl/kubernetes.pem   --peer-key-file=/etc/kubernetes/ssl/kubernetes-key.pem   --trusted-ca-file=/etc/kubernetes/ssl/ca.pem   --peer-trusted-ca-file=/etc/kubernetes/ssl/ca.pem   --initial-advertise-peer-urls https://192.168.7.133:2380   --listen-peer-urls https://192.168.7.133:2380   --listen-client-urls https://192.168.7.133:2379,http://127.0.0.1:2379   --advertise-client-urls https://192.168.7.133:2379   --initial-cluster-token etcd-cluster-0   --initial-cluster etcd1=https://192.168.7.131:2380,etcd2=https://192.168.7.132:2380,etcd3=https://192.168.7.133:2380   --initial-cluster-state new   --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
eof
4.创建etcd配置文件
注：
1、IP地址替换为本机的即可。
2、ETCD_NAME按照etcd系统服务里面的配置一一对应。
4.1.master131节点:
$cat > /etc/etcd/etcd.conf <<eof
# [member]
ETCD_NAME=etcd1
ETCD_DATA_DIR="/var/lib/etcd"
ETCD_LISTEN_PEER_URLS="https://192.168.7.131:2380"
ETCD_LISTEN_CLIENT_URLS="https://192.168.7.131:2379"
#[cluster]
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://192.168.7.131:2380"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_ADVERTISE_CLIENT_URLS="https://192.168.7.131:2379"
eof
4.2 .node132节点：
$cat > /etc/etcd/etcd.conf <<eof
# [member]
ETCD_NAME=etcd2
ETCD_DATA_DIR="/var/lib/etcd"
ETCD_LISTEN_PEER_URLS="https://192.168.7.132:2380"
ETCD_LISTEN_CLIENT_URLS="https://192.168.7.132:2379"
#[cluster]
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://192.168.7.132:2380"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_ADVERTISE_CLIENT_URLS="https://192.168.7.132:2379"
eof
4.3 .node133节点：
$cat > /etc/etcd/etcd.conf <<eof
# [member]
ETCD_NAME=etcd3
ETCD_DATA_DIR="/var/lib/etcd"
ETCD_LISTEN_PEER_URLS="https://192.168.7.133:2380"
ETCD_LISTEN_CLIENT_URLS="https://192.168.7.133:2379"
#[cluster]
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://192.168.7.133:2380"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_ADVERTISE_CLIENT_URLS="https://192.168.7.133:2379"
eof
5.开机启动及启动etcd
systemctl daemon-reload
systemctl enable etcd
systemctl start etcd
systemctl status etcd
6.检测集群工作情况
在任意一个节点，master或者node都可以，执行以下命令
$etcdctl \
  --ca-file=/etc/kubernetes/ssl/ca.pem \
  --cert-file=/etc/kubernetes/ssl/kubernetes.pem \
  --key-file=/etc/kubernetes/ssl/kubernetes-key.pem \
  cluster-health
如果输出类似如下如的情况，代表成功：
注：
　　1、建议所有节点都运行一次检测。
　　2、以后使用etcd查询数据都需要使用认证文件，即上述格式。
四.master上安装 kubectl及生成配置文件
1.下载kubenetes软件包
#这一步我们把二进制包全部分发下去，后续都会使用。
$cd /root/
$wget https://dl.k8s.io/v1.9.2/kubernetes-server-linux-amd64.tar.gz
$tar -xzvf kubernetes-server-linux-amd64.tar.gz
$cd kubernetes/server/bin/
$cp kubectl kube-apiserver kube-controller-manager kube-scheduler /usr/bin/
$scp kubelet kube-proxy root@192.168.7.132:/usr/bin/
$scp kubelet kube-proxy root@192.168.7.133:/usr/bin/
2.创建 kubectl kubeconfig 文件
# 请明确这个KUBE_APISERVER变量都是指向masster的api-server地址。
$cd /root/
$export KUBE_APISERVER="https://192.168.7.131:6443"
# 设置集群参数
$kubectl config set-cluster kubernetes \
  --certificate-authority=/etc/kubernetes/ssl/ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER}
# 设置客户端认证参数
$kubectl config set-credentials admin \
  --client-certificate=/etc/kubernetes/ssl/admin.pem \
  --embed-certs=true \
  --client-key=/etc/kubernetes/ssl/admin-key.pem
# 设置上下文参数
$kubectl config set-context kubernetes \
  --cluster=kubernetes \
  --user=admin
# 设置默认上下文
$kubectl config use-context kubernetes
3.创建 TLS Bootstrapping Token
$export BOOTSTRAP_TOKEN=$(head -c 16 /dev/urandom | od -An -t x | tr -d ' ')
$cat > token.csv <<EOF
${BOOTSTRAP_TOKEN},kubelet-bootstrap,10001,"system:kubelet-bootstrap"
EOF
$cp token.csv /etc/kubernetes/
$scp token.csv root@192.168.7.132:/etc/kubernetes/
$scp token.csv root@192.168.7.133:/etc/kubernetes/
4.创建 kubelet bootstrapping kubeconfig 文件
$cd /etc/kubernetes
$export KUBE_APISERVER="https://192.168.7.131:6443"
# 设置集群参数
$kubectl config set-cluster kubernetes \
  --certificate-authority=/etc/kubernetes/ssl/ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER} \
  --kubeconfig=bootstrap.kubeconfig
# 设置客户端认证参数
$kubectl config set-credentials kubelet-bootstrap \
  --token=${BOOTSTRAP_TOKEN} \
  --kubeconfig=bootstrap.kubeconfig
# 设置上下文参数
$kubectl config set-context default \
  --cluster=kubernetes \
  --user=kubelet-bootstrap \
  --kubeconfig=bootstrap.kubeconfig
# 设置默认上下文
$kubectl config use-context default --kubeconfig=bootstrap.kubeconfig
5.创建 kube-proxy kubeconfig 文件
$export KUBE_APISERVER="https://192.168.7.131:6443"
# 设置集群参数
$kubectl config set-cluster kubernetes \
  --certificate-authority=/etc/kubernetes/ssl/ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER} \
  --kubeconfig=kube-proxy.kubeconfig
# 设置客户端认证参数
$kubectl config set-credentials kube-proxy \
  --client-certificate=/etc/kubernetes/ssl/kube-proxy.pem \
  --client-key=/etc/kubernetes/ssl/kube-proxy-key.pem \
  --embed-certs=true \
  --kubeconfig=kube-proxy.kubeconfig
# 设置上下文参数
$kubectl config set-context default \
  --cluster=kubernetes \
  --user=kube-proxy \
  --kubeconfig=kube-proxy.kubeconfig
# 设置默认上下文
$kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig
6.分发 kubeconfig 文件到节点
$scp bootstrap.kubeconfig kube-proxy.kubeconfig root@192.168.7.132:/etc/kubernetes/
$scp bootstrap.kubeconfig kube-proxy.kubeconfig root@192.168.7.133:/etc/kubernetes/
五.master安装apiserver、cheduler，controller-manager
1.确认二进制文件是否部署
 $cd /root/
 $ll /usr/bin/kube*
-rwxr-xr-x 1 root root 211557415 Dec 28 13:34 /usr/bin/kube-apiserver
-rwxr-xr-x 1 root root 138876075 Dec 28 13:34 /usr/bin/kube-controller-manager
-rwxr-xr-x 1 root root  68354770 Dec 28 13:34 /usr/bin/kubectl
-rwxr-xr-x 1 root root  62517228 Dec 28 13:34 /usr/bin/kube-scheduler
 2.配置和启动kube-apiserver
2.1 创建apiserver的systemd unit文件
注：
这一步建议vim编辑，我用eof方式写入时，发现vim将变量内容当成变量读取，结果为空，导致丢失部分内容。
$vim /usr/lib/systemd/system/kube-apiserver.service 
[Unit]
Description=Kubernetes API Service
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=network.target
After=etcd.service
[Service]
EnvironmentFile=-/etc/kubernetes/config
EnvironmentFile=-/etc/kubernetes/apiserver
ExecStart=/usr/bin/kube-apiserver \
        $KUBE_LOGTOSTDERR \
        $KUBE_LOG_LEVEL \
        $KUBE_ETCD_SERVERS \
        $KUBE_API_ADDRESS \
        $KUBE_API_PORT \
        $KUBELET_PORT \
        $KUBE_ALLOW_PRIV \
        $KUBE_SERVICE_ADDRESSES \
        $KUBE_ADMISSION_CONTROL \
        $KUBE_API_ARGS
Restart=on-failure
Type=notify
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
2.2 配置文件: /etc/kubernetes/config
注：文档中所有配置文件中的注释，请去掉。
$cat > /etc/kubernetes/config <<eof
###
# kubernetes system config
#
# The following values are used to configure various aspects of all
# kubernetes services, including
#
#   kube-apiserver.service
#   kube-controller-manager.service
#   kube-scheduler.service
#   kubelet.service
#   kube-proxy.service
# logging to stderr means we get it in the systemd journal
KUBE_LOGTOSTDERR="--logtostderr=true"
# journal message level, 0 is debug
KUBE_LOG_LEVEL="--v=0"
# Should this cluster be allowed to run privileged docker containers
KUBE_ALLOW_PRIV="--allow-privileged=true"
# How the controller-manager, scheduler, and proxy find the apiserver
KUBE_MASTER="--master=http://192.168.7.131:8080"   #master地址
eof
2.3 配置文件: /etc/kubernetes/apiserver
注：请去掉文档中的注释部分
$cat > /etc/kubernetes/apiserver <<eof
###
## kubernetes system config
##
## The following values are used to configure the kube-apiserver
##
#
## The address on the local server to listen to.
KUBE_API_ADDRESS="--advertise-address=192.168.7.131 --bind-address=192.168.7.131 --insecure-bind-address=192.168.7.131"   # 本机地址
#
## The port on the local server to listen on.
#KUBE_API_PORT="--port=8080"
#
## Port minions listen on
#KUBELET_PORT="--kubelet-port=10250"
#
## Comma separated list of nodes in the etcd cluster
KUBE_ETCD_SERVERS="--etcd-servers=https://192.168.7.131:2379,https://192.168.7.132:2379,https://192.168.7.133:2379" #etcd集群地址
#
## Address range to use for services
KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=10.254.0.0/16"
#
## default admission control policies
KUBE_ADMISSION_CONTROL="--admission-control=ServiceAccount,NamespaceLifecycle,NamespaceExists,LimitRanger,ResourceQuota"
#
## Add your own!
KUBE_API_ARGS="--authorization-mode=Node,RBAC --runtime-config=rbac.authorization.k8s.io/v1beta1 --kubelet-https=true --enable-bootstrap-token-auth --token-auth-file=/etc/kubernetes/token.csv --service-node-port-range=30000-32767 --tls-cert-file=/etc/kubernetes/ssl/kubernetes.pem --tls-private-key-file=/etc/kubernetes/ssl/kubernetes-key.pem --client-ca-file=/etc/kubernetes/ssl/ca.pem --service-account-key-file=/etc/kubernetes/ssl/ca-key.pem --etcd-cafile=/etc/kubernetes/ssl/ca.pem --etcd-certfile=/etc/kubernetes/ssl/kubernetes.pem --etcd-keyfile=/etc/kubernetes/ssl/kubernetes-key.pem --enable-swagger-ui=true --apiserver-count=3 --audit-log-maxage=30 --audit-log-maxbackup=3 --audit-log-maxsize=100 --audit-log-path=/var/lib/audit.log --event-ttl=1h"
eof
2.4启动 kube-apiserver
systemctl daemon-reload
systemctl enable kube-apiserver
systemctl start kube-apiserver
systemctl status kube-apiserver
3.配置和启动 kube-controller-manager
3.1 配置文件：/usr/lib/systemd/system/kube-controller-manager.service  
注：
这一步建议vim编辑，我用eof方式写入时，发现vim将变量内容当成变量读取，结果为空，导致丢失部分内容。
$vim /usr/lib/systemd/system/kube-controller-manager.service 
[Unit]
Description=Kubernetes Controller Manager
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
[Service]
EnvironmentFile=-/etc/kubernetes/config
EnvironmentFile=-/etc/kubernetes/controller-manager
ExecStart=/usr/bin/kube-controller-manager \
        $KUBE_LOGTOSTDERR \
        $KUBE_LOG_LEVEL \
        $KUBE_MASTER \
        $KUBE_CONTROLLER_MANAGER_ARGS
Restart=on-failure
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
3.2 配置文件：/etc/kubernetes/controller-manager
$cat > /etc/kubernetes/controller-manager <<eof
# The following values are used to configure the kubernetes controller-manager
# defaults from config and apiserver should be adequate
# Add your own!
KUBE_CONTROLLER_MANAGER_ARGS="--address=127.0.0.1 --service-cluster-ip-range=10.254.0.0/16 --cluster-name=kubernetes --cluster-signing-cert-file=/etc/kubernetes/ssl/ca.pem --cluster-signing-key-file=/etc/kubernetes/ssl/ca-key.pem  --service-account-private-key-file=/etc/kubernetes/ssl/ca-key.pem --root-ca-file=/etc/kubernetes/ssl/ca.pem --leader-elect=true"
eof
3.3 启动 kube-controller-manager
systemctl daemon-reload
systemctl enable kube-controller-manager
systemctl start kube-controller-manager
systemctl status kube-controller-manager
4.配置和启动 kube-scheduler
4.1 配置文件：/usr/lib/systemd/system/kube-scheduler.service
注：
这一步建议vim编辑，我用eof方式写入时，发现vim将变量内容当成变量读取，结果为空，导致丢失部分内容。
$vim /usr/lib/systemd/system/kube-scheduler.service 
[Unit]
Description=Kubernetes Scheduler Plugin
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
 
[Service]
EnvironmentFile=-/etc/kubernetes/config
EnvironmentFile=-/etc/kubernetes/scheduler
ExecStart=/usr/bin/kube-scheduler \
            $KUBE_LOGTOSTDERR \
            $KUBE_LOG_LEVEL \
            $KUBE_MASTER \
            $KUBE_SCHEDULER_ARGS
Restart=on-failure
LimitNOFILE=65536
 
[Install]
WantedBy=multi-user.target
4.2 配置文件：/etc/kubernetes/scheduler
$cat > /etc/kubernetes/scheduler <<eof
###
# kubernetes scheduler config
# default config should be adequate
# Add your own!
KUBE_SCHEDULER_ARGS="--leader-elect=true --address=127.0.0.1"
eof
4.3 启动 kube-scheduler
systemctl daemon-reload
systemctl enable kube-scheduler
systemctl start kube-scheduler
systemctl status kube-scheduler
5.验证功能
master上执行：
如图说明前面的步骤都是成功的。
六.在所有节点安装flannel网络插件和docker
1.二进制包安装flannel
$cd /root/
$wget https://github.com/coreos/flannel/releases/download/v0.10.0/flannel-v0.10.0-linux-amd64.tar.gz
$tar zxvf flannel-v0.10.0-linux-amd64.tar.gz
$ll
$mkdir /usr/libexec/flannel/
$cp mk-docker-opts.sh /usr/libexec/flannel/
$cp flanneld /usr/bin
2.配置和启动fannel
2.1 配置文件 /usr/lib/systemd/system/flanneld.service
注：
这一步建议vim编辑，我用eof方式写入时，发现vim将变量内容当成变量读取，结果为空，导致丢失部分内容。
$vim /usr/lib/systemd/system/flanneld.service
[Unit]
Description=Flanneld overlay address etcd agent
After=network.target
After=network-online.target
Wants=network-online.target
After=etcd.service
Before=docker.service
[Service]
Type=notify
EnvironmentFile=/etc/sysconfig/flanneld
EnvironmentFile=-/etc/sysconfig/docker-network
ExecStart=/usr/bin/flanneld  \
  -etcd-endpoints=${FLANNEL_ETCD_ENDPOINTS} \
  -etcd-prefix=${FLANNEL_ETCD_PREFIX} \
  $FLANNEL_OPTIONS
ExecStartPost=/usr/libexec/flannel/mk-docker-opts.sh -k DOCKER_NETWORK_OPTIONS -d /run/flannel/docker
Restart=on-failure
[Install]
WantedBy=multi-user.target
RequiredBy=docker.service
2.2 配置文件 /etc/sysconfig/flanneld
注：红色内容写入etcd集群IP地址。
$cat > /etc/sysconfig/flanneld <<eof
# Flanneld configuration options  
# etcd url location.  Point this to the server where etcd runs
FLANNEL_ETCD_ENDPOINTS="https://192.168.7.131:2379,https://192.168.7.132:2379,https://192.168.7.133:2379"
# etcd config key.  This is the configuration key that flannel queries
# For address range assignment
FLANNEL_ETCD_PREFIX="/kube-centos/network"
# Any additional options that you want to pass
FLANNEL_OPTIONS="-etcd-cafile=/etc/kubernetes/ssl/ca.pem -etcd-certfile=/etc/kubernetes/ssl/kubernetes.pem -etcd-keyfile=/etc/kubernetes/ssl/kubernetes-key.pem"
eof
2.3 在etcd中创建网络配置（仅在master配置）
注：红色内容写入etcd集群IP地址。
$etcdctl --endpoints=https://192.168.7.131:2379,https://192.168.7.132:2379,https://192.168.7.133:2379 \
  --ca-file=/etc/kubernetes/ssl/ca.pem \
  --cert-file=/etc/kubernetes/ssl/kubernetes.pem \
  --key-file=/etc/kubernetes/ssl/kubernetes-key.pem \
  mkdir /kube-centos/network
 
$etcdctl --endpoints=https://192.168.7.131:2379,https://192.168.7.132:2379,https://192.168.7.133:2379  \
  --ca-file=/etc/kubernetes/ssl/ca.pem \
  --cert-file=/etc/kubernetes/ssl/kubernetes.pem \
  --key-file=/etc/kubernetes/ssl/kubernetes-key.pem \
  mk /kube-centos/network/config '{"Network":"172.18.0.0/16","SubnetLen":24,"Backend":{"Type":"vxlan"}}'
3.启动flannel
systemctl daemon-reload
systemctl enable flanneld
systemctl start flanneld
systemctl status flanneld
4.验证
注: 这时三个节点上查看ip，都能看到生成了一块flannel网卡，IP都是172.18.0.0/16地址段的。
$ip a
任意节点运行
$etcdctl --endpoints=${ETCD_ENDPOINTS} \
   --ca-file=/etc/kubernetes/ssl/ca.pem \
   --cert-file=/etc/kubernetes/ssl/kubernetes.pem \
   --key-file=/etc/kubernetes/ssl/kubernetes-key.pem \
   ls /kube-centos/network/subnets
$etcdctl --endpoints=${ETCD_ENDPOINTS} \
   --ca-file=/etc/kubernetes/ssl/ca.pem \
   --cert-file=/etc/kubernetes/ssl/kubernetes.pem \
   --key-file=/etc/kubernetes/ssl/kubernetes-key.pem \
   get /kube-centos/network/config
5.安装docker
5.1.上传docker文件夹到三个节点上
注：这里离线部署的，可以yum部署建议版本18或者19开头的。
$cd /root/
$上传docker文件夹，用winscp工具上传的。
$tar zcvf docker.tar.gz docker/
$scp docker.tar.gz root@192.168.7.132:/root
$scp docker.tar.gz root@192.168.7.133:/root
5.2.安装
#/etc/yum.repos.d/CentOS-Base.repo 需要有，部分离线包需要更新。
$cd /root/docker/
$yum -y localinstall lvm2/*.rpm container-selinux/*.rpm device-mapper-persistent-data/*.rpm
$yum -y localinstall docker-ce-cli/*.rpm
5.3.查看版本
docker --version
6. 配置文件 /usr/lib/systemd/system/docker.service
$cd /root/
$vim /usr/lib/systemd/system/docker.service
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service
Wants=network-online.target
[Service]
Type=notify
EnvironmentFile=-/run/flannel/docker
ExecStart=/usr/bin/dockerd  --exec-opt native.cgroupdriver=systemd \
                             $OPTIONS \
                             $DOCKER_STORAGE_OPTIONS \
                             $DOCKER_NETWORK_OPTIONS \
                             $ADD_REGISTRY \
                             $BLOCK_REGISTRY \
                             $REGISTRIES
ExecReload=/bin/kill -s HUP $MAINPID
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
TimeoutStartSec=0
Delegate=yes
KillMode=process
Restart=on-failure
StartLimitBurst=3
StartLimitInterval=60s
[Install]
WantedBy=multi-user.target
7.启动docker：
systemctl daemon-reload
systemctl enable docker
systemctl start docker
systemctl status docker
8.验证docker
所有节点都生成了一块docker0网卡，且地址与flannel同网段。
七.node节点安装kubelet、kube-proxy
1. 给kubelet赋予权限（仅在master执行）
$cd /etc/kubernetes
$kubectl create clusterrolebinding kubelet-bootstrap \
  --clusterrole=system:node-bootstrapper \
  --user=kubelet-bootstrap
2.确认两个节点kubelet和kube-proxy二进制文件存在
$ll /usr/bin/kube*
-rwxr-xr-x 1 root root 148146512 Dec 28 13:34 /usr/bin/kubelet
-rwxr-xr-x 1 root root  64388925 Dec 28 13:34 /usr/bin/kube-proxy
3.配置/usr/lib/systemd/system/kubelet.service
$mkdir /var/lib/kubelet #两个节点分别创建工作目录
注：下面红色内容写入本机地址。
node132：
$vim /usr/lib/systemd/system/kubelet.service
[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=docker.service
Requires=docker.service
[Service]
WorkingDirectory=/var/lib/kubelet
ExecStart=/usr/bin/kubelet \
--address=192.168.7.132 \
--hostname-override=192.168.7.132 \
--pod-infra-container-image=docker.io/kubernetes/pause \
--experimental-bootstrap-kubeconfig=/etc/kubernetes/bootstrap.kubeconfig \
--kubeconfig=/etc/kubernetes/ssl/kubelet.kubeconfig \
--cert-dir=/etc/kubernetes/ssl \
--hairpin-mode promiscuous-bridge \
--allow-privileged=true \
--serialize-image-pulls=false \
--logtostderr=true \
--cgroup-driver=systemd \
--cluster_dns=10.254.10.20 \
--cluster_domain=cluster.local \
--v=2
Restart=on-failure
RestartSec=5
[Install]
WantedBy=multi-user.target
node133：
$vim /usr/lib/systemd/system/kubelet.service
[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=docker.service
Requires=docker.service
[Service]
WorkingDirectory=/var/lib/kubelet
ExecStart=/usr/bin/kubelet \
--address=192.168.7.133 \
--hostname-override=192.168.7.133 \
--pod-infra-container-image=docker.io/kubernetes/pause \
--experimental-bootstrap-kubeconfig=/etc/kubernetes/bootstrap.kubeconfig \
--kubeconfig=/etc/kubernetes/ssl/kubelet.kubeconfig \
--cert-dir=/etc/kubernetes/ssl \
--hairpin-mode promiscuous-bridge \
--allow-privileged=true \
--serialize-image-pulls=false \
--logtostderr=true \
--cgroup-driver=systemd \
--cluster_dns=10.254.10.20 \
--cluster_domain=cluster.local \
--v=2
Restart=on-failure
RestartSec=5
[Install]
WantedBy=multi-user.target
4.启动kublet
systemctl daemon-reload
systemctl enable kubelet
systemctl start kubelet
systemctl status kubelet
5.通过 kublet 的 TLS 证书请求 （仅在master执行）
kubelet 首次启动时向 kube-apiserver 发送证书签名请求，必须通过后 kubernetes 系统才会将该 Node 加入到集群。
1、查看未授权的请求：
$kubectl get csr
2、通过csr请求：
$kubectl get csr | awk '/Pending/ {print $1}' | xargs kubectl certificate approve
$kubectl get csr
6.配置kube-proxy
安装conntrack
$yum install -y conntrack-tools
7.配置 /usr/lib/systemd/system/kube-proxy.service
红色内容写入本机地址
node132:
vim  /usr/lib/systemd/system/kube-proxy.service
[Unit]
Description=Kubernetes Kube-Proxy Server
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=network.target
[Service]
EnvironmentFile=-/etc/kubernetes/config
EnvironmentFile=-/etc/kubernetes/proxy
ExecStart=/usr/bin/kube-proxy \
       --bind-address=192.168.7.132 \
         --hostname-override=192.168.7.132 \
         --kubeconfig=/etc/kubernetes/kube-proxy.kubeconfig \
         --cluster-cidr=10.254.0.0/16
Restart=on-failure
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
node133：
vim  /usr/lib/systemd/system/kube-proxy.service
[Unit]
Description=Kubernetes Kube-Proxy Server
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=network.target
[Service]
EnvironmentFile=-/etc/kubernetes/config
EnvironmentFile=-/etc/kubernetes/proxy
ExecStart=/usr/bin/kube-proxy \
       --bind-address=192.168.7.133 \
         --hostname-override=192.168.7.133 \
         --kubeconfig=/etc/kubernetes/kube-proxy.kubeconfig \
         --cluster-cidr=10.254.0.0/16
Restart=on-failure
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
8.启动kube-proxy
systemctl daemon-reload
systemctl enable kube-proxy
systemctl start kube-proxy
systemctl status kube-proxy
9.masters上获取节点
$kubectl get nodes    #看到节点都是ready状态。
八. master上创建仓库
1.拉取仓库的镜像，并创建仓库
docker pull registry
docker run -d -p 5000:5000 --restart=always --name=registry -v /opt/myregistry:/var/lib/registry registry
2.上传本地镜像并导入。
ll /root/
docker load -i coredns.tar.gz  
docker load -i dash.tar.gz  
docker load -i heap.tar.gz  
docker load -i puase.tar.gz 
3.打tag
docker images
docker tag coredns/coredns:1.2.0 192.168.7.131:5000/coredns:v1.2
docker tag registry:5000/kubernetes-dashboard-amd64:v1.8.3 192.168.7.131:5000/dashboard:v1.8.3
docker tag registry:5000/google_containers/heapster-amd64:v1.5.1 192.168.7.131:5000/heapster:v1.5.1
docker tag registry:5000/pause-amd64:3.0 192.168.7.131:5000/pause:v3.0
4.删除原来导入的镜像
docker images
docker rmi  coredns/coredns:1.2.0
docker rmi registry:5000/kubernetes-dashboard-amd64:v1.8.3
docker rmi registry:5000/google_containers/heapster-amd64:v1.5.1
docker rmi registry:5000/pause-amd64:3.0
5.所有节点配置镜像加速和仓库地址
$vim //etc/docker/daemon.json
$cat /etc/docker/daemon.json  
{
    "registry-mirrors": ["http://hub-mirror.c.163.com"],  #网易镜像加速器
    "insecure-registries":["192.168.7.131:5000"]     #仓库的地址
}
[root@master131 ~]# scp /etc/docker/daemon.json root@192.168.7.132:/etc/docker/  
[root@master131 ~]# scp /etc/docker/daemon.json root@192.168.7.133:/etc/docker/
$systemctl restart docker #所有节点重启docker服务
6.推送镜像到仓库和查看仓库现有的镜像
docker push 192.168.7.131:5000/pause:v3.0
docker push 192.168.7.131:5000/coredns:v1.2
docker push 192.168.7.131:5000/dashboard:v1.8.3
docker push 192.168.7.131:5000/heapster:v1.5.1
查看仓库现有镜像
curl -XGET http://192.168.7.131:5000/v2/_catalog
{"repositories":["coredns","dashboard","heapster","pause"]}
九.部署coredns
创建存放yaml文件的目录并创建yaml文件。
mkdir /root/pod
cd /root/pod
vim coredns.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: coredns
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  labels:
    kubernetes.io/bootstrapping: rbac-defaults
  name: system:coredns
rules:
- apiGroups:
  - ""
  resources:
  - endpoints
  - services
  - pods
  - namespaces
  verbs:
  - list
  - watch
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  annotations:
    rbac.authorization.kubernetes.io/autoupdate: "true"
  labels:
    kubernetes.io/bootstrapping: rbac-defaults
  name: system:coredns
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:coredns
subjects:
- kind: ServiceAccount
  name: coredns
  namespace: kube-system
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns
  namespace: kube-system
data:
  Corefile: |
    .:53 {
        errors
        health
        kubernetes cluster.local 10.254.0.0/16 {
          pods insecure
          upstream
          fallthrough in-addr.arpa ip6.arpa
        }
        prometheus :9153
        proxy . /etc/resolv.conf
        cache 30
        reload
        loadbalance
    }
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: coredns
  namespace: kube-system
  labels:
    k8s-app: kube-dns
    kubernetes.io/name: "CoreDNS"
spec:
  replicas: 1
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
  selector:
    matchLabels:
      k8s-app: kube-dns
  template:
    metadata:
      labels:
        k8s-app: kube-dns
    spec:
      serviceAccountName: coredns
      tolerations:
        - key: "CriticalAddonsOnly"
          operator: "Exists"
      containers:
      - name: coredns
        image: 192.168.7.131:5000/coredns:v1.2  #写入自己的仓库地址，或者用公网的。
        imagePullPolicy: IfNotPresent
        args: [ "-conf", "/etc/coredns/Corefile" ]
        volumeMounts:
        - name: config-volume
          mountPath: /etc/coredns
          readOnly: true
        ports:
        - containerPort: 53
          name: dns
          protocol: UDP
        - containerPort: 53
          name: dns-tcp
          protocol: TCP
        - containerPort: 9153
          name: metrics
          protocol: TCP
        securityContext:
          allowPrivilegeEscalation: false
          capabilities:
            add:
            - NET_BIND_SERVICE
            drop:
            - all
          readOnlyRootFilesystem: true
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
            scheme: HTTP
          initialDelaySeconds: 60
          timeoutSeconds: 5
          successThreshold: 1
          failureThreshold: 5
      dnsPolicy: Default
      volumes:
        - name: config-volume
          configMap:
            name: coredns
            items:
            - key: Corefile
              path: Corefile
---
apiVersion: v1
kind: Service
metadata:
  name: kube-dns
  namespace: kube-system
  annotations:
    prometheus.io/port: "9153"
    prometheus.io/scrape: "true"
  labels:
    k8s-app: kube-dns
    kubernetes.io/cluster-service: "true"
    kubernetes.io/name: "CoreDNS"
spec:
  selector:
    k8s-app: kube-dns
  clusterIP: 10.254.10.20
  ports:
  - name: dns
    port: 53
    protocol: UDP
  - name: dns-tcp
    port: 53
    protocol: TCP
$kubectl create -f coredns.yaml
$kubectl get pod -n kube-system -o wide
十.部署heapster
cd /root/pod
vim heapster.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: heapster
  namespace: kube-system
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: heapster
  namespace: kube-system
spec:
  replicas: 1
  template:
    metadata:
      labels:
        task: monitoring
        k8s-app: heapster
    spec:
      serviceAccountName: heapster
      containers:
      - name: heapster
        image: 192.168.7.131:5000/heapster:v1.5.1 #写入自己的仓库地址，或者用公网的。
        imagePullPolicy: IfNotPresent
        command:
        - /heapster
        - --source=kubernetes:http://192.168.7.131:9090 #写入自己的apiserver地址
        - --sink=influxdb:http://monitoring-influxdb.kube-system.svc:8086
---
apiVersion: v1
kind: Service
metadata:
  labels:
    task: monitoring
    # For use as a Cluster add-on (https://github.com/kubernetes/kubernetes/tree/master/cluster/addons)
    # If you are NOT using this as an addon, you should comment out this line.
    kubernetes.io/cluster-service: 'true'
    kubernetes.io/name: Heapster
  name: heapster
  namespace: kube-system
spec:
  ports:
  - port: 80
    targetPort: 8082
  selector:
    k8s-app: heapster
$kubectl create -f heapster.yaml
$kubectl get pod -n kube-system -o wide
十一.部署dashboard
cd /root/pod
vim dashboard.yaml
# ------------------- Dashboard Secret ------------------- #
apiVersion: v1
kind: Secret
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard-certs
  namespace: kube-system
type: Opaque
---
# ------------------- Dashboard Service Account ------------------- #
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard-admin
  namespace: kube-system
 
---
# ------------------- Dashboard Role & Role Binding ------------------- #
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: kubernetes-dashboard-admin
  labels:
    k8s-app: kubernetes-dashboard
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: kubernetes-dashboard-admin
  namespace: kube-system
---
kind: Deployment
apiVersion: apps/v1beta2
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kube-system
spec:
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      k8s-app: kubernetes-dashboard
  progressDeadlineSeconds: 5
  template:
    metadata:
      labels:
        k8s-app: kubernetes-dashboard
    spec:
      containers:
      - name: kubernetes-dashboard
        image: 192.168.7.131:5000/dashboard:v1.8.3  #写入自己的仓库地址，或者用公网的。
        ports:
        - containerPort: 9090
          protocol: TCP
          name: http
        args:
          #- --auto-generate-certificates
          - --heapster-host=http://heapster
          # Uncomment the following line to manually specify Kubernetes API server Host
          # If not specified, Dashboard will attempt to auto discover the API server and connect
          # to it. Uncomment only if the default does not work.
          # - --apiserver-host=http://my-address:port
        volumeMounts:
        - name: kubernetes-dashboard-certs
          mountPath: /certs
          # Create on-disk volume to store exec logs
        - mountPath: /tmp
          name: tmp-volume
        livenessProbe:
          httpGet:
            scheme: HTTP
            path: /
            port: 9090
          initialDelaySeconds: 30
          timeoutSeconds: 30
      volumes:
      - name: kubernetes-dashboard-certs
        secret:
          secretName: kubernetes-dashboard-certs
      - name: tmp-volume
        emptyDir: {}
      serviceAccountName: kubernetes-dashboard-admin
      # Comment the following tolerations if Dashboard must not be deployed on master
      tolerations:
      - key: node-role.kubernetes.io/master
        effect: NoSchedule
---
# ------------------- Dashboard Service ------------------- #
kind: Service
apiVersion: v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kube-system
spec:
  type: NodePort
  ports:
    - port: 9090
      targetPort: 9090
      nodePort: 30081
      name: ui
  selector:
    k8s-app: kubernetes-dashboard
$kubectl create -f dashboard.yaml
$kubectl get pod -n kube-system -o wide