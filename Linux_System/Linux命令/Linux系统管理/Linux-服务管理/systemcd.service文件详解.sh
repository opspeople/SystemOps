#!/bin/bash

# 中文手册
http://www.jinbuguo.com/systemd/systemd.service.html

# 1.描述
以'.service'为后缀的单元文件，封装了一个被systemd监视与控制的进程

# 2.依赖关系
# 2.1 隐含依赖
设置了Type=dbus的服务会自动添加Requires=dbus.socket与After=dbus.socket依赖
基于套接字启动的服务会自动添加对关联的.socket与After=依赖，服务单元还会为所有在 Sockets= 中列出的 .socket 单元自动添加 Wants= 与 After= 依赖
# 2.2 默认依赖
除非明确设置了 DefaultDependencies=no ，否则 service 单元将会自动添加下列依赖关系：
	Requires=sysinit.target, After=sysinit.target, After=basic.target, Conflicts=shutdown.target, Before=shutdown.target 
	这样可以确保普通的服务单元： 
		(1)在基础系统启动完毕之后才开始启动，	
		(2)在关闭系统之前先被干净的停止。 
			只有那些需要在系统启动的早期就必须启动的服务， 以及那些必须在关机动作的结尾才能停止的服务才需要设置 DefaultDependencies=no 
	从同一个模版实例化出来的所有服务单元(单元名称中带有 "@" 字符)， 默认全部属于与模版同名的同一个 slice 单元
	该同名 slice 一般在系统关机时，与所有模版实例一起停止。
	如果你不希望像上面这样，那么可以在模版单元中明确设置 DefaultDependencies=no ， 
	并且：要么在该模版文件中明确定义特定的 slice 单元(同样也要明确设置 DefaultDependencies=no)、 要么在该模版文件中明确设置 Slice=system.slice (或其他合适的 slice)。

# 3.选项
Type=
	# 设置进程的启动类型，必须设置为 simple,exec,forking,oneshot,dbus,notify,idle之一
		simple 
		# 如果设置为simple(当设置了 ExecStart= 、 但是没有设置 Type= 与 BusName= 时，这是默认值),那么ExecStart=进程就是该服务的主进程，并且 systemd 会认为在创建了该服务的主服务进程之后，该服务就已经启动完成。
		# 如果此进程需要为系统中的其他进程提供服务， 那么必须在该服务启动之前先建立好通信渠道(例如套接字)， 这样，在创建主服务进程之后、执行主服务进程之前，即可启动后继单元， 从而加快了后继单元的启动速度。
		# 这就意味着对于 simple 类型的服务来说， 即使不能成功调用主服务进程(例如 User= 不存在、或者二进制可执行文件不存在)， systemctl start 也仍然会执行成功。
		exec 
		# exec 与 simple 类似，不同之处在于， 只有在该服务的主服务进程执行完成之后，systemd 才会认为该服务启动完成。 
		# 其他后继单元必须一直阻塞到这个时间点之后才能继续启动。
		# 换句话说， simple 表示当 fork() 函数返回时，即算是启动完成，而 exec 则表示仅在 fork() 与 execve() 函数都执行成功时，才算是启动完成。
		# 这就意味着对于 exec 类型的服务来说， 如果不能成功调用主服务进程(例如 User= 不存在、或者二进制可执行文件不存在)， 那么 systemctl start 将会执行失败。
		forking
		# 如果设为 forking ，那么表示 ExecStart= 进程将会在启动过程中使用 fork() 系统调用。
		# 也就是当所有通信渠道都已建好、启动亦已成功之后，父进程将会退出，而子进程将作为主服务进程继续运行。
		# 这是传统UNIX守护进程的经典做法。
		# 在这种情况下，systemd 会认为在父进程退出之后，该服务就已经启动完成。 
		#  如果使用了此种类型，那么建议同时设置 PIDFile= 选项，以帮助 systemd 准确可靠的定位该服务的主进程。 
		# systemd 将会在父进程退出之后 立即开始启动后继单元。
		oneshot
		# oneshot 与 simple 类似，不同之处在于， 只有在该服务的主服务进程退出之后，systemd 才会认为该服务启动完成，才会开始启动后继单元。
		# 此种类型的服务通常需要设置 RemainAfterExit= 选项。 当 Type= 与 ExecStart= 都没有设置时， Type=oneshot 就是默认值。
		dbus
		# dbus 与 simple 类似，不同之处在于， 该服务只有获得了 BusName= 指定的 D-Bus 名称之后，systemd 才会认为该服务启动完成，才会开始启动后继单元。
		# 设为此类型相当于隐含的依赖于 dbus.socket 单元。 当设置了 BusName= 时， 此类型就是默认值。
		notify
		# notify 与 exec 类似，不同之处在于， 该服务将会在启动完成之后通过 sd_notify(3) 之类的接口发送一个通知消息。
		# systemd 将会在启动后继单元之前， 首先确保该进程已经成功的发送了这个消息。
		# 如果设为此类型，那么下文的 NotifyAccess= 将只能设为非 none 值。
		# 如果未设置 NotifyAccess= 选项、或者已经被明确设为 none ，那么将会被自动强制修改为 main 。
		# 注意，目前 Type=notify 尚不能与 PrivateNetwork=yes 一起使用。
		idle 
		# idle 与 simple 类似，不同之处在于， 服务进程将会被延迟到所有活动任务都完成之后再执行。 
		#  这样可以避免控制台上的状态信息与shell脚本的输出混杂在一起。 注意：(1)仅可用于改善控制台输出，切勿将其用于不同单元之间的排序工具； (2)延迟最多不超过5秒， 超时后将无条件的启动服务进程。

	建议对长时间持续运行的服务尽可能使用 Type=simple (这是最简单和速度最快的选择)。
	注意，因为 simple 类型的服务 无法报告启动失败、也无法在服务完成初始化后对其他单元进行排序， 所以，当客户端需要通过仅由该服务本身创建的IPC通道(而非由 systemd 创建的套接字或 D-bus 之类)连接到该服务的时候， simple 类型并不是最佳选择。
	在这种情况下， notify 或 dbus(该服务必须提供 D-Bus 接口) 才是最佳选择， 因为这两种类型都允许服务进程精确的安排 何时算是服务启动成功、何时可以继续启动后继单元。
	notify 类型需要服务进程明确使用 sd_notify() 函数或类似的API， 否则，可以使用 forking 作为替代(它支持传统的UNIX服务启动协议)。 
	最后，如果能够确保服务进程调用成功、服务进程自身不做或只做很少的初始化工作(且不大可能初始化失败)， 那么 exec 将是最佳选择。
	注意，因为使用任何 simple 之外的类型都需要等待服务完成初始化，所以可能会减慢系统启动速度。 因此，应该尽可能避免使用 simple 之外的类型(除非必须)。
	另外，也不建议对长时间持续运行的服务使用 idle 或 oneshot 类型。

RemainAfterExit=
	# 当该服务的所有进程全部退出之后， 是否依然将此服务视为活动(active)状态。 默认值为 no
GuessMainPID=
	# 在无法明确定位 该服务主进程的情况下， systemd 是否应该猜测主进程的PID(可能不正确)。 该选项仅在设置了 Type=forking 但未设置 PIDFile= 的情况下有意义。 如果PID猜测错误， 那么该服务的失败检测与自动重启功能将失效。 默认值为 yes
PIDFile=
	# 该服务PID文件的路径(一般位于 /run/ 目录下)。
	# 强烈建议在 Type=forking 的情况下明确设置此选项。 
	# 如果设为相对路径，那么表示相对于 /run/ 目录。
	# systemd 将会在此服务启动完成之后，从此文件中读取主服务进程的PID 。
	# systemd 不会写入此文件，但会在此服务停止后删除它(若仍然存在)。
	#  PID文件的拥有者不必是特权用户， 但是如果拥有者是非特权用户，那么必须施加如下安全限制：
		# (1)不能是一个指向其他拥有者文件的软连接(无论直接还是间接)
		# (2)其中的PID必须指向一个属于该服务的进程。
BusName=
	# 设置与此服务通信 所使用的 D-Bus 名称。 在 Type=dbus 的情况下 必须明确设置此选项。
ExecStart=
	# 在启动该服务时需要执行的 命令行(命令+参数)。 
	# 除非 Type=oneshot ，否则必须且只能设置一个命令行。
	# 仅在 Type=oneshot 的情况下，才可以设置任意个命令行(包括零个)， 多个命令行既可以在同一个 ExecStart= 中设置，也可以通过设置多个 ExecStart= 来达到相同的效果。 
	# 如果设为一个空字符串，那么先前设置的所有命令行都将被清空。 如果不设置任何 ExecStart= 指令， 那么必须确保设置了 RemainAfterExit=yes 指令，并且至少设置一个 ExecStop= 指令。 
	# 同时缺少 ExecStart= 与 ExecStop= 的服务单元是非法的(也就是必须至少明确设置其中之一)。
	# 命令行必须以一个可执行文件(要么是绝对路径、要么是不含任何斜线的文件名)开始， 并且其后的那些参数将依次作为"argv[1] argv[2] …"传递给被执行的进程。 可选的，可以在绝对路径前面加上各种不同的前缀表示不同的含义：
	可执行文件前的特殊前缀：
	@
	# 如果在绝对路径前加上可选的 "@" 前缀，那么其后的那些参数将依次作为"argv[0] argv[1] argv[2] …"传递给被执行的进程(注意，argv[0] 是可执行文件本身)。
	-
	# 如果在绝对路径前加上可选的 "-" 前缀，那么即使该进程以失败状态(例如非零的返回值或者出现异常)退出，也会被视为成功退出，但同时会留下错误日志。
	+
	# 如果在绝对路径前加上可选的 "+" 前缀，那么进程将拥有完全的权限(超级用户的特权)，并且 User=, Group=, CapabilityBoundingSet= 选项所设置的权限限制以及 PrivateDevices=, PrivateTmp= 等文件系统名字空间的配置将被该命令行启动的进程忽略(但仍然对其他 ExecStart=, ExecStop= 有效)。
	!
	# 与 "+" 类似(进程仍然拥有超级用户的身份)，不同之处在于仅忽略 User=, Group=, SupplementaryGroups= 选项的设置，而例如名字空间之类的其他限制依然有效。注意，当与 DynamicUser= 一起使用时，将会在执行该命令之前先动态分配一对 user/group ，然后将身份凭证的切换操作留给进程自己去执行。
	!!
	# 与 "!" 极其相似，仅用于让利用 ambient capability 限制进程权限的单元兼容不支持 ambient capability 的系统(也就是不支持 AmbientCapabilities= 选项)。如果在不支持 ambient capability 的系统上使用此前缀，那么 SystemCallFilter= 与 CapabilityBoundingSet= 将被隐含的自动修改为允许进程自己丢弃 capability 与特权用户的身份(即使原来被配置为禁止这么做)，并且 AmbientCapabilities= 选项将会被忽略。此前缀在支持 ambient capability 的系统上完全没有任何效果。
	# "@", "-" 以及 "+"/"!"/"!!" 之一，可以按任意顺序同时混合使用。 注意，对于 "+", "!", "!!" 前缀来说，仅能单独使用三者之一，不可混合使用多个。 注意，这些前缀同样也可以用于 ExecStartPre=, ExecStartPost=, ExecReload=, ExecStop=, ExecStopPost= 这些接受命令行的选项。
	# 如果设置了多个命令行， 那么这些命令行将以其在单元文件中出现的顺序依次执行。 如果某个无 "-" 前缀的命令行执行失败， 那么剩余的命令行将不会被继续执行， 同时该单元将变为失败(failed)状态。
	# 当未设置 Type=forking 时， 这里设置的命令行所启动的进程 将被视为该服务的主守护进程。
ExecStartPre=,ExecStopPost=
	# 设置在执行 ExecStart= 之前/后执行的命令行。 语法规则与 ExecStart= 完全相同。 如果设置了多个命令行， 那么这些命令行将以其在单元文件中出现的顺序 依次执行。
	# 如果某个无 "-" 前缀的命令行执行失败， 那么剩余的命令行将不会被继续执行， 同时该单元将变为失败(failed)状态。
	# 仅在所有无 "-" 前缀的 ExecStartPre= 命令全部执行成功的前提下， 才会继续执行 ExecStart= 命令。
	# ExecStartPost= 命令仅在 ExecStart= 中的命令已经全部执行成功之后才会运行， 判断的标准基于 Type= 选项。
	# 具体说来，对于 Type=simple 或 Type=idle 就是主进程已经成功启动； 
	# 对于 Type=oneshot 来说就是最后一个 ExecStart= 进程已经成功退出； 
	# 对于 Type=forking 来说就是初始进程已经成功退出； 
	# 对于 Type=notify 来说就是已经发送了 "READY=1" ； 
	# 对于 Type=dbus 来说就是已经取得了 BusName= 中设置的总线名称。
ExecReload=
	# 这是一个可选的指令， 用于设置当该服务 被要求重新载入配置时 所执行的命令行。 语法规则与 ExecStart= 完全相同。
	# 另外，还有一个特殊的环境变量 $MAINPID 可用于表示主进程的PID， 例如可以这样使用：
		/bin/kill -HUP $MAINPID
ExecStop=
	# 这是一个可选的指令， 用于设置当该服务被要求停止时所执行的命令行。
	# 语法规则与 ExecStart= 完全相同。 执行完此处设置的所有命令行之后，该服务将被视为已经停止， 此时，该服务所有剩余的进程将会根据 KillMode= 的设置被杀死
	# 如果未设置此选项，那么当此服务被停止时， 该服务的所有进程都将会根据 KillSignal= 的设置被立即全部杀死。
	# 与 ExecReload= 一样， 也有一个特殊的环境变量 $MAINPID 可用于表示主进程的PID 。
ExecStopPost=
	# 无论服务是否启动成功， 此选项中设置的命令都会在服务停止后被无条件的执行
RestartSec=
	# 设置在重启服务(Restart=)前暂停多长时间。 默认值是100毫秒(100ms)。 如果未指定时间单位，那么将视为以秒为单位。 例如设为"20"等价于设为"20s"。
TimeoutStartSec=
	# 设置该服务允许的最大启动时长。
	# 如果守护进程未能在限定的时长内发出"启动完毕"的信号，那么该服务将被视为启动失败，并会被关闭。 如果未指定时间单位，那么将视为以秒为单位。 
TimeoutStopSec=

LimitNOFILE=