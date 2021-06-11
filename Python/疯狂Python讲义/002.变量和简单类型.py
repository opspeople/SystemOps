# _*_ coding: utf-8 _*_
# 变量是编程的起点，程序用到的各种数据都是存储在变量中的。
# Python是一门弱类型语言，弱类型包含两方面的含义：
    # （1）所有的变量无须声明即可使用，或者说对从未使用过的变量赋值就是声明了该变量
    # （2）变量的数据类型可以随时改变，同一个变量可以一会儿是数值，一会儿是字符串类型
'''
a = 100
print(a) 
a = "This is a test!"
print(a)
'''
# 002.1 单行注释和多行注释
# 单行注释：使用#开通的行
# 多行注释：3个单引号或3个双引号
'''
    单引号
'''
"""
    双引号
"""
# 002.2.1 变量
'''
a = 5
b = type(a)
print(type(a))
'''
# 002.2.2 使用print函数输出变量
# print(value, ..., sep=' ', end='\n', file=sys.stdout, flush=False)
'''
print(a, b, sep=' ', end='\n')
'''
# 003.2.3 变量的命名规则
# （1）标识符可以由字母、数字、下划线组成，其中数字不能打头
# （2）标识符不能是Python关键字，但可以包含关键字
# （3）标识符不能包含空格

# 002.2.4 Python关键字和内置函数
'''
# >>> import keyword 
# >>> keyword.kwlist
['False', 'None', 'True', '__peg_parser__', 'and', 'as', 'assert', 'async', 'await', 'break', 
'class', 'continue', 'def', 'del', 'elif', 'else', 'except', 'finally', 'for', 'from', 'global', 
'if', 'import', 'in', 'is', 'lambda', 'nonlocal', 'not', 'or', 'pass', 'raise', 'return', 'try', 
'while', 'with', 'yield']
'''
# 002.3 数值类型
# 002.3.1 整型
'''
a = 56
print(a)
'''
# 002.3.2 浮点型
'''
f1 = 5.31245
print("f1的值: ", f1)
'''
# 003.3.3 复数
'''
ac1 = a + 5j
print("ac1的值为: ", ac1)
'''
# 002.4 字符串入门
# 002.4.1 字符串和转义字符
'''
str1 = 'name'
str2 = 'age'
print(str1)
print(str2)
'''
# 转义字符： 字符串本身包含单引号或双引号时使用
'''
str3 = 'I\'m a boy.'
print(str3)
'''
# 002.4.2 拼接字符串
'''
str4 = 'xuhua'
str5 = ' is 20 old.'
print(str4 + str5)
'''
# 002.4.3 repr和字符串
# repr 和 str 可以将数值转换成字符串，其中str是Python内置函数，和int，float一样
# 儿repr()则知识一个函数，此外，repr可以以Python表达式的形式来标识值
'''
s1 = "This book is "
p = 99.9
s2 = "$."
print(s1 + repr(p) + s2)
print(s1 + str(p) + s2)
s3 = "repr返回Python表达式"
print(repr(s3))
print(str(s3))
'''
# 002.4.4 使用input和raw_input获取用户输入
# raw_input是Python2版本的输入函数，相当于Python3的input函数
# raw_input输入字符串时需要使用引用将字符串括起来
'''
msg = input("请输入你的姓名: ")
print(msg)
'''
# 002.4.5 长字符串
# 将使用三引号括起来的字符串就是长字符串，可以赋值给变量
# python还允许使用转义字符（\）对换行符进行转义，转义之后的换行符不会“中断”字符串
'''
lstr1 = '''  ''' my name is xuhua \
i'm 25 years old.
 ''' '''
print(lstr1)
'''
# 002.4.6 原始字符串
# 原始字符串以“r”开头，原始字符串不会吧反斜杠当成特殊字符
'''
sr = r'G:\publish\codes\02\2.4'
print(sr)
'''
# 002.4.7 字节串
# 创建一个字节串
b1 = bytes()
# 002.5 深入字符串
# 002.5.1 转义字符
'''
\b 退格
\n 换行
\r 回车
\t 制表
\" 双引号
\' 单引号
\\ 反斜杠
'''
# 002.5.2 字符串格式化
# Python提供了 '%' 对各种类型的数据进行格式化输出
'''
price = 108
print("the book's price is %s" % price)
格式化字符串中有两个占位符，第三部分也应该提供两个变量
user = "charli"
age = 8
print("%s is a %s years old boy" % (usr, age))
'''
'''  转换符
d,i 转换为十进制形式的整数
o   八进制
x   十六进制
X   十六进制
e   科学计数法的浮点数e小写
E   科学计数法的浮点数E大写
f,F 十进制浮点数
g   智能选择e还是f格式
G   智能选择E还是F格式
C   转换为单字符
r   使用repr()将变量或表达式转换为字符串
s   使用str()将变量或表达式转换为字符串
'''
# %6d 指定最小宽度为6
# 在默认情况下，转换出来的字符串总是右对齐的，不够宽度是左边补充空格。Python
# 也允许在最小宽度之前添加一个标志来改变这种行为
# - 指定左对齐
# + 表示数值总要带着符号，正数 + ，负数 -
# 0 表示不补充空格，而是补充0

# 002.5.3 序列相关方法
'''
s = 'crazyit.org is very good'
print(s[2]) # 输出a
print(s[-4]) # 输出g
'''

# 002.5.4 大小写相关方法
# Python字符串由内奸的str类代表，Python非常方便，Python自带文档，
# Python文档函数：
	# dir()
	# help()
'''
每个单词的首字母大写
a = 'our domain is crazyit.org'
print(a.title())
# 每个字母小写
print(a.lower())
# 每个字母大写
print(a.upper())
'''

# 002.5.5 删除空白
# str还提供了如下常用的方法来删除空白
# strip() # 删除字符串前后的空白
# lstrip() # 删除字符串前面的空白
# rstrip() # 删除字符串后面的空白
'''
s = ' this is a puppy '
print(s.lstrip())
print(s.rstrip())
print(s.strip())

s2 = 'i think it is a scarecrow'
print(s2.lstrip('itow'))
print(s2.rstrip('itow'))
print(s2.strip('itow'))
'''

# 002.5.6 查找、替换相关方法
# startswith() 	判断字符串是否以指定子串开头
# endswith() 	判断字符串是否以指定子串结尾
# find()  		查找指定子串再字符串中出现的位置，如果没有找到指定子串，则返回-1
# index()		查找指定子串在字符串中出现的位置，没有，则引发ValueError错误
# replace() 	使用指定子串体寒字符串中的目标子串
# translate()	使用指定的翻译映射表对字符串执行替换

# 002.5.7 分割、连接方法
# split() 将字符串按指定分隔符分割成多个短语
# join() 将多个短语连接成字符串

# 002.6 运算符
# 002.6.1 赋值运算符
# =
# 002.6.2 算术运算符
# + - * /(普通除法) //(整除) % 
# 002.6.3 位运算符
# & 与
# | 或
# ^ 按位异或
# ~ 按位取反
# << 左移运算符
# >> 右移运算符
# 002.6.4 索引运算符
'''
a = 'abcdefghijklmn'
# 获取索引2到8的子串，步长位3
print(a[2:8:3])
'''
# 002.6.6 比较运算符与bool类型
# >
# >=
# <
# <=
# ==
# !=
# is
# is not

# 002.6.7 逻辑运算符
# and
# or
# not

# 002.6.8 三目运算符
# True_statements if expression else False_statements
# print("a大于b") if a > b else print("a小于b")

# 002.6.9 in运算符
# s = "crazyit.org"
# print("it" in s) # 输出True