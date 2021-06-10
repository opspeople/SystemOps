#!/bin/bash
date
选项：
	-d datestr, --date datestr # 显示由datestr描述的日期
	-s datestr, --date datestr # 设置dattestr描述的日期
	-u, --universal # 显示或设置通用时间 时间域
示例：
	date # 显示当前日期
	date -s '20210527' # 设置时间
	datestr -s '12:21:00' # 设置时分秒
	# 将设置后的系统时间同步到硬件时钟上 clock --systohc 或者 hwclock --hctosys

	显示时间格式说明
	%H 小时
	%I 小时（01..12） 
	%k 小时（0..23） 
	%l 小时（1..12） 
	%M 分（00..59) 
	%p 显示出AM或PM
	%r 时间（hh：mm：ss AM或PM），12小时 
	%s 从1970年1月1日00：00：00到目前经历的秒数 
	%S 秒（00..59） 
	%T 时间（24小时制）（hh:mm:ss）
	%X 显示时间的格式（％H:％M:％S） 
	%Z 时区 日期域 
	%a 星期几的简称（ Sun..Sat） 
　　%A 星期几的全称（ Sunday..Saturday） 
　　%b 月的简称（Jan..Dec） 
　　%B 月的全称（January..December） 
　　%c 日期和时间（ Mon Nov 8 14：12：46 CST 1999） 
　　%d 一个月的第几天（01..31） 
　　%D 日期（mm／dd／yy） 
　　%h 和%b选项相同 
　　%j 一年的第几天（001..366） 
　　%m 月（01..12） 
　　%w 一个星期的第几天（0代表星期天） 
　　%W 一年的第几个星期（00..53，星期一为第一天） 
　　%x 显示日期的格式（mm/dd/yy） 
　　%y 年的最后两个数字（ 1999则是99） 
　　%Y 年（例如：1970，1996等） 
常用日期显示：
	date +"%Y-%m-%d_%H%M%S"
