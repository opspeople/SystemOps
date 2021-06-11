# python内置os模块的用法
import os
os
	目录操作
		创建目录 mkdir()
		递归目录 makedirs()

		删除目录 rmdir()
		递归删除目录 removedirs()

		重命名目录 rename(src, dst)
		递归重命名目录或文件 renames(old, new)

		获取目录
			listdir() # 返回指定的文件夹包含的文件或文件夹的名字的列表
			getcwd() 返回当前工作目录
			chdir() 改变当前工作目录到指定的路径

	文件操作
		打开一个文件 open()
		写入字符串到文件描述符fd中，返回实际写入的字符串长度 write(fd, str)
		强制将文件描述符为fd的文件写入硬盘 fsync()
		设置文件中的指针 lseek()
		从文件描述符fd中读取最多n个字符 read()
