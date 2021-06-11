from flask import Flask,escape,url_for,request 


app = Flask(__name__)
############################################## 路由
# 路由 /
@app.route('/')
def hello_world():
	return 'Hello,World!'

# 路由 /index
@app.route('/index')
def index():
	return 'This is a test index.'

############################################### 变量规则：
# 通过把 URL 的一部分标记为 <variable_name> 就可以在 URL 中添加变量
#@app.route('/user/<username>')
def show_user_profile(username):
	# show the user name profile for that user
	return 'User %s' % escape(username)

@app.route('/post/<int:post_id>')
def show_post(post_id):
	# show the post with the given id,the id is an integer
	return 'Post %d' % post_id

@app.route('/path/<path:subpath>')
def show_subpath(subpath):
	# show the subpath after /path/
	return 'Subpath %s' % escape(subpath)

	# 变量规则之转换器类型：
		# string	缺省值，接受任何不包含斜杠的文本
		# int 	正整数
		# float 	正浮点数
		# path 	类似string，但可以包含斜杠
		# uuid 	接受UUID字符串

################################################ 唯一的URL / 重定向行为
@app.route('/projects/')
def projects():
	return 'Theproject page'

@app.route('/about')
def about():
	return 'The about page'

# 访问projects 尾部有一个斜杠，看起来就如同一个文件夹。访问一个没有斜杠结尾的 URL 时
# Flask 会自动进行重定向，帮你在尾部加上一个斜杠
# 访问about如果在结尾加一个斜杠会报404的错。

################################################ URL构建
# url_for()函数用于构建指定函数的URL。它把函数名称作为第一个参数。它可以接受任意个关键字参数，每个关
# 键字参数对应 URL 中的变量。未知变量将添加到 URL 中作为查询参数。
@app.route('/login')
def login():
	return 'login'

@app.route('/user/<username1>')
def profile(username1):
	return '{}\'s profile'.format(escape(username1))

with app.test_request_context():
	print(url_for('index'))
	print(url_for('login'))
	print(url_for('login', next='/'))
	print(url_for('profile', username1='xuhua'))

#################################################### HTTP方法
# from flask import request
# Web 应用使用不同的 HTTP 方法处理 URL。当你使用 Flask 时，应当熟悉 HTTP 方法。
# 缺省情况下，一个路由。只回应 GET 请求。可以使用 route() 装饰器的 methods 参数来处理不同的HTTP 方法:
# @app.route('/login',method=['GET', 'POST'])
# def login():
# 	if request.method == 'POST':
# 		return do_the_login()
# 	else:
# 		return show_the_login_form()

# 如果当前使用了 GET 方法， Flask 会自动添加 HEAD 方法支持，并且同时还会按照 HTTP RFC 来处理HEAD 请求

#################################################### 静态文件
# 动态的 web 应用也需要静态文件，一般是 CSS 和 JavaScript 文件
# 理想情况下你的服务器已经配置好了为你
# 但是在开发过程中， Flask 也能做好这项工作
# 只要在你的包或模块旁边创建一个名为
# static 的文件夹就行了。静态文件位于应用的 /static 中。

# 使用特定的 'static' 端点就可以生成相应的 URL
# url_for('static', filename='style.css')

################################################### 渲染模板
# 在 Python 内部生成 HTML 不好玩，且相当笨拙。因为你必须自己负责 HTML 转义，以确保应用的安全。
# 因此，Flask 自动为你配置Jinja2 模板引擎。
# 使用 render_template() 方法可以渲染模板，你只要提供模板名称和需要作为参数传递给模板的变量就行了
# from flask import render_template
@app.route('/hello')
@app.route('/hello/<name>')
def hello(name=None):
	return render_template('hello.html', name=name)

###################################################