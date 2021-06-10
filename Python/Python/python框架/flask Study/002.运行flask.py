#!/usr/local/bin/python3

1.设置FLASK_APP环境变量,告诉Flask如何导入
  Linux下
  	export FLASK_APP=app.py 
  windows下
  	set FLASK_APP=app.py

2.运行flask应用
	# flask run

3.访问
	http://localhost:5000


注意：
	从 1.0 版本开始，Flask允许设置只会在运行flask命令时自动注册生效的环境变量
	要实现这一点，需要安装python-dotenv
	pip install python-dotenv

	此时在项目的根目录下新建一个名为.flaskenv的文件，其内容是：
	FLASK_APP=app.py 

	FLASK_APP 就实现了自动加载