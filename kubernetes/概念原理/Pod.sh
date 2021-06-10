Pod是kubernetes中创建和部署的最小也是最简单位
一个pod代表集群中运行的一个进程
pod中封装着应用的容器（有时会有好几个容器）

kubernetes集群中的pod有如下两种使用方式：
	一个pod中运行一个容器
		pod相当于单个容器的封装，kubernetes管理的是pod而不是直接管理容器
	一个pod中运行多个容器
		该pod中的多个容器互相协作成为一个service单位 一个容器共享文件
		另一个“sidecar”容器来更新这些文件。pod将这些容器的存储|资源作为一个实体来管理

pod中如何管理多个容器
	pod中可以同时运行多个进程协同工作。同一个pod中的容器会自动的分配到同一个node上。
	同一个pod中的容器共享资源、网络环境和依赖，他们被同时调度。

pod中可以共享两种资源：网络和存储
	网络
		每个pod都会被分配一个唯一的IP地址。pod中的所有容器共享网络空间，包括IP地址和端口。
		pod内部的容器可以使用localhost互相通信。pod中的容器与外界通信时，必须分配共享网络资源。
	存储
		pod中的容器都可以访问共享的volume

使用pod
	kubernetes中通常是使用Controller来管理pod的

pod和controller
	controller可以创建和管理多个pod，提供副本管理、滚动升级和集群级别的自愈能力。

pod中容器的特权模式
	pod中的容器可以开启previleged模式，在容器定义文件的SecurityContext下使用Privileged flag。
	这在使用linux的网络操作和访问设备的能力时是很用的。
	开启的特权模式的pod中的容器也可以访问到容器外的进程和应用。
	在不需要修改和重新编译kubelet的情况下就可以使用pod来开发节点的网络和存储插件

