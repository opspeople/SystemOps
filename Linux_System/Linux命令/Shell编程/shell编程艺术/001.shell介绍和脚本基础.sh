1.登录系统
	Ctrl+Alt+F1 进入字符终端界面
	Ctrl+Alt+F7 进入图形终端界面

2.linux系统共有6个字符终端也一个图形终端，分别为tty1~tty7

3.bash启动简介
	当用户登录到系统中时，login程序会根据/etc/passwd文件中最后一个字段来运行指定的shell
	此时的shell处于未初始化的状态，不能正常使用
	它需要经历一个叫做初始化的过程来建立这个运行环境。
	在启动的过程中，shell程序会读取两部分的配置文件
		一部分 /etc/profile 中的全局配置文件
		一部分 用户主目录下的 .bash_profile .bash_login .profile 。
		然后根据三个文件的优先级执行三个文件中的某一个，如果前面的文件存在后面的就不会执行

4.获取帮组
	command --help
	man command
	info command

	man 手册的各section含义
		1 可执行程序或shell命令
		2 系统调用（内核提供的函数）
		3 库函数（程序库中的函数）
		4 /dev/目录下的特殊文件
		5 系统配置文件的格式和约定
		6 Games
		7 各种各样的东西
		8 系统管理命令
		9 内核例程
