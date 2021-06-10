# 使用try和except语句捕捉
try:
	f = open("file.txt", "r")
execpt IOError as e:
	print e
