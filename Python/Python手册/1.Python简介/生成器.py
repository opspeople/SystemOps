使用yield语句，可以让函数生成一个结果序列，而不仅仅是一个值，如：
def countdown(n):
	print("Counting down!")
	while n>0:
		yield n # 生成一个值(n)
		n -= 1

# 任何使用yield的函数都称为生成器
# 调用生成器函数将创建一个对象
c == countdown(5)
>>> c.__next__()


for x in countdown(5):
	print x

