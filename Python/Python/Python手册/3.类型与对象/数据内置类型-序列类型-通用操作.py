# 适用于所有序列的操作和方法
s[j] 		# 返回一个序列的元素
s[i:j]		# 返回一个切片
s[i:j:stride] 	# 返回一个扩展切片
lens(s)		# 序列长度
min(s)		# 序列最小值
max(s)		# 序列最大值
sum(s)		# 序列的和
all(s)		# 检查s中的所有项是否为True
any(s)		# 检查s中的任意向是否为True


# 可变序列的操作
s[j] = v 		# 序列项赋值
s[i:j] = t 		# 切片赋值
s[i:j:stride] = t 	# 扩展切片赋值
del s[i]		# 序列项删除
del s[i:j]		# 切片删除
del s[i:j:stride]	# 扩展切片删除

