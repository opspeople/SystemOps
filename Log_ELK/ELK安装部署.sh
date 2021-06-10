ELK简介

ELK，相信都有听说过。ELK 到底是什么呢？ “ELK”是三个开源项目的首字母缩写，这三个项目分别是：Elasticsearch、Logstash 和 Kibana。Elasticsearch 是一个搜索和分析引擎。Logstash 是服务器端数据处理管道，能够同时从多个来源采集数据，转换数据，然后将数据发送到诸如 Elasticsearch 等“存储库”中。Kibana 则可以让用户在 Elasticsearch 中使用图形和图表对数据进行可视化。

ELK的应用

elk主要被用来对日志的收集、过滤、分析以及可视化展示。省去了运维人员一台一台主机拉取查找日志的烦恼。经常使用的场景有以下几个

分布式部署项目，使用elk收集日志

微服务部署项目，收集各个服务的日志

大数据行业，可以对大数据做分析，还可以和Hadoop大数据平台整合等

ELK的安装部署

下载地址

https://www.elastic.co/cn/downloads/

安装jdk

根据官网的说明，需要安装jdk1.8以上

tar -xvf jdk-8u171-linux-x64.tar.gz
#jdk安装目录
mkdir /usr/java
mv jdk1.8.0_171 /usr/java/
配置jdk的环境变量

cat << EOF >> /etc/profile

#java
JAVA_HOME=/usr/java/jdk1.8.0_171
CLASSPATH=.:\$JAVA_HOME/jre/lib/rt.jar:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar
PATH=\$PATH:\$JAVA_HOME/bin

export JAVA_HOME CLASSPATH PATH
EOF
使环境变量生效并查看jdk版本确认java安装完成

source /etc/profile
java -version
#返回结果
java version "1.8.0_171"
Java(TM) SE Runtime Environment (build 1.8.0_171-b11)
Java HotSpot(TM) 64-Bit Server VM (build 25.171-b11, mixed mode)
安装elasticsearch

elasticsearch的安装很简单。只需要解压启动即可

tar -xvf elasticsearch-7.8.0-linux-x86_64.tar.gz
mv elasticsearch-7.8.0 /usr/local/
cd /usr/local/elasticsearch-7.8.0/bin
./elasticsearch
启动报错，根据提示elasticsearch不能使用root启动

java.lang.RuntimeException: can not run elasticsearch as root

新建用户www并将elasticsearch-7.8.0的属组修改成www,然后进入elasticsearch的bin目录启动elasticsearch

useradd www  && chown -R www:www /usr/local/elasticsearch-7.8.0 && su - www
#进入elasticsearch的bin目录再一次启动
cd /usr/local/elasticsearch-7.8.0/bin
./elasticsearch
访问elasticsearch。由于elasticsearch默认监听的内网的回环IP127.0.0.1，端口9200，所以我们在命令行下执行，会看到有返回结果如下。则表示启动正常

curl 127.0.0.1:9200
{
  "name" : "localhost.localdomain",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "5bfDviTEQXiOxXgYzephmQ",
  "version" : {
    "number" : "7.8.0",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "757314695644ea9a1dc2fecd26d1a43856725e65",
    "build_date" : "2020-06-14T19:35:50.234439Z",
    "build_snapshot" : false,
    "lucene_version" : "8.5.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
上面我们说到elasticsearch默认监听IP127.0.0.1和默认端口9200，我们可以通过修改elasticsearch的配置文件进行自定义修改

elasticsearch的主配置文件是config/elasticsearch.yml

network.host: 172.16.88.217
http.port: 9200
修改上面两个参数，再次启动elasticsearch，发现启动报错了，报错信息如下

报错一

max file descriptors [4096] for elasticsearch process is too low, increase to at least [65535]

解决办法：

此报错是说系统的文件句柄数太小了，只有4096，需要调整到65535。通过修改limits.conf文件就可以解决

修改后需要需要重新登录shell才能生效，’*’可以替换成elasticsearch的启动用户www。我这里添加的是代办所有用户都生效

vim /etc/security/limits.conf

* hard nofile 65536
* soft nofile 65536
上面两条命令，hard表示硬限制，soft表示软限制。硬限制是绝对的，系统打开的文件句柄数量不能超过这个值，软限制设置不能超过硬限制。当系统超过软限制的数量会有警告提示。通过以下命令可以查看修改结果

#查看当前用户的软限制
命令：ulimit -n  等价于 ulimit -S -n

#查看当前用户的硬限制
命令：ulimit -H -n
报错二

max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]

解决办法:

报错信息也很明确，就是内核参数vm.max_map_count的值太小了。需要修改到262144

vim /etc/sysctl.conf
#添加内容
vm.max_map_count = 262144

#使修改生效
sysctl -p
报错三

the default discovery settings are unsuitable for production use; at least one of [discovery.seed_hosts, discovery.seed_providers, cluster.initial_master_nodes] must be configured

报错原因，个人猜测是因为修改了network.host后，已不在使用默认值，[discovery.seed_hosts, discovery.seed_providers, cluster.initial_master_nodes]这些参数至少有一项得配置，修改后的elasticsearch.conf配置如下

node.name: elk
network.host: 172.16.88.217
http.port: 9200
discovery.seed_hosts: ["172.16.88.217", "127.0.0.1"]
cluster.initial_master_nodes: ["elk"]
修改后再次启动，启动成功，此时通过浏览器访问http://172.16.88.217:9200，可以正常访问了

安装kibana

kibana的安装和elasticsearch一样简单，解压后就可以直接启动,同样不能用root启动，但可以通过修改配置用root启动，否则会报错”Kibana should not be run as root. Use –allow-root to continue.”

tar zxvf kibana-7.8.0-linux-x86_64.tar.gz
mv kibana-7.8.0-linux-x86_64 /usr/local/kibana-7.8.0
chown -R www. /usr/local/kibana-7.8.0/
修改kibana的配置文件，主配置文件config/kibana.yml

下面是几个主要配置选项，具体其他配置选项可根据需求具体配置

#kibana的监听IP和端口
server.port: 5601
server.host: "172.16.88.217"
#配置elasticsearch连接地址
elasticsearch.hosts: ["http://172.16.88.217:9200"]
配置完成后启动kibana

su - www
cd /usr/local/kibana-7.8.0/bin
./kibana
通过浏览器http://172.16.88.217:5601/访问，能够正常打开表示安装完成

安装logstash

logstash也是解压后就可以直接使用，不需要安装。我们只需要测试一下logstash是否能够正常工作就可以，测试logstash是否能够正常工作。执行下面这条命令，待启动后输入内容，看是否有返回结果就可以

tar zxvf logstash-7.8.0.tar.gz
mv logstash-7.8.0 /usr/local && cd /usr/local/logstash-7.8.0
bin/logstash -e 'input { stdin { } } output { stdout {} }'
#输入测试内容
dfdfdf
#以下是返回结果
{
          "host" => "localhost.localdomain",
       "message" => "dfdfdf",
      "@version" => "1",
    "@timestamp" => 2020-07-09T07:54:49.183Z
}