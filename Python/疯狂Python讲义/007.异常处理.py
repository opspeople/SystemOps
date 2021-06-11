# 7.1 异常概述
# 7.2 异常处理机制
# 7.2.1 使用try ...except捕获异常
try:
	# 业务实现代码
	...
execpt (Error, Error2, ...) as e:
	alert 输入不合法
	goto retry

# 7.2.2 异常类的继承体系
# python异常捕获流程
try:
	statement1
	statement2
except Exception1:
	exception handler statement1
except Exception2:
	exception handler statement2
	...
# 异常捕获的例子
import os
try:
	a = int(sys.argv[1])
	b = int(sys.argv[2])
	c = a / b
except IndexError:
	print("索引错误")
except ValueError:
	print("值错误")
except ArithmeticError:
	print("算术错误")
except Exception:
	print("未知异常")

# 7.2.3 多异常捕获
# Python的一个except块可以捕获多种类型的异常，将多个异常类用圆括号括起来，中间用逗号隔开即可
import sys
try:
	a = int(sys.argv[1])
	b = int(sys.argv[2])
	c = a / b
	print("您输入的两个数相除的结果是： ", c)
except (IndexError, ValueError, ArithmeticError):
	print("程序发生了数组越界、数字格式异常、算术异常之一")
except:
	print("未知异常")

# 7.2.4 访问异常信息
# 如果程序需要在except块中访问异常对象的相关信息，则可通过为异常对象声明变量来实现
# 所有的异常对象都包含了如下几个常用属性和方法：
# args 该属性返回异常的错误编号和描述字符串
# errno 该属性返回异常的错误编号
# strerror 该属性返回异常的描述字符串
# with_traceback() 通过该方法可处理异常的传播轨迹信息
def foo():
	try:
		fis = open("a.txt")
	except Exception as e:
		# 访问异常的错误编号和详细信息
		print(e.args)
		# 访问异常的错误编号
		print(e.errno)
		# 访问异常的详细信息
		print(e.strerror)
foo()

# 7.2.5 else块
# 当程序没有出现异常时，程序会执行else块
s = input('请输入除数：')
try:
	result = 20 / int(s)
	print('20除以%s的结果是: %g' % (s, result))
except ValueError:
	print("值错误，您必须输入数值")
except ArithmeticError:
	print("算术错误，您不能输入0")
else:
	print('没有出现异常')
# 7.2.6 使用finally回收资源
try:
	# 业务实现代码
	...
except SubException as e:
	# 异常处理块
	...
except SubException2 as e:
	# 异常处理块2
	...
else:
	# 正常处理块
finally:
	# 资源回收块
	...

# 7.3 使用raise引发异常
# 当程序出现错误时，系统会自动引发异常。除此之外，Python也允许程序自行引发异常，自行引发异常使用raise语句来完成
# 7.3.1 引发异常
# raise 单独一个raise。该语句引发当前上下文中捕获的异常，或默认引发RunningError异常
# raise异常类 raise后带一个异常类。该语句引发指定异常的默认实例
# raise异常对象 引发指定的异常对象
# 7.3.2 自定义异常
class AuctionException(Exception): pass
# 7.3.3 except和raise同时使用
# 7.3.4 raise不需要参数
# 7.4 Python的异常传播轨迹
# 7.5 异常处理规则
# 7.5.1 不要过度使用异常
# 7.5.2 不要使用过于庞大的try块
# 7.5.3 不要忽略捕获到的异常
