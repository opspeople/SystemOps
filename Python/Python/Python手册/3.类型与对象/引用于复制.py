# 引用
In [10]: a = [1, 2, 3, 4]

In [11]: b = a		# b是对a的引用

In [12]: b[2] = 10

In [13]: a 			# 此时a的值也变了
Out[13]: [1, 2, 10, 4]

# 复制
## 浅复制
In [15]: a = [1, 2, 3, 4]

In [16]: b = list(a)

In [17]: b is a
Out[17]: False

In [18]: b.append(100)

In [19]: a
Out[19]: [1, 2, 3, 4]

In [20]: b
Out[20]: [1, 2, 3, 4, 100]

## 深复制
import copy
a = [1, 2, 3, 4, 5]
b = copy.deepcopy(a)
b[2][0] = -100
