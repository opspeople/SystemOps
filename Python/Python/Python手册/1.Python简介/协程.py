# 函数运行时要使用单一的一组输入参数。但是，函数也可以编写一个任务程序，用来处理发送给它的一系列输入，这类函数被称为协程。

def print_matches(matchtext):
	print "Looking for", matchtext
	while True:
		line = (yield) 	# 获得一行文本
		if matchtext in line:
			print line
		