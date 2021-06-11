#!/usr/bin/python3
001.使用python解释器提示符
进入Python解释器
	>>> # 被称为Python解释器提示符
退出Python解释器
	>>> Ctrl + d
	>>> exit()
Python编辑器
	Pycharm
	Vim
	Emacs
获取帮助
	help('len')

002.基础
注释
	# 注释内容
字面常量
	数字、字符、字符串、文本
数字
	整数 	# 1,2,3
	浮点数	# 1.2,2.3
字符串
	# 字符的序列
	# 字符串是不可变序列
单引号
	''
双引号
	""
三引号
	'''
		多行内容
	'''
格式化方法
	age=20
	name='xuhua'
	print('{0} was {1} years old when he wrote this book'.format(name, age))
	print('{0:.3f}'.format(1.0/3))		# 保留小数点后三位
	print('{0:_^11}'.format('hello')) 	# 使用下划线填充文本，文本居中
	print('{name} wrote {book}'.format(name='Swaroop', book='A Byte of Python'))
转义序列
	使用 \\ 来指定需要转义的字符
原始字符串
	指定一些未经过处理的字符串，比如转义序列，需要再字符串前增加r或R来指定一个原始字符串
	r"Newlines are indicated by \n"
变量
标识符命名
	命名规则
		_
		大小写字母
		数字
数据类型
对象
	Python将程序中的任何内容统称为对象Object
如何编写Python程序
逻辑行与物理行
	物理行 每一行显示的内容
		i = 5
		print(i)
	逻辑行 Python所看到的单个语句
		i = 5;print(i)
		i = 5;print(i);
缩进
	每行开始的空白区域

003.运算符与表达式
运算符
	+
	-
	*
	** 	乘方
	/	除
	//	整除
	%	取余
	<< 	左移
	>> 	右移
	& 	按位与
	|	按位或
	^ 	按位异或
	-	按位取反
	<	小于
	> 	大于
	<=
	>=
	==
	!=
	not	非
	and	与
	or	或
数值运算与赋值的快捷方式
	a = 2
	a = a * 3
	a *= 3
表达式

004.控制流 - 流程控制
if语句
	if  ...:
		...
	elif ...:
		...
	elif ...:
		...
	else:
		...

while语句
	while True:
			if  ...:
				...
			elif ...:
				...
			elif ...:
				...
			else:
				...
	else

for语句
for i in range(1,5):
	print(i)
else:
	print('The for loop is over')

break语句
while True:
	s = input('Enter something: ')
	if s == 'quit':
		break 
	print('Length of the string is', len(s))
print('Done')

continue语句
while True:
	s = input('Enter something:')
	if s == 'quit':
		break
	if len(s) < 3:
		print('Too samll')
		continue
	print('Input is of sufficient length')

###################################################
005.函数
def say_hello():
	print('Hello World!')
函数参数
def print_max(a, b):
	if a>b:
		print(a, 'is maximum')
	elif a == b:
		print(a, 'is qual to', b)
	else:
		print(b, 'is maximum')
局部变量
x = 50
def func(x):
	print('x is', x)
	x = 2
	print('changed local x to', x)
func(x)
print('x is still', x)
# 运行结果
x is 50
changed local x to 2
x is still 50

global语句
x = 50
def func(x):
	global x
	print('x is', x)
	x = 2
	print('changed local x to', x)
func(x)
print('value of x is', x)
# 运行结果
x is 50
changed local x to 2
x is still 2

默认参数值
def say(message, times=1):
	print(message * times)

say('hello')
say('hello', 3)
# 运行结果
hello
hellohellohello

关键字参数
def func(a, b=5, c=10):
	print('a is', a, 'and b is ', b, 'and c is', c)
func(3,7)
func(25, c=24)
func(c=50, a=100)

可变参数
def total(a=5, *numbers, **phonebok):
	print('a', a)

	# 遍历元组中的所有项目
	for single_item in numbers:
		print('single_item', single_item)

	# 遍历字典中的所有项目
	for first_part, second_part in phonebok.items():
		print(first_part, second_part)
print(total(10, 1, 2, 3, Jack=1123, Johe=2231, Inge=1500))

return语句
# 用于从函数中返回
def maximum(x, y):
	if x > y:
		return x
	elif x == y:
		return 'The numbers are equal'
	else:
		return y

DocStrings
# Python文档字符串，当程序实际运行时，可以通过一个函数来获取文档
def maximum(x, y):
	''' 打印两个数值中的最大数
	这两个数都应该是整数'''
	if x > y:
		return x
	elif x == y:
		return 'The numbers are equal'
	else:
		return y
print_max(3, 5)
print(print_max.__doc__)
打印两个数值中的最大数
这两个数都应该是整数

###################################################
006.模块
# 编写模块的方法
# 1.创建一个包含函数与变量以.py为后缀的文件
# 2.使用C语言来撰写Python模块

# 导入模块
import sys

# 按字节码编译的.pyc文件
导入一个模块是一件代价高昂的事情，因此Python引入了一些技巧使其能够更快速的完成。
其中一种方式是创建按字节码编译的文件，这一文件以.pyc为其扩展名，是将Python转换成中间形式的文件。
这一.pyc文件在下一次从其它不同的程序导入模块时更快速。

# 模块的 __name__
if __name__ == '__main__':
	print pass
else:
	print pass

# 编写模块
# mymodule.py
def say_he():
	print('Hi, this is mymodule speaking.')
__version__ == '0.1'

# dir函数
# 内置的dir函数能够返回由对象所定义的名称列表。如果这一对象时一个模块，则该列表会包含函数内所定义的函数、类与变量

# 包
# 组织程序的层次结构。
# 1.变量通常位于函数内部
# 2.函数与全局变量通常位于模块内部
# 3.对模块的组织-包
# 4.包是指一个包含模块与一个特殊的__init__.py文件的文件夹，后者向Python表明这一文件是特别的，因为其包含了Python模块
# 包：例
- world/
	- __init__.py
	- asia/
		- __init__.py
		- india/
			- __init__.py
			- foo.py
	- africa/
		- __init__.py
		- madagascar/
			- __init__.py
			- bar.py

##################################################
007.数据结构
# Python内置的数据结构--列表(List)、元组(Tuple)、字典(Dictionary)和集合(Set)
# 列表
list1 = [1, 2, 3, 4]

# 元组
tuple1 = ('Python', 'C++', 'Java')

# 字典
dict1 = {'chinese':'80', 'math':'40', 'english':'90'}
for key,value in dict1.items():
	print('The {}: {}'.format(key, value))

# 集合
parame = {value1, value2, value3,...}
set(value)
创建空集合必须是set{},而不能是{}

#######################################################
008.面向对象编程
# 面向对象编程的两个主要方面：
# 1.类(class)能够创建一种新的类型
# 2.对象(Object)类的实例。
self
# 类方法与普通函数只有一种特定的区别---前者必须多加一个参数在参数列表开头
# 这个名字必须添加到参数列表的开头，但是你不用在你调用这个功能时为这个参数赋值，Python会为它提供。
# 这种特定的变量引用的是对象本身，按照惯例，它被赋予self这一名称

类
class Person:
	pass
p = Person()
print(p)

方法
class Person:
	def say_hi(self):
		print('Hello, how are you?')
p = Person()
p.say_hi()

__init__ 方法
# 在类的对象被实例化时立即运行。这一方法可以对任何你想进行操作的目标对象进行初始化操作。
class Person():
	def __init__(self, name):
		self.name = name
	def say_hi(self):
		print('Hello, my name is', self.name)
p = Person('Swaroop')
p.say_hi()

类变量与对象变量
# 类变量是共享的
# 对象变量由类的每一个独立的对象或实例所拥有。

# coding=UTF-8
class Robot():
	"""
	表示有一个带有名字的机器人。
	"""
	# 一个类变量，用来计数机器人的数量
	population = 0

	def __init__(self, name):
	"""初始化数据"""
	self.name = name
	print("(Initializing {})".format(self.name))

	# 当有人被创建时，机器人
	# 将会增加人口数量
	Robot.population += 1

	def die(self):
		"""我挂了"""
		print("{} is being destroyed!".format(self.name))

		Robot.population -= 1

		if Robot.population == 0:
			print("{} was the last one.".format(self.name))
		else:
			print("There are still {:d} robots working.".format(Robot.population))

	def say_hi(self):
		"""
		来自机器人的诚挚问候
		"""

		print("Greetings, my masters call me {}.".format(self.name))

	@classmethod
	def how_many(cls):
		"""打印出当前的人口数量"""
		print("We have {:d} robots.".format(cls.population))

droid1 = Robot("R2-D2")
droid1.say_hi()
Robot.how_many()

droid2 = Robot("C-3PO")
droid2.say_hi()
Robot.how_many()

droid1.die()
droid2.die()

Robot.how_many()

继承
# coding=UTF-8
class SchoolMember:
	'''
	代表任何学校里的成员
	'''
	def __init__(self, name, age):
		self.name = name
		self.age = age
		print('Initialized SchoolMember: {}'.format(self.name))

	def tell(self):
		'''告诉我有关我的细节'''
		print('Name: "{}" Age:"{}"'.format(self.name, self.age), end=" ")

class Teacher(SchoolMember):
	'''代表一位老师'''
	def __init__(self, name, age, salary):
		SchoolMember.__init__(self, name, age)
		self.salary = salary
		print('(Initialized Teacher: {})'.format(self.name))

	def tell(self):
		SchoolMember.tell(self)
		print('Salary: "{:d}"'.format(self.salary))

class Student(SchoolMember):
	'''代表一位学生'''
	def __init__(self, name, age, marks):
		SchoolMember.__init__(self, name, age)
		self.marks = marks
		print('(Initialized Student: {})'.format(self.name))

	def tell(self):
		SchoolMember.tell(self)
		print('Marks: "{:d}"}'.format(self.marks))

t = Teacher('Mrs.Shrividya', 40, 30000)
s = Student('Swaroop', 25, 75)

print()

members = [t, s]
for member in members:
	member.tell()

输入与输出
用户输入内容
def reverse(text):
	return text[::-1]

def is_palindrome(text):
	return text == reverse(text)

something = input("Enter text: ")
if is_palindrome(something):
	print("Yes, it is a palindrome")
else:
	print("No, it is not a palindrome")

[::-1]  翻转文本

文件读写
poem='''\
Programming is fun
When the work is done
if you wanna make your work alse fun:
		use python!
'''

f = open('poem.txt', 'w')
f.write(poem)
f.close()

f = open('poem.txt')
while True:
	line = f.readline()
	if len(line) == 0:
		break
	print(line, end='')
f.close()
文件打开模式：
	r 阅读模式
	w 写入模式
	a 追加模式

Pickle
# Python提供了一个叫做Pickle的标准模块，铜鼓它可以将任何纯Python对象存储到一个文件中，并在稍后将其取回。这叫作持久地存储对象
import pickle 
shoplistfile = 'shoplist.data'
shoplist = ['apple', 'mango', 'carrot']
f= open(shoplistfile, 'wb')
pickle.dump(shoplist, f)
f.close()

del shoplist

f = open(shoplistfile, 'rb')
storedlist = pickle.load(f)
print(storedlist)

异常
处理异常
try:
	text = input('Enter something --> ')
except EOFError:
	print('Why did you do an EOF on me?')
except KeyboardInterrupt:
	print('You cancelled the operation.')
else:
	print('You entered {}'.format(text))

抛出异常
通过raise语句来引发一次异常，具体方法是提供错误名以及要抛出异常的对象
class ShortInputExecption(Exception):
	'''
	一个由用户定义的异常类
	'''
	def __init__(self, length, atleast):
		Exception.__init__(self)
		self.length = length
		self.atleast = atleast

try:
	text = input('Enter something --> ')
	if len(text) < 3:
		raise ShortInputException(len(text), 3)
except EOFError:
	print('Why did you do an EOF on me?')
except ShortInputException as ex:
	print(('ShortInputException: The input was ' + 
		'{0} long, expected at least {1}')
		.format(ex.length, ex.atleast))
else:
	print('No exception was raised.')

Try ... Finally

import sys
import time
f = None
try:
	f = open('poem.txt')
	while True:
		line = f.readline()
		if len(line) == 0:
			break
		print(line, end='')
		sys.stdout.flush()
		print("Press ctrl+c now")
		time.sleep(2)
except IOError:
	print('Could not find file poem.txt')
except KeyboardInterrupt:
	print('!! You cancelled the reading from the file.')
finally:
	if f:
		f.close()
	print("(Cleaning up: closed the file.)")

with语句
# 在try模块中获取资源，然后在finally块中释放资源是一种常见的模式
# with语句使得这一过程可以以一种干净的姿态得以完成
with open("poem.txt") as f:
	for line in f:
		print(line, end='')
		