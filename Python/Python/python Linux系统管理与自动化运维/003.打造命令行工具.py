# 1.使用sys.argv获取命令行参数
# sys库下有一个名为argv的列表，该列表保存了所有的命令行参数
# 第一个元素是命令行程序的名称，其余的命令行参数以字符串的形式保存在列表中

#!/usr/bin/python3

import sys

arg_list=[]
arg_list=sys.argv

print(arg_list)

$ python3 args.py arg1 arg2
['args.py', 'arg1', 'arg2']

# 遍历其中的参数
for x in arg_list:
    print(x)

# 2.使用sys.stdin和input读取标准输入
# 2.1 input读取命令行输入
import sys

word = input('please input one or more word\n')
print(word)

# 2.2 sys.stdin.readline()
print('please input one or more word\n')
word = sys.stdin.readline()

# 2.3 sys.stdin.readlines()
for line in sys.stdin.readlines():
    if not line:
        bread
    else:
        print(line)

# 2.4 fileinput 
# fileinput 中常用的方法：
# filename
# fileno 文件的描述符
# filelineno 正在读取的行是当前文件的第几行
# isfirstline 正在读取的行是否是当前文件的第一行
# isstdin fileinput 正在读取的文件还是直接从标准输入读取内容
import fileinput 

for line in fileinput.input('file.txt'):
    print(line)

fileinput.close()

# 2.5 使用SystemExit异常打印错误信息
import sys
sys.stdout.write('hello')
sys.stderr.write('world')
sys.exit(1)

python3 test_stdout_stderr.py > /dev/null
python3 test_stdout_stderr.py 2> /dev/null

# 2.6 使用getpass库读取密码
import getpass

user=getpass.getuser()
passwd = getpass.getpass('your password: ')
print(user, passwd)

# 3.2 使用configparser解析配置文件
cat /etc/my.cnf
[client]
port = 3306
user = mysql
password = mysql 
host = 127.0.0.1
[mysqld]
basedir = /usr 
datadir = /var/lib/mysql
tmpdir = /tmp
skip-external-locking

import ConfigParser

cf = ConfigParser.ConfigParser(allow_no_value=True)
cf.read('my.cnf')
# ConfigParser中的许多方法，与读取配置文件，判断配置项相关的方法有：
cf.sections() # 返回一个包含所有章节的列表
cf.has_section() # 判断章节是否存在
cf.has_option() # 判断某个选项是否存在
cf.items() # 以元组形式返回所有选项
cf.options() # 返回一个包含章节下所有选项的列表
cf.get()、cf.getboolean()、cf.getint()、cf.getfloat() # 获取选项的值

# 3.3 使用argparse解析命令行参数
import argparse
parser = argparse.ArgumentParser() # 创建一个解析器
# 为应用程序添加参数选项需要用ArgumentParser对象的add_argument方法，方法原型为：
add_argument(name or flags ...[, action][, nargs][, const][, default][, type][, choices][, required][, help][, metavar][, dest])

def _argarse():
	parser = argparse.ArgumentParser(description="This is description")
	parser.add_argument('--host', action='store', 
		dest='server', default="localhost", help="connect to host")
	parser.add_argument('-t', action='store_true',
		default=False, dest='boolean_switch', help="Set a switch to true")
	return parser.parser_args()

def main():
	parser = _argarse()
	print(parser)
	print('host = ', parser.server)
	print('boolean_switch =', parser.boolean_switch)

if __name__ == '__main__':
	main()
# 使用argparse 进行参数解析，它能够根据我们的选项定义自动生成帮组信息。

# 3.4 使用logging记录日志
import logging
# 日志级别
CRITICAL 	50 	严重错误，表明程序已经不能继续运行了
ERROR 		40	发生了严重的错误，必须马上处理
WARNING 	30 	程序可以容忍这些信息，软件还在正常工作，应该及时修复
INFO 		20 	事情按预期工作，突出强调应用程序的运行过程
DEBUG		10 	详细信息，只有开发人员调试程序时才需要关注的事情

# 配置日志格式：
logging.basicConfig(filename='app.log', level=logging.INFO)

logging.debug('debug message')
logging.info('info message')
logging.warn('warn message')
logging.error('error message')
logging.critical('critical message')

# 高级日志设置
Logger 日志记录器，是应用程序中能直接使用的接口
Handler 日志处理器，用以表明将日志保存到什么地方以及保存多久
Formatter 格式化，用以配置日志的输出格式

logging.basicConfig(level=logging.DEBUG,
	format='%(asctime)s : %(levelname)s : %(message)s',
	filename="app.log")

# 对于复杂的项目将日志配置保存到配置文件中：
cat log.conf 
[loggers]
keys = root

[handlers]
keys = logfile

[formatters]
handlers = logfile

[Logger_root]
...

[Formatter_generic]
format = %(asctime)s : %(levelname)s : %(message)s

logging.config.fileConfig('log.conf')

# 3.5 与命令行相关的开源项目
# 3.5.1 使用click解析命令行参数
pip install click
import click

# click对argparse的主要改进在易用性，使用click分为两个步骤：
# 1）使用@click.command()装饰一个函数，使之成为命令行接口
# 2）使用@click.option()等装饰函数，添加命令行选项
@click.command()
@click.option('--count', default=1, help='Number of greetings.')
@click.option('--name',property='Your name', help='The person to greet.')
def hello(count, name):
	for x in range(count):
		click.echo('Hello %s!' % name)

if __name__ == '__main__':
	hello()

# option常用选项：
default 默认值
help 参数说明
type 类型
prompt 当在命令行中没有输入相应的参数时，会根据prompt提示用户输入
nargs 指定命令行参数接受的值的个数


# 3.5.2 使用prompt_toolkit打造交互式命令行工具
# prompt_toolkit是一个交互式场景的开源库，用来取代开源的readline与curses
pip install prompt_toolkit 

