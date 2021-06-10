#!/usr/bin/env bash

uniq - 删除排序文件中的重复行

选项
	-c,--count 在行首显示出现的数目
	-d,--repeated 仅显示重复的行
	-D,--all-repeated 显示全部重复行
	-f,--skip-fields=N 不比较起初的N栏
	-i,--ignore-case 比较是忽略大小写
	-s,--skip-chars=N 不比较起初的N个字符
	-u,--unique 仅显示无重复行
	-w,--check-chars=N 每行中比较不超过N个字符
	-N 同 -f N 
	+N 同 -s N 