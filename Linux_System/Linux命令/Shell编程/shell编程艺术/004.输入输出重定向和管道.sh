1.标准输出
	echo "context" > file1.txt 覆盖

	echo "context" >> file2.txt 追加

2.标准输入
first.sh
#!/bin/bash
linenumber=1
read oneline
while [ "$online" != "" ]
do
	echo -e "$linenumber: $oneline"
	linenumber=`expr $linenumber + 1`
	read oneline
done

exit 0

bash first.sh < /etc/passwd

3.标准错误输出

cat testfile 1> result.txt 2> error.txt

4.管道
将一个程序的输出数据作为另一个程序的输入数据
#!/usr/bin/bash
linenumber=1
cat $1 | while read oneline
do
	echo -e "$linenumber: $oneline \n"
	linenumber=`expr $linenumber + 1`
done
exit 0

5.标准输出重定向到文件
#!/usr/bin/bash
sort /etc/passwd | cat -n | tee sort.out
tee # 同时输出到标准输出和文件

6.块语句的输出和重定向
#!/usr/bin/bash
{ date; cd /etc;echo -n "Current Working dir"; pwd ;} > block_current.out
exit 0
{} # 使用{}将所有的命令包围起来，使其构成一个整体的语句块

7.Here Document

8.文件描述符
STDIN 0
STDOUT 1
STDERR 2
echo "Sending Statistics data to file descriptor 6." >&6

# 2>&1 

test.sh 6>out6.txt

9.多个输出重定向到一个文件
标准错误输出定向到标准输出
2>&1

10.使用exec命令关联一个自定义的文件描述符到一个特定的文件
#!/usr/bin/bash
echo 4>exec.out4
exec 5>exec.out5
exec 6>&4
# 任务完成以后关闭文件描述符
exec 4>&-
exec 5>&-
# exec打开文件描述符的语法格式
exec fd > outputfile 	# 覆盖
exec fd >> outputfile	# 追加

