def receiver():
	print("Ready to receiver")
	while True:
		n = (yield)
		print("Got %s" % n)

# 在函数内，yield语句可以作为表达式使用，出现在赋值运算符的右边
# 使用yield语句的函数称为协程，向函数发送键值时函数将执行。