从文件读取内容
f = open("foo.txt")
line = f.readline()
while line:
	print line,
	line = f.readline()

f.close()

输入内容到文件
f.open("out","w")
while year <= numyears:
	principal = principal * (1 + rate)
	print >>f,"%3d %0.2f" % (year, principal)
	year += 1
f.close()


# >> 语法只能在Python2中用
python3中使用如下语句：
print("%3d %0.2f" % (year, principal), file=f)
