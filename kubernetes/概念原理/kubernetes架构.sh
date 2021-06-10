kubernetes最初源于谷歌内部的Borg，提供了面向应用的容器集群部署和管理系统。

Borg简介
Borg是谷歌内部的大规模集群管理系统，负责对谷歌内部很多核心服务的调度和管理。
Borg组件：
	BorgMaster 集群大脑，维护整个集群状态，并将数据持久化到Paxos存储中
	Borglet	任务调度
	borgcfg 真正运行任务(在容器中)
	Scheduler Borg的命令行工具


kubernetes架构及组件
	etcd 保存整个集群的状态
	apiserver 资源操作的唯一入口、并提供认证、授权、访问控制、API注册和发现等机制
	controller manager 维护集群的状态，故障检测、自动扩展、滚动更新等
	scheduler 资源调度，按照预定的调度策略将Pod调度到相应的机器上
	kubelet 维护容器的生命周期，同时也负责Volume(CVI)和(CNI)网络的管理
	container runntime 镜像管理以及Pod和容器的真正运行(CRI)
	kube-proxy 为Service提供cluster内部的服务发现和负载均衡
	kube-dns 为整个集群提供DNS服务
	Ingress Controller 为服务提供外网入口
	Heapster 提供资源监控
	Dashboard 提供GUI
	Federation 提供跨可用区的集群


kubernetes的核心技术概念和API对象
	API对象是kubernetes集群中的管理操作单元
	每个API对象都有3大类属性：
		元数据 metadata
		规范 spec
		状态 status

对象 Objects
