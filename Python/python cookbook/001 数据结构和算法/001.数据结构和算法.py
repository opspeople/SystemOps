001.解压序列赋值给多个变量
>>> p = (4, 5)
>>> x, y = p
>>> x
4
>>> y
5

>>> data = ['ACME', 50 , 91.1 , (2020, 8 ,31)]
>>> name, shares, price, (year, mon, date) = data
>>> name
'ACME'
>>> year
2020
>>> mon
8
>>> date
21

002.解压可迭代对象赋值给多个变量 *

def drop_first_last(grades):
	first, *middle, last = grades
	return avg(middle)

>>> record = ('Dave', 'dave@example.com', '773-555-1212', '847-555-1212')
>>> name, email, *phone_numbers = record
>>> name
'Dave'
>>> phone_numbers
['773-555-1212', '847-555-1212']
# 字符串分割
>>> line = 'nobody:*:-2:-2:Unprivileged User:/var/empty:/usr/bin/false'
>>> uname, *fields, homedir, sh = line.split(':')
>>> uname
'nobody'
>>> sh
'/usr/bin/false'

003.保留最后N个元素
# collection.deque类
from collection import deque 
>>> q.deque(maxlen=3)
>>> q.append(1)
>>> q.append(2)
>>> q.append(3)
>>> q
deque([1, 2, 3], maxlen=3)
>>> q.append(4)
>>> q
deque([2, 3, 4], maxlen=3)

# 如果不设置maxlen，就会得到一个无限大小的队列

004.查找最大或最小的N个元素
# heapq模块的两个函数 nlargest()和nsmallest()
import heapq 
nums = [1, 8, 2, 23, 7, -4, 18, 23, 42, 37, 2]
print(heapq.nlargest(3, nums))
print(heapq.nsmallest(3, nums))

005.实现一个优先级队列

006.字典中的键映射多个值
d = {
	'a': [1, 2, 3],
	'b': [4, 5],
	'c': {1, 3, 5},
	'd': {4, 5}
}