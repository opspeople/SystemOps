# 将函数的第一条语句写成文档字符串，用于描述函数的用途
def factorial(n):
	"""
		help
	"""
	if n <= 1: return 1
else: return n*factorial(n-1)
