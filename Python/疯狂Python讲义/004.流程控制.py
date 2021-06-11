# _*_ coding: utf-8 _*_
# 004.1 顺序结构
# 004.2 if分支结构
# 形式一
if expression:
	statements...
# 形式二
if expression:
	statements...
else:
	statements...
# 形式三
if expression:
	statements...
elif expression:
	statements...
else:
	statements...

# 004.3 循环结构
# 004.3.1 while循环
while expression:
	statements...
# 004.3.2 while循环遍历列表和元组
a_tuple = ('fkit', 'crazyit', 'Charlie')
i = 0
while i < len(a_tuple):
	print(a_tuple[i])
	i += 1

# 004.3.3 for-in循环
for 变量 in 字符串|范围|集合等:
	statements

# 004.3.4 使用for-in变量字典
my_dict = {'语文': 90, '数学': 100, '英语': 98}
for key, value in my_dict.items():
	print{'key: ', key}
	print('value: ', value)

for key in my_dict.keys():
	print('key: ', key)
	print('value： '， my_dict[key])

# 004.3.5 for表达式
x * x for  x in xrange(1,10):
	pass

# 004.3.6 常用工具函数
a = ['a', 'b', 'c']
b = [1, 2, 3]
[x for x in zip(a,b)]
# zip()函数可以将两个列表压缩成一个zip对象，这样就可以使用一个循环并行遍历两个列表

# 004.5 控制循环结构
# 004.5.1 使用break结束循环
for x in range(0, 10):
	print("i 的值是：", i)
	if i==2:
		break

# 004.5.2 使用continue忽略本次循环的剩下语句
for x in range(0, 10):
	print("i 的值是：", i)
	if i==1:
		continue
	print("continue后的输出语句。")

# 004.5.3 使用return结束方法
for x in range(0, 10):
	for j in range(10):
		print("i的值是: %d,j的值是: %d" % (i, j))
		if j == i:
			return
		print("return后的输出语句")

