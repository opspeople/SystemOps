# _*_ coding: utf-8 _*_
# 003.1 序列简介
# 003.1.1 Python的序列
# python的常见序列类型包括字符串、列表和元组
# 003.1.2 创建列表和元组
# 创建列表
[ele1, ele2, ele3, ...]
# 创建元组
(ele1, ele2, ele3, ...)
# 使用方括号定义列表
my_list = ['name', 'age', 'high']
print(my_list)
# 使用圆括号定义元组
my_tuple = ('crazyit', 20 ,'Python')
print(my_tuple)

# 003.2 列表和元组的通用用法
# 003.2.1 通过索引使用元素
a_tuple = ('crazyit', 20, 5.6, 'fkit', -17)
print(a_tuple[0])
# 003.2.2 子序列
b_tuple = ('crazyit', 20, 5.6, 'fkit', -17)
print(b_tuple[1,3])
print(b_tuple[-3:1])
# 003.2.3 加法
a_tuple = (1, 2, 3)
b_tuple = (4, 5, 6)
print(a_tuple + b_tuple)
# 003.2.4 乘法

# 003.2.5 in运算
a_tuple = ('crazyit', 20, -1.2)
print(20 in a_tuple)

# 003.2.6 长度、最大值和最小值
print(max(a_tuple))
print(min(a_tuple))
print(len(a_tuple))

# 003.2.7 序列封包和序列解包
# 序列封包: 程序把多个值赋给一个变量时，Python会自动将多个值封装成元组
# 序列解包： 程序直接将序列（元组或列表）直接赋值给多个变量，，此时序列的各元素会被一次赋值给每个变量

# 003.3 使用列表
# 003.3.1 创建列表
a_tuple = ('crazyit', 20, -1.2)
a_list = list(a_tuple)  # 将元组转换成列表
b_range = range(1, 5) 	# 使用range函数创建区间range对象
b_list = list(b_range) 	# 将区间转换为列表
c_list = list(range(4, 20, 3)) # 创建区间对象时指定步长
# 列表也可通过tuple转换为元组

# 003.3.2 增加列表元素
d_list = [1, 2, 3]
d_list1 = [8, 9]
d_tuple = (5, 6, 7)
d_list.append('test1')
d_list.append(d_tuple) # 追加一个元组，将元组作为列表的一个元素
d_list.append(d_list1) # 追加一个列表，列表被当做一个元素

# 003.3.3 删除列表元素
e_list = [1, 2, 3]
del e_list[0]

# 003.3.4 修改列表元素
f_list = [2, 3, 4]
f_list[1] = 5

# 003.3.5 列表的其他常用方法
count() 	# 统计列表中某个元素出现的次数
index()		# 判断某个元素在列表中出现的位置
pop()		# 用于将列表当成"栈"使用，实现元素出栈功能
reverse()	# 用于将列表中的元素反向存放
sort()		# 用于对列表元素排序

# 003.4 使用字典
# 003.4.1 字典入门
# 为了保存具有映射关系的数据，Python提供了字典，字典相当于保存了两组数据
# 其中一组数据是关键数据：key，其中一组数据可通过key访问：value
# key不可重复
# 003.4.2 创建字典
# 使用花括号来创建字典：
dict1 = {'语文': 89, '数学': 90}
empty_dict = {}
cars = [['BWM': 8.5], ['BENS': 8.3], ['AUDI': 7.9]]
dict2 = dict(cars)
vegetables = [('celery', 1.58), ('brocoli', 1.29)]
dict3 = dict(vegetables)
# 003.4.3 字典的基本用法
# 通过key访问value
dict4 = {'语文': 80}
print(dict4['语文'])
# 通过key添加key-value对
dict4['数学'] = 90
# 使用key删除key-value对
del dict4['数学']
# 使用key修改key-value对
dict4['语文'] = 95
# 使用key判断指定key-value是否存在
print('语文' in dict4)

# 003.4.4 字典的常用方法
clear() 	# 清空字典
dict4.clear()
get()		# 根据key来获取value
dict4.get('语文')
update()	# 使用key来更新value
dict4.update('语文': 99)
items()		# 获取字典中的所有key-value
keys()		# 获取字典中所有的key
values()	# 获取字典中所有的value
pop()		# 获取指定key的value，并删除这个key-value对
setdefault()	# 如果key-value不存在，先为key设置一个默认的value,再返回该key的value，如果该key存在，则直接返回value
fromkeys()	# 

# 003.4.5 使用字典格式化字符串
temp = '书名是: %(name)s, 价格是: %(price)010.2f, 出版社是: %(publish)s'
book = {'name': '疯狂Python讲义', 'price': 88.9, 'publish': '电子社'}
print(temp % book)
