#!/bin/bash
# 挂载存储
mount 
	直接执行mount，查看当前系统mount列表
		命令结果显示如下四部分信息：
			媒体的设备文件名
			媒体挂载到虚拟目录的挂载点
			文件系统类型
			已挂载媒体的访问状态
	挂载格式：
		mount -t type device directory
		type:
			vfat windows长文件系统
			ntfs 高级文件系统
			iso9660 标准CD-ROM文件系统
	参数：
		-a 挂载/etc/fstab文件中指定的所有文件系统
		-f 使mount命令模拟挂载设备，但并不真的挂载
		-F 和-a参数一起使用，会同时挂载所有文件系统
		-v 详细模式，将会说明挂载设备的每一步
		-I 给ext2、ext3或XFS文件系统自动添加文件系统标签
		-n 挂载设备，但不注册到/etc/mtab已挂载设备文件中
		-r 将设备挂载为只读的
		-w 将设备挂载为可读写的，默认
		-o 给文件系统添加特定的选项
			ro 以只读
			rw 已读写
			user 允许普通用户挂载文件系统
			loop 挂载一个文件
# 卸载存储
umount [device|directory]

# 查看磁盘空间
df
	-h 把输出中磁盘空间按照用户易读的形式显示，通常用M来替代兆字节，用G来代替吉字节

# 查看某个目录的空间使用情况
du -sh

# Linux系统中的所有硬件设备都是通过文件的方式来表现和使用的，这些文件称为设备文件
	# 字符设备文件
		以字符流的方式来进行，一次传送一个字符，如打印机、终端(TTY)、绘图仪和磁带设备等
	# 块设备文件
		以数据块额方式来存取的，常见的设备就是磁盘
# 磁盘类型
	IDE并口硬盘
	SATA串口硬盘
	SCSI硬盘
# Linux下磁盘设备常用的表示方案
	主设备号+次设备号+磁盘分区编号
		对于IDE硬盘	 hd[a-z]x
		对于SCSI硬盘	 sd[a-z]x
	主设备号+[0-n],y
		对于IDE硬盘 	 hd[0-n],y
		对于SCSI硬盘  sd[0-n],y
# UEFI、BISO、MBR、GPT之间的关系
UEFI 统一的可扩展固件接口，定义了一种在操作系统和平台固件之间的接口标准，此类固件叫UEFI固件
BISO Basic Input Output System 基本输入输出系统，使用中断类执行输入/输出操作
MBR Master Boot Record 主引导记录，硬盘的主引导记录分区列表，硬盘的0柱面、0磁头、1扇区称为主引导扇区。它由3部分在组成：主引导程序（446字节）；分区表（64字节）；Magic number（2字节）
GPT 全局唯一标识分区列表

# 利用fdisk工具划分磁盘分区 磁盘空间小于2T
fdisk [-l] [-b SSZ] [-u] device
	# fdisk分为两部分 
		# 查询部分
		# 交互操作部分
			fdisk device 
	# fdisk实例讲解
		# 创建磁盘分区
# 利用parted划分磁盘分区 磁盘空间大于2T
	# 命令模式
	# 交互模式
		parted 创建分区步骤

# 创建文件系统
mkefs 		创建一个ext文件系统
mke2fs		创建一个ext2文件系统
mkfs.ext3	创建一个ext3文件系统
mkfs.ext4	创建一个ext4文件系统
mkreiserfs	创建一个ReiserFS文件系统
jfs_mkfs	创建一个JFS文件系统
mkfs.xfs 	创建一个XFS文件系统
mkfs.zfs	创建一个ZFS文件系统
mkfs.btrfs	创建一个Btrfs文件系统

# 文件系统检查与修复
fsck options filesystem
	-a 检测到错误，自动修复文件系统
	-A 检查/etc/fstab文件中列出的所有文件系统
	-C 给支持进度条功能的文件系统显示一个进度条
	-N 不进行检查，值显示哪些检查会执行
	-r 出现错误时提示
	-R 使用-A时，跳过跟文件系统
	-s 检查多个文件系统时，依次进行检查
	-t 指定要检查的文件系统类型
	-T 启东市不显示头部信息
	-y 检测到错误时自动修复文件系统

# 逻辑卷管理
# 通过将另外一个硬盘上的分区加入已有文件系统，动态地添加存储空间
# 逻辑卷管理布局
# 逻辑卷管理的世界例，硬盘分区称作物理卷，每个物理卷会被映射到硬盘上特定的物理分区
# 多个物理卷集中在一起可以形成一个卷组
# 1.定义物理卷
# 创建逻辑卷
# 扩展逻辑卷


# 磁盘容量配额
# 限制用户使用的最大磁盘空间或最多创建文件数量
quota 
	# 软限制
		达到限额后开始提醒，但仍可使用
	# 硬限制
		达到限额后提醒，但限制使用
	# 配置步骤
		# 1.安装quato软件包
		# 2.开启/boot目录支持quota
		UUID=c4849758-a25d-4b39-ae37-6f95927b66c0 /boot                   xfs     defaults,uquota        0 0
		# 重启系统，查看是否支持
		mount | grep boot
		/dev/sda1 on /boot type xfs (rw,relatime,seclabel,attr2,inode64,usrquota)
		
# RAID （Redundant Arrar of Independent Disks）,独立冗余磁盘阵列

RAID 0
	# 通过硬件或软件的方式串联在一起，组成一个大的卷组，并将数据依次写入到各个物理硬盘中
	# 优点 硬盘读写速度提升数倍
	# 缺点 任意一块磁盘发声故障导致整个系统的数据都受到破坏
	数据块1 数据块2
	数据块3 数据块4
	数据块5 数据块6
	数据块7 数据块8
	磁盘1   磁盘2 

RAID 1
	# 将数据同时写入到多块硬盘设备上，当其中某一块硬盘发声故障后，一般会立即自动以热交换的方式来恢复数据的正常使用
	数据块1 数据块1
	数据块2 数据块2
	数据块3 数据块3
	...	   ...
	磁盘1	磁盘2

RAID 5
	# 把硬盘设备的数据奇偶校验信息保存到其他硬盘设备中
	数据块1 数据块2 parity
	数据块3 parity 数据块4
	parity 数据块5 数据块6
	磁盘1   磁盘2  磁盘3

RAID 10
	# RAID 1 + RAID 0
			RAID 0
	RAID 1			RAID 1
	数据块1 数据块1 	数据块2 数据块2
	数据块3 数据块3 	数据块4 数据块4
	磁盘1	磁盘2 	磁盘3 	磁盘4

# 部署磁盘阵列
mdadm 命令用于管理Linux系统的软件RAID硬盘阵列
	格式
	mdadm [模式] <RAID设备名称> [选项] [成员设备名称]

	-a 检测设备名称
	-n 指定设备数量
	-l 指定RAID级别
	-C 创建
	-v 显示过程
	-f 模拟设备损坏
	-r 移除设备
	-Q 查看摘要信息
	-D 查看详细信息
	-S 停止RAID磁盘阵列

# 例 创建磁盘阵列 RAID 10
	mdadm -Cv /dev/md0 -a yes -n 4 -l 10 /dev/sdb /dev/sdc /dev/sdd /dev/sde

# 将制作好的磁盘阵列格式化为ext4
	mkfs.ext4 /dev/md0
# 创建挂载点，挂载设备
	mkdir /mnt/raid10
	mount /dev/md0 /mnt/raid10
	df -h 查看磁盘信息
# 查看/dev/md0磁盘阵列的详细信息
	mdadm -D /dev/md0
# 将挂载信息写入配置文件
	echo "/dev/md0 /mnt/raid10 ext4 defaults 0 0" >> /etc/fstab
# 损坏磁盘阵列
	mdadm /dev/md0 -f /dev/sdb
	mdadm -D /dev/md0 # 检查磁盘阵列
	umount /mnt/raid10 # 卸载
	mdadm /dev/md0 -a /dev/sdb
	mdadm -D /dev/md0

# 磁盘阵列 + 备份盘
	RAID 5 + 备份盘
	mdadm -Cv /dev/md0 -n 3 -l 5 -x 1 /dev/sdb /dev/sdc /dev/sdd /dev/sde
	-x 代表有一块备份盘
	mkfs.ext4 /dev/md0


# LVM 逻辑卷管理
常用命令
		 物理卷管理	卷组管理		逻辑卷管理 
	扫描 pvscan 		vgscan 		lvscan
	建立 pvcreate 	vgcreate 	lvcreate
	显示 pvdisplay 	vgdisplay 	lvdisplay
	删除 pvremove 	vgremove 	lvremove
	扩展 			vgextend 	lvextend
	缩小 			vgreduce 	lvreduce

# 添加两块设备支持LVM技术
pvcreate /dev/sdb /dev/sdc
pvdisplay
# 将两块硬盘设备加入到storage卷组中，然后查看卷组的状态
vgcreate /dev/sdb /dev/sdc
vgdisplay
# 切割出一个约为150MB的逻辑卷设备
	方法一
		lvcreate -n vo -l 37 storage
	方法二
		lvcreate -n no -L 150MB storage
	lvdisplay
# 将生成好的逻辑卷格式化
mkfs.ext4 /dev/storage/vo
# 挂载使用
mkdir /mnt/linuxprobe
mount /dev/storage/vo /mnt/linuxprobe
df -h

# 扩展逻辑卷
umount /mnt/linuxprobe
lvextend -L 290MB /dev/storage/vo
# 检查硬盘完整性，并重置硬盘容量
e2fsck -f /dev/storage/vo
resize2fs /dev/storage/vo
# 重新挂载
mount -a
df -h

# 缩小逻辑卷
umount /mnt/linuxprobe
e2fsck -f /dev/storage/vo
resize2fs /dev/storage/vo 120MB
lvreduce -L 120MB /dev/storage/vo
mount -a
df -h

# 逻辑卷快照

# 删除逻辑卷
umount /mnt/linuxprobe
vim /etc/fstab
删掉相关配置文件
lvremove /dev/storage/vo
vgremove storage
pvremove /dev/sdb /dev/sdc

