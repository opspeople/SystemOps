主机 host
	你想要监控的联网设备，有IP/DNS

主机组 host group
	主机的逻辑组；可能包含主机和模板。一个主机组里的主机和模板之间并没有任何直接的关联。
	通常在给不同用户组的主机分配权限时候使用主机组。

监控项 item
	你想要从主机接收的特定数据，一个度量（metrics）/指标数据

值预处理 value preprocessing
	存入数据库之前，转化/预处理接收到的指标数据

触发器 trigger
	触发器是一个逻辑表达式，用来定义问题阈值和“评估”监控项接收到的数据
	当接收到的数据高于阈值时，触发器从“OK”变成“Problem”状态。
	当接收到的数据低于阈值时，触发器保留/返回“OK”的状态。

事件 event
	发生的需要注意的事件，例如触发器状态改变、自动发现/监控代理自动注册

事件标签 event tag
	提前设置的事件标记，可以用于事件关联，权限细化设置等。

事件关联 event correlation
	自动灵活的、精确的关联问题和解决方案

异常状态更新 problem update
	Zabbix提供的异常管理选项，例如添加评论、确认异常、改变严重级别或者手动关闭等。

动作 escalation
	用户自定义的一个在动作（action）内执行操作的场景; 发送通知/执行远程命令的序列。

媒介 media
	发送告警通知的方式、途径

告警通知 notification
	通过预先设定好的媒介途径发送事件信息给用户。

远程命令 remote command
	预定义好的，满足特定条件的情况下，可以在被监控主机上自动执行的命令。

模板 template
	被应用到一个或多个主机上的一整套实体组合（如监控项，触发器，图形，聚合图形，应用，LLD，Web场景等）。
	模版的应用使得主机上的监控任务部署快捷方便；也可以使监控任务的批量修改更加简单。模版是直接关联到每台单独的主机上。

应用 application
	控项的逻辑分组

web场景 web scenario
	检查网站可浏览性的一个或多个HTTP请求

前端 fromtend
	Zabbix提供的web界面

仪表板 dashboard
	自定义的web前端模块中，用于重要的概要和可视化信息展示的单元， 我们称之为组件（widget）。

组件 widget
	Dashboard中用来展示某种信息和数据的可视化组件（概览、map、图表、时钟等）。

zabbix API 
	Zabbix API允许用户使用JSON RPC协议来创建、更新和获取Zabbix对象（如主机、监控项、图表等）信息或者执行任何其他的自定义的任务

zabbix server
	Zabbix软件的核心进程，执行监控操作，与Zabbix proxies和Agents进行交互、触发器计算、发送告警通知；也是数据的中央存储库

zabbix agent
	部署在监控对象上的进程，能够主动监控本地资源和应用

zabbix proxy
	 代替Zabbix Server采集数据，从而分担Zabbix Server负载的进程

加密 encryption
	使用TLS（Transport Layer Security ）协议支持Zabbix组建之间的加密通讯(server, proxy, agent, zabbix_sender 和 zabbix_get工具)

网络自动发现 network discovery
	网络设备的自动发现

低级别自动发现 low-level discovery
	特定设备上低级别实体的自动发现（如文件系统、网络接口等）。

低级别自动发现规则 low-level discovery rule
	为自动发现设备中低级别实体设定的一系列规则。

监控项原型 item prototype
	有特定变量的指标，用于自动发现。. 低级别自动发现执行之后，该变量将被实际自动发现的参数替换，该指标也自动开始采集数据。

触发器原型 trigger prototype
	有特定参数作为变量的触发器，用于自动发现。自动发现执行后该变量将被实际自动发现的参数替换，该触发器自动开始计算数据。
	还有其他的一些Zabbix 实体原型也被用于自动发现中——图表原型，主机原型，主机组原型，应用原型。

agent自动注册 agent auto-registration
	Zabbix agent自己自动注册为一个主机，并且开始监控的自动执行进程。