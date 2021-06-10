#!/bin/bash

cd - # 返回上一个目录

# shell历史
Ctrl + r # 连续按向上箭头以选择我的shell历史记录中的最后一个命令
![number] # 执行历史命令

!^ # 前一个命令的第一个参数
!$ # 前一个命令的最后一个参数

!! # 重新执行上一条命令

!:[index] # 前一个命令的索引
echo linux python java
linux python java
echo !:[1]
linux 
echo !:[2-3]
python java


# 快捷键
Ctrl + k # 剪切光标及其后边的内容
Ctrl + u # 剪切光标之前的内容
