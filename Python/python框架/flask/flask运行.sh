1.Linux环境下：
	# export FLASK_APP=一个最小的应用.py
	# flask run
		*Running on http://127.0.0.0:5000/

2.windows下
	2.1 命令行模式
		> set FLASK_APP=一个最小的应用.py
	2.2 PowerShell下
		> $env FLASK_APP=一个最小的应用.py

	运行
		python -m flask run
		* Running on http://127.0.0.1:5000/


注意：让服务器公开被访问
	flask run --host=0.0.0.0


3.调试模式
	虽然 flask 命令可以方便地启动一个本地开发服务器，但是每次应用代码修改之后都需要手动重启服务器。这样不
	是很方便， Flask 可以做得更好。如果你打开调试模式，那么服务器会在修改应用代码之后自动重启，并且当应用
	出错时还会提供一个有用的调试器。

	如果需要打开所有开发功能（包括调试模式），那么要在运行服务器之前导出 FLASK_ENV 环境变量并把其设置为：development 

	$ export FLASK_ENV=development
	$ flask run

	windows下需要使用set来代替export
	这样可以实现以下功能：
		激活调试器
		激活自动重载
		打开flask应用的调试模式

	还可以通过导出 FLASK_DEBUG=1 来单独控制调试模式的开关
	