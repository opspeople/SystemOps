# 内置函数list(s)可将任意可迭代类型转换为列表
list(s)

s.append(x)		# 增加一个元素
s.extend(t) 	# 将一个新列表t追加到s末尾
s.count(x)		# 计算s中出现x的次数
s.index(x, [, start [, stop]])	# 当s[i] == x.start时返回最小的i，可选参数stop用于指定搜索的起始和结束索引
s.insert(i, x)	# 在i除插入一个元素
s.pop([i])		# 返回元素i并从列表中移除它
s.remove(x)		# 搜索x并从s中移除它
s.reverse()		# 颠倒s中所有元素的顺序
s.sort([key [, reverse]])
