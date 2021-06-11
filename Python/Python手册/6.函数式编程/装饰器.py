# 装饰器是一个函数，其主要用途是包装另一个函数或类
@trace
def square(x):
	return x*x

# 上面代码简化：
def square(x):
	return x*x
square = trace(square)