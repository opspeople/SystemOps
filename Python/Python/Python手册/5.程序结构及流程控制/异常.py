try:
	f = open('foo')
execpt IOError as e:
	statementes


try:
	f = open('foo')
execpt IOError as e:
	statementes
execpt TypeError as e:
	statementes
	...


使用pass忽略异常
try :
	do something
execpt IOError:
	pass # 不做任何处理

# 所有内置异常


# 自定义异常
class NetworkError(Exception): pass
# 使用自定义异常
raise NetworkError("Cannot find host.")
