# _*_ coding: utf-8 _*_
# 006.1 类和对象
# 006.1.1 定义类
class 类名:
	statementes
	...

class Person:
	hair = 'black'
	def __init__(self, name = 'Charlie', age = 8):
		self.name = name
		self.age = age
	def say(self, content):
		print(content)


# 006.1.2 对象的产生和使用
P = Person()
# 操作对象的实例变量
print(P.name, P.age)
# 调用对象的方法
P.say('Python语言很简单，学习很容易！')

# 6.2 方法
# 6.2.1 类也能调用实例方法
def foo():
	print("全局空间的foo方法")

bar = 20
class Bird:
	def foo():
		print("Bird空间的foo方法")

	bar = 200

foo()
Bird.foo()

# 6.2.2 类方法与静态方法
class Bird:
	# 使用@classmethod装饰的方法是类方法
	@classmethod
	def fly(cls):
		print("类方法fly: ", cls)
	# 使用@staticmethod修饰的方法是静态方法
	@staticmethod
	def info(p):
		print("静态方法info: ", p)
# 调用类方法，Bird类会自动绑定到第一个参数
Bird.fly()
# 调用静态方法，不会自动绑定，因此程序必须手动绑定第一个参数
Bird.info('crazyit')

# 6.2.3 @ 函数装饰器
# 当程序使用“@函数”（函数A）装饰另一个函数（函数B）时，实际上完成两个步骤：
# （1）将被修饰函数B作为参数传递给@符号引用的函数A
# （2）将函数B替换成（1）步的返回值
def funA(fn):
	print('A')
	fn()
	return 'fkit'
@funA
def  funB():
	print('B')
print(funB)

# 6.3 成员变量
# 6.3.1 类变量和实例变量
# 在类命名空间内定义的变量就属于类变量，Python可以使用类来读取、修改类变量
class Address:
	detail = '广州'
	post_code = '510660'
	def info(self):
		print(detail)	# 直接访问类变量,报错
		print(Address.detail) # 通过类来访问类变量

print(Address.detail)
addr = Address()
addr.info()
Address.detail = '佛山'
Address.post_code = '460110'
addr.info()
# Python推荐使用对象类访问该对象所属类的类变量
class Record:
	item = "鼠标"
	date = "2016-06-16"
	def info(self):
		print("info方法中: ", self.item)
		print("info方法中: ", self.date)
	rc = Record()
	print(rc.item)
	print(rc.date)
	rc.info
# 6.4 隐藏和封装

# 6.5 类的继承
# 6.5.1 继承的语法
# Python子类继承父类的语法是在定义子类时，将多个父类放在子类之后的圆括号里
class SubClass(SuperClass1, SuperClass2, ...):
	# 类定义部分
# 6.5.2 关于多继承
# 6.5.3 重写父类的方法
class Bird:
	def fly(self):
		print("我再天空里自由自在地飞翔...")
class Ostrich(Bird):
	def fly(self):
		print("我只能在地上跑...")
os = Ostrich()
os.fly()
# 6.5.4 使用未绑定方法调用被重写的方法
class BaseClass:
	def foo(self):
		print("父类中定义的foo方法")
class SubClass(BaseClass):
	def foo(self):
		print("子类重写父类中的foo方法")
	def bar(self):
		print("执行bar方法")
		# 直接执行foo方法，将会调用子类重写之后的foo方法
		self.foo()
		BaseClass.foo()	# 使用类名调用实例方法，调用父类被重写的方法
sc = SubClass()
sc.bar()
# 6.5.5 使用super函数调用父类的构造方法
# Python的子类会继承得到父类的构造方法，如果子类有多个直接父类，那么排在前面的父类的构造方法会被优先使用

# 6.6 Python的动态性

# 6.7 多态

# 6.8 枚举类
