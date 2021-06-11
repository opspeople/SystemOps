#!/bin/bash

# 文件和目录列表
ls
	-F 区分文件和目录，目录后带/，文件后不带/
	-a 查看目录下所有文件
	-R 递归显示当前目录及子目录下所有目录及文件
	-l 显示长列表，同 ll
	-i 查看inode信息
		drwxr-xr-x 1 yujian yujian 4096 Apr  8 10:50 yujian/
		# 分别对应：
		文件类型 d 目录；- 文件；c 字符型文件；b块设备文件
		文件的权限
		文件的硬链接总数
		文件属主的用户名
		文件属组的组名
		文件大小，以字节为单位
		文件的上次修改时间
		文件名或目录名
# 创建文件
touch
	touch filename
# 文件权限管理
	Linux文件类型
		- 普通文件
		d 目录文件
		c 字符设备文件
		b 块设备文件
		s 套接字文件
		p 管道文件
		l 链接文件
	# ll命令输出结果
	-rw-r--r-- 1 root root 155 4月   7 16:12 read_var.sh
	# 设置文件属主和属组
		chown [-R] 用户名称:组名称 文件或目录 
	# 设置文件访问权限
		chmod [who] [+|-|=] [mode]  文件名
			who
				u 
				g 
				o 
				a
			mode
				r 
				w 
				x 
				或者组合

# 文件属性管理
# 文件的隐藏属性
	chattr 设置文件的隐藏权限
		-i 无法对文件或目录进行修改
		-a 仅允许补充（追加）内容，无法覆盖/删除内容
		-S 文件内容咋变更后自己同步到磁盘
		-s 彻底从硬盘中删除，不可恢复
		-A 不再修改这个文件或目录的最后访问时间（atime）
		-b 不再修改文件或目录的存取时间
		-D 检查压缩文件中的错误
		-d 使用dump命令备份时忽略本文件/目录
		-c 默认将文件或目录进行压缩
		-u 当删除该文件后依然保留其在硬盘中的数据，方便日后恢复
		-t 让文件系统支持尾部合并
		-x 可以直接访问压缩文件中的内容
	lsattr 显示文件的隐藏权限
	

# 复制文件
cp oldfile newfile
	-i 强制shell询问是否需要覆盖已有文件
	-R,-r 递归赋值整个目录
	-f,--force 强制覆盖，不询问
# 链接文件
	符号链接
		ln -s sourcefile linkfile
	硬链接
		ln sourcdfile linkfile
# 重命名文件
	mv oldfile newfile
# 删除文件
rm 
	-i 交互式删除
	-f 强制直接删除，不询问
# 创建目录
mkdir
	mkdir newdir
	-p 创建多个目录及子目录
	-v 显示创建过程
# 删除目录
rmdir
	rmdir dirname 目录为空可以删除
rm 
	-r 递归删除目录及文件
	-f 强制删除不提示
	-i 交互式删除
# 查看文件内容
file filename 查看文件属性
cat 查看整个文件
	-n 在每行前面添加行号
more
less
tail -n 10 filename 文件最后10行
head -n 10 filename 文件开头10行

# 文件内容排序
sort
	-n 按数值大小排序
	-M sort能识别3字符的月份名，进行排序
	-b --ignore-leading-blanks 排序时忽略起始的空白
	-C --check=quiet 			不排序，如果数据无须也不要报告
	-c --check 					不排序，但检查输入数据是不是已排序，未排序的话，报告
	-d --directory-order 		仅考虑空白和字母，不考虑特殊字符
	-f --ignore-case 			默认会将大写字母排前面，这个参数忽略大小写
	-g --general-number-sort	按通用数值来排序
	-i --ignore-nonprinting		排序时忽略不可打印字符
	-k --key=POS1[,POS2]		排序从POS1位置开始，如果指定了POS2的话，到POS2位置结束
	-M --month-sort				用三字符月份名称按月份排序
	-m --merge 					将两个已排序的数据文件合并
	-o --output-file			将排序结果写到指定的文件中
	-r --reverse 				倒叙排序
	-S --buffer-size=SIZE 		指定使用的内存大小
	-T --temporary-directory=DIR 指定一个位置来存储零时工作文件
	-t --field-separator=SEP    指定一个用来区分键位置的字符

sort -t':' -k3 -n /etc/passwd

# 文件查找
grep
	-v 反向搜索，输出不匹配该模式的行
	-n 显示匹配的行的行号
	-c 统计有多少行匹配模式

# 文件压缩
gzip 压缩文件
gunzip 解压文件
zcat 查看压缩文件

# 文件归档
tar 

# 按指定大小和个数的数据块来赋值文件或转换文件
dd if=/dev/zero of=560_file count=1 bs=560M
 	if 输入的文件名称
 	of 输出的文件名称
 	count 设置要复制的块的个数
 	bs 	设置每个块的大小



# Linux文件系统管理
# 文件系统发展史
	ext文件系统，扩展文件系统（extended filesystem），为linux提供了一个基本的类Unix文件系统：使用虚拟目录来操作硬件设备，在物理设备上按定长的块来存储数据
	Linux下常见的有MS-DOS
	Windows下的FAT系列（FAT16和FAT32）和NTFS文件系统
	光盘文件系统ISO-9660
	单一文件系统 EXT32
	日志文件系统EXT3、EXT4、XFS
	集群文件系统GFS（Red Hat Global File System）
	分布式文件系统HDFS
	虚拟文件系统/proc
	网络文件系统NFS
	# 读操作频繁同时小文件众多的应用，从性能上考虑，EXT4是不错的选择；从性能和安全性方面综合考虑，XFS是比较好的选择
	# 对文件进行大量的创建和删除，EXT4文件系统更高效，依次是XFS、EXT3
	# 写操作频繁的应用，应用本身有大量的日志写操作，XFS是不错的选择，性能上XFS、EXT4、EXT3差不多，但XFS效率更高（CPU利用率最好）