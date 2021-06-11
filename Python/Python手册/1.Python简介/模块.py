# 模块1 div.py
def divide(a,b):
	q = a/b
	r = a - q*b
	return (q,r)

# 导入模块
import div
a, b = div.divide(2305, 29)
