# 一个 Flask 应用是一个 Flask 类的实例。应用的所有东西（例如配置和 URL ）都会和这个实例一起注册。
# 创建一个 Flask 应用最粗暴直接的方法是在代码的最开始创建一个全局 Flask 实例。
# 可以在一个函数内部创建 Flask 实例来代替创建全局实例。这个函数被称为 应用工厂 。所有应用相关的配置、
# 注册和其他设置都会在函数内部完成，然后返回这个应用。

############################### 应用工厂
import os
from flask import Flask

def create_app(test_conifg=None):
	# create and configure the app
	app = Flask(__name__, instance_relative_config = True)
	app.config.from_mapping(
		SECRET_KEY='dev',
		DATABASE=os.path.join(app.instance_path, 'flask-project.sqlite'),
	)

	if test_conifg is None:
		# load the instance config, if it exists, when not testing
		app.config.from_mapping('config.py', silent=True)
	else:
		# load the test config if passed in
		app.config.from_mapping(test_config)

	# ensure the instance folder exists
	try:
		os.makedirs(app.instance_path)
	except OSError:
		pass

	# a simple page that says hello
	@app.route('/hello')
	def hello():
		return 'Hello,world!'

	return app

