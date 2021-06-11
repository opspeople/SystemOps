# 当系统上有许多工作进程在跑，你想要一个统一的入口来管理这些进程，包括状态检查，启动和关闭，出错时告警，及自动重启等。

Supervisor四个组件：
	1.supervidord 运行supervisor的后台服务，它用来启动和管理那些需要supervisor管理的子进程
	