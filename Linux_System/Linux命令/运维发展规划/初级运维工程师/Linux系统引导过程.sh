操作系统的启动分为两个阶段：引导boot和启动startup
引导阶段开始于打开电源开关，结束于内核初始化完成和 systemd 进程成功运行。启动阶段接管了剩余工作，直到操作系统进入可操作状态。

引导过程：
	引导过程方式一： 系统从关机状态打开电源开启引导
	引导过程方式二： 系统从开机状态进行重启开启引导


BISO上电自检（POST）
	上电自检过程中其实 Linux 什么也没做，上电自检主要由硬件的部分来完成，这对于所有操作系统都一样。
	当电脑接通电源，电脑开始执行 BIOS（基本输入输出系统Basic I/O System）的 POST（上电自检Power On Self Test）过程。

	在 1981 年，IBM 设计的第一台个人电脑中，BIOS 被设计为用来初始化硬件组件。POST 作为 BIOS 的组成部分，用于检验电脑硬件基本功能是否正常。
	如果 POST 失败，那么这个电脑就不能使用，引导过程也将就此中断。




	https://blog.csdn.net/dddxxy/article/details/99692196

