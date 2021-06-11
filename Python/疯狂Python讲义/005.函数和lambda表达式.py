# _*_ coding: utf-8 _*_

# 005.1 函数入门
# 005.1.1 理解函数
# 函数定义：
# 函数需要几个关键的需要动态变化的数据，这些数据应该被定义成函数的参数
# 函数需要传出几个重要的数据，这些数据就是函数的返回值
# 函数的内部实现过程
# 005.1.2 函数的定义和调用
def 函数名(形参列表):
	statementes
	return [返回值]

def my_max(x, y):
	z = x if x > y else y
	return z

result = my_max(4, 5)
print(result)


# 005.1.3 为函数提供文档
# 把一段字符串放在函数声明之后、函数体之前，这段字符串将被作为函数的部分，也就是函数的说明文档
# 访问方式 help(function-name) 或 function-name.__doc__
def my_max(x, y):
	'''
	获取两个数值之间较大的函数

	my_max(x, y)
		返回x、y两个参数之间较大的那个数
	'''
	return x if x > y else y
help(my_max)
my_max.__doc__

# 005.1.4 多个返回值
# 如果需要有多个返回值，则既可将多个值包装成列表之后返回，也可直接返回多个值。
# 如果直接返回多个值，Python会自动将多个返回值封装成元组

# 005.1.5 递归函数
# 在一个函数体内调用它自身
def fn(n):
	if n == 0:
		return 0
	elif n == 1:
		return 4
	else:
		return 2 * fn(n - 1) + fn(n - 2)

print("f(10)的结果是： ", fn(10))

# 005.2 函数的参数
# 005.2.1 关键字参数
def girth(width, height):
	print("width: ", width)
	print("height: ", height)
	return 2 * (height + width)
print(girth(3.5, 4.8))
print(girth(width = 5.5, height = 6.6))
print(girth(6.7, height=7.8))

# 005.2.2 参数默认值
def say_hi(name = "孙悟空", message = "欢迎来到疯狂软件"):
	print(name, "您好")
	print("消息是: ", message)

say_hi()
say_hi("白骨精")
say_hi("白骨精", "欢迎学习Python")

# 005.2.3 参数收集
def test(a, *books):
	print(books)
	for b in books:
		print(b)
	print(a)
# 收集关键字参数
def test2(x , y, z=3, *books, **scores):
	print(x, y, z)
	print(books)
	print(scores)
test2(1, 2, 3, "疯狂ios讲义", "疯狂Android讲义", "语文" = 89, "数学" = 100)

# 005.2.4 逆向参数收集
# 指的是在程序已有列表、元组、字典等对象的前提下，把它们的元素“拆开”后传给函数的参数
def test3(name, message):
	print(name)
	print(message)
my_list = ["孙悟空", "欢迎来疯狂软件!"]
test3(*my_list)
# 在字典参数前加两个星号

# 005.2.5 函数的参数传递机制
# 值传递，就是将实际参数值得副本传入函数，而参数本身不会收到影响

# 005.2.6 变量的作用域
# 根据变量的位置分为：
#	局部变量 函数中定义的变量，包括参数
#	全局变量 函数外面、全局范围内定义的变量
# Python提供了如下三个工具函数来获取指定范围内的“变量字典”
globals() 	# 返回全局范围内所有变量组成的“变量字典”
locals()	# 返回当前局部范围内所有变量组成的“变量字典”
vars(object) # 获取再指定对象阀内内所有变量组成的“变量字典”