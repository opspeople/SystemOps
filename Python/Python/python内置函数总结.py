#!/usr/bin/python3
abs()
all()
any()
ascii()
bin()
bool()
bytearray()
callable()
chr()
classmethod()
compile()
delattr()
dict()
dir()
divmod()
enumerate()
eval()
filter()
float()
format()
frozenset()
getattr()
globals()
hasattr()
hash()
help()
hex()
id()
input()
int()
isinstance()
issubclass()
iter()
len()
list()
locals()
map()
max()
memoryview()
min()
next()
object()
oct()
open()
ord()
pow()
print()
property()
range()
repr()
reversed()
round()
set()
setattr()
slice()
sorted()
staticmethod()
str()
sum()
super()
tuple()
type()
vars()
zip()
__import__()

# 1.和数字相关
# 数据类型
bool 	布尔型(True, False)
int 	整型(整数)
float	浮点型(小数)
complex	复数
# 进制转换
bin()	将给的参数转换成二进制
otc()	将给的参数转换成八进制
hex()	将给的参数转换成十六进制
# 数学运算
abs()	返回绝对值
divmod()	返回商和余数
print(divmod(20,3))
round()	四舍五入
pow(a,b) 	求a的b次幂，如果有三个参数，则求完次幂后对第三个数取余
sum()	求和
sum([1,2,3,4,5])
min()	求最小值 min(1,2,3,4)
max()	求最大值	max(1,2,3,4)


# 2.和数据结构相关
# 序列
# 列表和元组
list()	将一个可迭代对象转换成列表
tuple()	将一个可迭代对象转换成元组
print(list((1,2,3,4,5)))
print(tuple([1,2,3,4,5]))
# 相关内置函数
reversed() 	将一个序列翻转，返回翻转序列的迭代器
slice()		列表的切片
lst="你好"
it=reversed(lst)
print(list(it))
lst=[1,2,3,4,5]
print(lst[1:3:1]) # [2,3]
s=slice(1,3,1)
print(lst[s])
# 字符串
str() 将数据转换成字符串
str(123) + '456'
format()	与具体数据相关，用于计算各种小数，精算等
s = "hello world!"
print(format(s, "^20"))  #剧中
print(format(s, "<20"))  #左对齐
print(format(s, ">20"))  #右对齐
#     hello world!    
# hello world!        
#         hello world!
print(format(3, 'b' ))    # 二进制:11
print(format(97, 'c' ))   # 转换成unicode字符:a
print(format(11, 'd' ))   # ⼗进制:11
print(format(11, 'o' ))   # 八进制:13 
print(format(11, 'x' ))   # 十六进制(⼩写字母):b
print(format(11, 'X' ))   # 十六进制(大写字母):B
print(format(11, 'n' ))   # 和d⼀样:11
print(format(11))         # 和d⼀样:11
print(format(123456789, 'e' ))      # 科学计数法. 默认保留6位小数:1.234568e+08
print(format(123456789, '0.2e' ))   # 科学计数法. 保留2位小数(小写):1.23e+08
print(format(123456789, '0.2E' ))   # 科学计数法. 保留2位小数(大写):1.23E+08
print(format(1.23456789, 'f' ))     # 小数点计数法. 保留6位小数:1.234568
print(format(1.23456789, '0.2f' ))  # 小数点计数法. 保留2位小数:1.23
print(format(1.23456789, '0.10f'))  # 小数点计数法. 保留10位小数:1.2345678900
print(format(1.23456789e+3, 'F'))   # 小数点计数法. 很大的时候输出INF:1234.567890
bytes() 把字符串转换成bytes类型
bs = bytes("今天吃饭了吗", encoding="utf-8")
bytearray()	返回一个新字节数组，这个数字的元素是可变的，并且每个元素的值得范围是[0,256)
ord()	输入字符找带字符编码的位置
chr()	输入位置数字找出对应的字符
ascii()	是ascii码中的返回该值，不是就返回u
>>> s="今天\n吃了%s顿\t饭"
>>> print(s)
今天
吃了%s顿        饭
>>> print(repr(s))
'今天\n吃了%s顿\t饭'
# 数据集合
字典： dict 创建一个字典
集合： set 	创建一个集合
frezenset() 创建一个冻结的集合，冻结的集合不能进行添加和删除操作
# 相关内置函数
len()	# 返回一个对象中的元素的个数
sorted()	# 对可迭代对象进行排序操作
sorted(iterable, key=函数(排序规则), reverse=False)
enumerate()	# 获取集合的枚举对象
all()	# 可迭代对象中全部是True，结果才是True
any()	# 可迭代对象中有一个是True，结果就是True
zip()	# 用于将可迭代的对象作为参数，将对象中对应的元素打包成一个元组，然后返回由这些元组组成的列表。
		# 如果各个迭代器的元素个数不一致，则返回列表长度与最短的对象相同
lst1 = [1, 2, 3]
lst2 = ["醉乡民谣", "驴得水", "放牛班的春天", "美丽人生"]
lst3 = ['美国', '中国', '法国']
print(zip(lst1, lst2, lst3))
#for e1 in zip(lst1, lst2, lst3):
#	print(e1)

filter()过滤(lamda)
# 语法：filter(function.Iterable)
function # 用来筛选的函数。在filter中会自动的把Iterable中的元素传递给function。然后根据function返回的True或False来判断是否保留此项数据，Iterable：可迭代对象
# def func(i):
# 	retrun i % 2 == 1
lst = [1, 2, 3, 4, 5, 6, 7, 8, 9]
ll = filter(func, lst)
print(ll)
print(list(ll))

map() # 会根据提供的函数对指定序列列做映射(lamba)
# 语法：map(function, iterable)
# def f(i):
#	return i
lst = [1, 2, 3, 4, 5]
it=map(f, lst)


# 3.和作用域相关
locals() 	# 返回当前作用域中的名字
globals()	# 返回全局作用域中的名字

# 4.和迭代器生成器相关
range()		# 生成数据
next()		# 迭代器向下执行一次，内部实际使用了__next__()方法返回迭代器的下一项目
iter()		# 获取迭代器，内部实际使用的是__iter__()方法来获取迭代器
# for i in range(15, -1, -5):
#	print(i)
lst = [1, 2, 3, 4, 5]
it = iter(lst)
print(it.__next__())
print(next())

# 5.字符串类型代码的执行
eval()	# 执行字符串类型的代码，并返回最终结果
s1 = input("请输入a+b:")
print(eval(s1))

exec() # 执行字符串类型的代码
s2 = "for x in range(5): print(i)"
a = exec(s2)
print(a)

compile()	# 将字符串类型的代码编码。代码对象能够通过exec语句来执行或者eval()进行求值
exec("""
	def func():
		print("我是周杰伦")
""")

# func() 我是周杰伦
code1 = "for x in range(3): print(x)"
com = compile(code1, "", mode="exec")
exec(com)

code2 = "5+6+7"
com2 = compile(code2, "", mode="eval")
print(eval(com2))

code3 = "name = input('请输入你的名字:')"
com3 = compile(code3, "", mode="single")
exec(com3)
print(name)

# 6.输入输出
print()
input()
print("hello", "world", sep="*", end="@")

# 7.内存相关
hash() # 获取到对象的哈希值(int, str, bool, tuple)
		# hash算法： （1）目的是唯一性 （2）dict查找效率非常高，hash表.用空间换时间，比较消耗内存
s = 'alex'
print(hash(s))
lst = [1, 2, 3, 4, 5]
print(hash(list)) # 报错，列表是不可hash的
id() # 获取对象的内存地址
print(id(s))

# 8.文件操作相关
open()	#打开一个文件
f = open('file', mode='r', encoding='utf-8')
f.read()
f.close()

# 9.模块相关
__import__() # 用于动态加载类和函数

# import os 
name = input("请输入你要导入的模块：")
__import__(name)

# 10.调用相关
callable() # 用于检察一个对象是否可调用。如果返回True，object有可能调用失败，如果返回False，那一定会失败

a = 10
print(callable(a))

# def f():
	print("hello")
	print(callable(f))

# 11.查看内置属性
dir()	# 查看对象的内置属性，访问的是对象的__dir__()方法
print(dir(tuple))

# 12.帮组
help()
print(help(str))



