#!/usr/bin/env bash
!$ # 获取命令最后的参数
[root@master test]# cat test.txt 
This is a test\!
[root@master test]# cat !$
cat test.txt
This is a test\!

!:n # 获取命令的第n个参数
# n从0开始取值
[root@master test]# echo "This is a test" >> test.txt
[root@master test]# !:0 !:1 !:2 !:3
echo "This is a test" >> test.txt
[root@master test]# cat test.txt 
This is a test\!
This is a test
This is a test

!:1-$ 获取所有参数
!:0-$ 获取命令及所有参数

!-n:$ 获取倒数第n条命令的参数
