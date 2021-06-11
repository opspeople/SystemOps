items = [37, 42] # 创建一个列表对象
items.append(73) # 列表的append方法

dir(items) 函数可以列出对象的可用方法


# 类
class语句用来定义新的对象类型，实现面向对象编程。
class Stack(object):
	def __init__(self):
		self.stack = []
	def push(self, object):
		self.stack.append(object)
	def pop(self):
		return self.stack.pop()
	def length(self):
		return len(self.stack)

# 继承，继承列表
class Stack(list):
	def push(self, object):
		self.append(object)

