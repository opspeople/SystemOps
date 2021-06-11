#!/bin/bash
# 进程
	进程是在自身的虚拟地址空间运行的一个独立的程序

# 进程分类
	系统进程
		可以执行内存资源分配和进程切换等管理工作，而且该进程的运行不收用户的干预，即使是root用户也不能干预系统进程的运行
	用户进程
		通过执行用户程序、应用程序或内核之外的系统程序而产生的进程，此类进程可以在用户的控制下运行或关闭
	# 用户进程分类
		交互进程
			shell终端，运行于前台或后台的进程
		批处理进程
			进程合集，负责按顺序启动其他的进程
		守护进程
			一直运行的一种进程，经常在Linux系统启动时启动，在系统关闭时终止
# 子进程和父进程
	进程ID是进程的唯一标识
	进程ID最大值 32768
	所有进程都是PID为1的进程的后代
# 监测程序 ps
	ps 支持3中不同类型的命令行参数
		Unix风格的参数，前面加单破折号
			-A 显示所有进程
			-N 显示与指定参数不符的所有进程
			-a 显示除控制进程和无终端进程外的所有进程
			-d 显示除控制进程外的所有进程
			-e 显示所有进程
			-c cmdlist 显示包含在cmdlist列表中的进程
			-G grplist 显示组ID在grplist列表中的进程
			-U userlist 显示属主的用户ID在userlist列表中的进程
			-g grplist 显示会话或组ID在grplist列表中的进程
			-p pidlist 显示PID在pidlist列表中的进程
			-s sesslist 显示会话ID在sesslist列表中的进程
			-t ttylist 显示终端ID在ttylist列表中的进程
			-u userlist 显示有效用户ID在userlist列表中的进程
			-F 显示更多额外输出
			-O format 显示默认的输出列以及format列表指定的特定列
			-M 显示进程的安全信息
			-c 显示进程的额外调度器信息
			-f 显示完整格式的输出
			-j 显示任务信息
			-l 显示长列表
			-o format 仅显示由format指定的列
			-y 不显示进程标记
			-L 显示进程中的线程
			ps -ef 命令结果分析
			UID 启动这些进程的用户
			PID 进程ID
			PPID 父进程ID
			C 进程生命周期中的CPU利用率
			STIME 进程启动时的系统时间
			TTY 进程启动时的终端设备
			TIME 运行进程需要的累计CPU时间
			CMD 启动的程序名称
			ps -l 长列表解释
				F 内核分配给进程的系统标记
				S 进程的状态， O正在运行；S休眠；R可运行，正等待运行；Z僵尸进程，进程已结束但父进程已不存在；T停止
				PRI 进程的优先级，数字越大优先级越低
				NI 谦让度值用来参与决定优先级
				ADDR 进程的内存地址
				SZ 加入进程被换出，所需交换空间的大致大小
				WCHAN 进程休眠的内核函数的地址
		BSD风格的参数，前面不加破折号
		GNU风格的长参数，前面加双破折号
# 实时监测进程
top
Tasks:  99 total,   2 running,  97 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st

KiB Mem :  1863224 total,  1625324 free,    91232 used,   146668 buff/cache
KiB Swap:  2097148 total,  2097148 free,        0 used.  1607580 avail Mem

   PID USER      PR  NI    VIRT    RES    SHR S %CPU %MEM     TIME+ COMMAND

   PID 
   USER      
   PR 进程的优先级
   NI 进程谦让度值  
   VIRT 进程占用虚拟内存总量   
   RES  进程占用物理内存总量   
   SHR 进程和其他进程共享的内存总量
   S   进程状态 
   %CPU 
   %MEM     
   TIME+ 
   COMMAND
# lsof监控系统进程与程序
	lsof 列举系统中已经被打开的文件，通过lsof可以根据文件找到对应的进程信息，也可以根据进程信息扎到打开的文件
	# 用法详解
		lsof filename 	显示使用filename文件的进程
		lsof -c nfs 	显示进程nfs现在打开的文件
		lsof -g gid 	显示指定的进程组打开的文件情况
		lsof -p PID 	显示进程号为PID的进程打开的文件及相关进程
		lsof -i [46] [protocol] [@hostname][:service|port]
			lsof -i tcp:22

# pgrep 查询进程ID
	pgrep 参数选项 command 
		-l 列出程序名和进程ID值
		-o 用来显示进程起始的ID值
		-n 用来显示进程终止的ID值
		-f 可以匹配command中的关键字，即为字符串匹配
		-G 可以匹配指定组启动的进程对应的ID值
		
# 结束进程
kill
	Linux进程信号
		1 HUP 挂起
		2 INT 中断
		3 QUIT 结束运行
		9 kill 无条件终止
		11 SEGV 段错误
		15 TERM 尽可能终止
		17 STOP 无条件停止运行，但不终止
		18 TSTP 停止或暂停，但继续在后台运行
		19 CONT 在STOP或TSTP之后恢复执行
	kill -s HUP PID
killall 进程名 通过进程名而不是PID来结束进程，支持通配符

# 后台进程
commands &

# 计划任务
	一次计划任务
		at 23:00 systemctl restart httpd
		at -l 查看
		atrm 任务id # 删除任务
		
	长期性计划任务
		crontab -e
		crontab -l
