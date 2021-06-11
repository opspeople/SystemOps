# 传递参数
a = [1, 2, 3, 4, 5]
def square(items):
	for i,x in enumerate(items):
		items[i] = x * x

square(a)

# 返回值
def factor(a):
	d = 2
	while (d <= (a / 2)):
		if ((a  / d) * d == a):
			return ((a / d), d)
		d = d + 1
	return (a, 1)

x, y = factor(1234)

