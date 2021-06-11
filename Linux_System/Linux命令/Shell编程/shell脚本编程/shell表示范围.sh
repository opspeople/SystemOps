#!/usr/bin/env sh
# 1.方式1
xuhua@yujian:~$ echo {1..20}
1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20

# 2.方式二
xuhua@yujian:~$ echo `seq 1 3 20`
1 4 7 10 13 16 19

xuhua@yujian:~$ for x in `seq 1 3 20`;do echo $x;done
1
4
7
10
13
16
19

# 3.方式3
xuhua@yujian:~$ for((x=0;x<10;x++));do echo $x;done
0
1
2
3
4
5
6
7
8
9
