# 函数在Python中是第一类对象。也就是说可以把它们当作参数传递给其他函数，放在数据结构中，以及作为函数的返回结果。
# foo.py
def callf(func):
	return func()

# 使用此函数
>>> import foo
>>> def helloworld():
		return 'Hello World'


>>> foo.callf(helloworld)
'Hello World'

