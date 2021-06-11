# 例1
a = 42
def foo():
	a = 13
foo()

# a仍然是42

# 例2
a = 42
b = 37
def foo():
	global a 
	a = 13
	b = 0
foo()

# 结果a为13，b仍然为37

# 嵌套函数定义
def countdown(start):
	n = start
	def display():
		print('T-minus %d' % n)
	while n > 0:
		display()
		n -= 1

