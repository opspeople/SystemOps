#!/usr/local/bin/python3
1.flask程序运行，终端会话会显示 stack trace （堆栈跟踪），这会显示堆栈的调用顺序，一直到产生错误的行

2.调试模式
	执行flask程序之前，运行环境变量
	$ export FLASK_DEBUG=1  # Linux
	> set FLASK_DEBUG=1     # windows
	即可

3.自定义错误页面
	使用@errorhandler装饰器来声明一个自定义的错误处理器
	将错误处理程序放入一个新的app/errors.py模块中

from flask import render_template
from app import app, db 

@app.errorhandler(404)
def not_found_error(error):

