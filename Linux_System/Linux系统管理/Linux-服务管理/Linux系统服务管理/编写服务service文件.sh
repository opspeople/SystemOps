目标：
	1.编写Systemd服务文件
	2.SysV init脚本到Systemd Services文件的转换

# 001.什么是Systemd service？
一种以.service结尾的单元[unit]配置文件，用于控制由systemd控制或监视的进程。
简单说，用于后台以守护进程(daemon)的形式运行程序。

# 002.编写Systemd service
# 基本结构
	控制单元[unit]的定义
	服务[service]的定义
	安装部分

# 和SysV init脚本的差异
过去，*nix 服务（守护精灵）都是用 SysV 启动脚本启动的。
SysV 启动脚本就是 Bash 脚本，通常在 /etc/init.d 目录下，
可以被一些标准参数如 start，stop，restart 等调用。
启动该脚本通常意味着启动一个后台守护精灵（daemon）。
shell 脚本常见的缺点就是，慢、可读性不强、太详细又很傲娇。
虽然它们很灵活（毕竟那就是代码呀），但是有些事只用脚本做还是显得太困难了，
比如安排并列执行、正确监视进程，或者配置详细执行环境。

SysV 启动脚本还有一个硬伤就是，臃肿，重复代码太多。
因为上述的“标准参数”必须要靠各个脚本来实现，而且各个脚本之间的实现都差不多（根本就是从一个 skeleton 骨架来的）。

而 Systemd 则进行了统一实现，也就是说在 Systemd service 中完全就不需要、也看不到这部分内容。
这使得 Systemd 服务非常简明易读，例如 NetworkManager 这一重量级程序的服务，算上注释一共才有 19 行。
而它相应的 SysV 启动脚本头 100 行连标准参数都没实现完。

Systemd 兼容 Sysv 启动脚本，这也是为什么这么久我们仍然需要一个 systemd-sysvinit 软件包的原因。
但是根据以上理由，最好针对所有您安装的守护精灵都使用原生 Systemd 服务来启动。
另外，Systemd 服务可无缝用于所有使用 Systemd 的发行版，意思是 Arch 下编写的脚本拿过来依然能够使用。

# 003.Systemd语法
主要格式说明：
	Systemd单元文件中以"#"开头的行后面的内容会被认为是注释
	Systemd下的布尔值：
		1、yes、on、true都是开启
		0、no、off、false都是关闭
	Systemd下的时间单位默认是秒，所以要用毫秒（ms）分钟（m）进行显式说明


定义控制单元
[Unit]
Description=Daemon to start He.net IPv6 # 定义一条描述

# Systemd控制各个单元之间的关系
Requires 这个单元启动了，那么它“需要”的单元也会被启动；它"需要"的单元停止了，它自己也活不了
RequiresOverridable 跟Requires很像。但是如果这条服务是由用户手动启动的，那么RequiresOverridable后面的服务及时启动不成功也不报错
Requisite 强势版本的Requires。要是这里需要的服务启动不成功，那本单元不管能不能监测等不能等待都立刻就会失败
Wants 推荐使用。本单元启动了，它"想要"的单元也会被启动，但是启动不成功，对本单元没有影响
Conflicts 一个单元的启动会停止与"它"冲突的单元。反之亦然
OnFailure 如果本单元启动失败了，那么启动什么单元作为折衷

Wants=network-online.target

# 定义服务启动顺序
Before/After 
After=network.target

定义服务本体[service]
[Service]
Type=simple # 定义服务类型
# 服务类型
simple # 简单服务类型。启动的程序就是程序的主体程序，这个程序退出那么一切皆休。
forking # 标准Unix Daemon使用的启动方式。启动程序后悔调用fork()函数，把必要的通信频道都设置好之后父进程退出，留下守护精灵的子进程。
		# 使用此方式，需要指定PIDFILE=，不要等systemd去猜，非要猜也可以，把GuessMainPID设为yes

# 判断是forking还是simple类型：
	# 命令行运行下程序，持续占用命令行要按Ctrl + C 才可以的，就不是forking类型

# 创建PIDFILE是你为它写服务的程序的任务而不是systemd的功能，
# 如果你的程序确实是forking类型，但就是没实现创建PIDFILE的功能，那么建议使用ExecStartPost= 结合shell命令来手动抓取进程编号并写到/var/run/xxx.pid
onshort # 这种服务类型就是启动，完成，没进程了。如常见的设置网络
dbus 	# 这个程序启动时需要获取一块DBus空间，所以需要和BusName= 一起用。只有它成功获得了DBus空间，依赖它的程序才会被启动

notify	# 这个程序在启动完成后会通过sd_notify发送一个通知消息。
		# 需要配置NotifyAccess来让Systemd接收消息
		# 三个级别：
			# none 所有消息都忽略掉
			# main 只接受我们程序的主进程发过去的消息
			# all 我们程序的所有进程发过去的消息都算
			# 默认是main

idle	# 这个程序要等它里面调度的全部其他东西都跑完才会跑他自己
EnvironmentFile=/etc/xxx/xxx.conf # 配置文件内容为key=value的格式

RemainAfterExit=yes # 表示进程退出以后，服务任然保持执行


# ExecStart
ExecStart  # 如果你的服务类型不是oneshort，那么它只可以接受一个命令，参数不限
			# 如果有多条命令（onshort类型），命令质检以分号；分割，跨行可用反斜杠/
			# 除非你的服务类型是forking，否则你再这里输入的命令都会被认为是主进程，不管它是不是

ExecStop
ExecReload
ExecStartPre
ExecStartPost
ExecStopPost

# 重启行为
killMode=process # 将killMode设置为process表示只停止主进程，不停止任何子进程
					# control-group(默认值)，当前控制组里面的所有子进程，都会被杀掉
					# mixed 主进程将收到SIGTERM信号，子进程收到SIGKILL信号
					# none 没有进程会被杀掉，只是执行服务的stop命令

ExecRestart=on-failure # 任何意外的失败，将重启sshd，如果服务正常停止，如systemctl stop 将不会重启服务
						# no 退出后不会重启
						# on-success 只有正常退出时，才会重启
						# on-failure 非正常退出，包括被信号终止和超时，才会重启
						# on-abnormal 只有被信号终止和超时，才会重启
						# on-abort 只有在收到没有捕捉到的信号终止时，才会重启
						# on-watchdog 超时退出，才会重启
						# always 不管什么退出原因，总是重启
						

# 004.安装服务
[Install]
# 指的是一种内部状态，默认你放对位置它显示的是disabled,unloaded
# 所以我们要在systemd内部对它进行一下load
WantedBy=multi-user.target
Alias=别名 # systemctl command xxx.service 或者 systemctl command 别名
Also=安装服务的时候还要安装别的什么服务