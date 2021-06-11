#!/bin/bash
daily	日志的轮替周期是毎天
weekly	日志的轮替周期是每周
monthly	日志的轮控周期是每月
rotate 数宇	保留的日志文件的个数。0指没有备份
compress	当进行日志轮替时，对旧的日志进行压缩
create mode owner group	建立新日志，同时指定新日志的权限与所有者和所属组.如create 0600 root utmp
mail address	当进行日志轮替时.输出内存通过邮件发送到指定的邮件地址
missingok	如果日志不存在，则忽略该日志的警告信息
nolifempty	如果曰志为空文件，則不进行日志轮替
minsize 大小	日志轮替的最小值。也就是日志一定要达到这个最小值才会进行轮持，否则就算时间达到也不进行轮替
size 大小	日志只有大于指定大小才进行日志轮替，而不是按照时间轮替，如size 100k
dateext	使用日期作为日志轮替文件的后缀，如secure-20130605
sharedscripts	在此关键宇之后的脚本只执行一次
prerotate/cndscript	在曰志轮替之前执行脚本命令。endscript标识prerotate脚本结束
postrolaie/endscripl	在日志轮替之后执行脚本命令。endscripi标识postrotate脚本结束