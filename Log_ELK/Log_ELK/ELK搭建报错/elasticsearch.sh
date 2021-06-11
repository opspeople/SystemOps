启动时报错：
    bin/elasticsearch
    [1]: the default discovery settings are unsuitable for production use; at least one of [discovery.seed_hosts, discovery.seed_providers, cluster.initial_master_nodes] must be configured
原因分析
    看提示可知：缺少默认配置，至少需要配置discovery.seed_hosts/discovery.seed_providers/cluster.initial_master_nodes中的一个参数.

    discovery.seed_hosts:  集群主机列表
    discovery.seed_providers: 基于配置文件配置集群主机列表
    cluster.initial_master_nodes: 启动时初始化的参与选主的node，生产环境必填

处理办法
    修改配置文件，添加参数即可
    vim config/elasticsearch.yml
    #添加配置
    discovery.seed_hosts: ["127.0.0.1"]
    
    cluster.initial_master_nodes: ["node-1"]

/etc/elasticsearch/elasticsearch.yml 
# 集群名称
cluster.name: elkb
# 节点名称
node.name: elkb-node-1
# master节点，此处单台，直接用节点名称即可
cluster.initial_master_nodes: elkb-node-1
# es的数据存储目录，默认在es_home/data目录下
path.data: /home/elkb/elasticsearch-7.6.2/data
# 日志存储目录，默认在es_home/logs目录下
path.logs: /home/elkb/elasticsearch-7.6.2/logs
# 锁定物理内存地址，防止elasticsearch内存被交换出去,也就是免es使用swap交换分区
bootstrap.memory_lock: false
bootstrap.system_call_filter: false
# 允许访问的ip地址
network.host: 0.0.0.0
# 对外端口
http.port: 9200
# 是否允许跨域
http.cors.enabled: true
http.cors.allow-origin: "*"
# 自动创建索引的设置 -是禁止自动创建，+是允许创建，多个索引以“,”号隔开
action.auto_create_index: +log*,+.watches*,+.triggered_watches,+.watcher-history-*,+.kibana*,+.monitoring*,+logstash*

############ 其他配置
vi /etc/security/limits.conf
# 添加如下设置
* soft nofile 65536
* hard nofile 131072
* soft nproc 2048
* hard nproc 4096
# centos 7 为  20-nproc.conf  centos 6 为 90-nproc.conf
vi /etc/security/limits.d/20-nproc.conf
#修改为
* soft nproc 4096
vi /etc/sysctl.conf
# 添加下面配置：
vm.max_map_count=655360
# 让内核参数生效
sysctl -p

