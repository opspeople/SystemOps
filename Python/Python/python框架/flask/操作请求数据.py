from flask import request

###########################   本地环境
with app.test_request_context('/hello', method = 'POST'):
	assert request.path == '/hello'
	assert request.method == 'POST'

# 另一种方式是把整个wsgi环境传递给request_context()方法：
with app.request_context(environ):
	assert request.method == 'POST'

########################### 请求对象
@app.route('/login', method=['POST', 'GET'])
def login():
	error = None
	if request.method == 'POST':
		if valid_login(request.form['username'], request.form['password']):
			return log_the_user_in(request.form['username'])
		else:
			error = 'Invalid username/password'
	return render_template('login.html',error=error)


########################## 文件上传
# 用 Flask 处理文件上传很容易，只要确保不要忘记在你的 HTML 表单中设置 enctype="multipart/form-data" 属性
# 就可以了。否则浏览器将不会传送你的文件
from flask import request 
@app.route('/upload',method=['POST','GET'])
def upload_file():
	if request.method == 'POST':
		f = request.files['the_file']
		f.save('/var/www/uploads/uploaded_file.txt')
		...

# 如果想要知道文件上传之前其在客户端系统中的名称，可以使用 filename 属性。
# 。如果想要把客户端的文件名作为服务器上的文件名，可以通过 Werkzeug 提供
# 的 secure_filename() 函数:

from flask import request
from Werkzeug.utils import secure_filename

@app.route('/upload', method = ['GET', 'POST'])
def upload_file():
	if request.method == 'POST':
		f = request.files['the_file']
		f.save('/var/www/uploads' + secure_filename(f.filename))
		...

############################################ cookies
# 要访问 cookies ，可以使用 cookies 属性
# 可以使用响应对象 的 set_cookie 方法来设置 cookies 。请
# 求对象的 cookies 属性是一个包含了客户端传输的所有 cookies的字典。在 Flask 中，如果使用 会话 ，那么
# 就不要直接使用 cookies，因为 会话 比较安全一些
from flask import request
@app.route('/')
def index():
	# 读取cookies
	username = request.cookies.get('username')

# 存储cookies
@app.route('/')
def index():
	resp = make_response(rander_template(...))
	resp.set_cookie('username', 'the username')
	return resp

########################################### 重定向和错误
# 使用 redirect() 函数可以重定向。使用 abort() 可以更早退出请求，并返回错误代码:
@app.route('/')
def index():
	return redirect(url_for('login'))

@app.route('/login')
def login():
	abort(401)
	this_is_never_excuted()

# 缺省情况下每种出错代码都会对应显示一个黑白的出错页面。使用 errorhandler() 装饰器可以定制出错页面
@app.errorhandler(404)
def page_not_found(error):
	return render_template('page_not_found.html'),404

################################# 关于相应
# 如果视图返回的是一个响应对象，那么就直接返回它。
# 如果返回的是一个字符串，那么根据这个字符串和缺省参数生成一个用于返回的响应对象。
# 如果返回的是一个字典，那么调用 jsonify 创建一个响应对象。
# 如果返回的是一个元组，那么元组中的项目可以提供额外的信息。元组中必须至少包含一个项目，且项目应当由
# (response, status) 、 (response, headers) 或者 (response, status, headers) 组成。 status 的值
# 会重载状态代码， headers 是一个由额外头部值组成的列表或字典。
# 如果以上都不是，那么 Flask 会假定返回值是一个有效的 WSGI 应用并把它转换为一个响应对象。
# 如果想要在视图内部掌控响应对象的结果，那么可以使用 make_response() 函数。
@app.errorhandler(404)
def not_found(error):
	return render_template('error.html'), 404

# 使用make_respone()包裹返回表达式，获得相应对象，并对该对象进行修改，然后再返回：
@app.errorhandler(404)
def not_found(error):
	resp = make_response(render_template('error.html'), 404)
	resp.headers['X-Somthing'] = 'A value'
	return resp

######################################## JSON格式的API
# JSON 格式的响应是常见的，用 Flask 写这样的 API 是很容易上手的。如果从视图返回一个 dict ，那么它会
# 被转换为一个 JSON 响应。
@app.route('/me')
def me_api():
	user = get_current_user()
	return {"username": user.username,
			"theme": user.theme,
			"image": url_for("user_image", filename = user.image),
	}

@app.route('/users')
def users_api():
	users = get_all_users()
	return jsonify([user.to_json() for user in users])

################################### 会话
# 除了请求对象之外还有一种称为 session 的对象，允许你在不同请求之间储存信息。
# 这个对象相当于用密钥签名加密的 cookie ，即用户可以查看你的cookie ，但是如果没有密钥就无法修改它。
# 使用会话之前你必须设置一个密钥。举例说明:
from flask import Flask, session, redirect, url_for, escape, request
app = Flask(__name__)

# Set the secret key to some random bytes. Keep this really secret!
app.secret_key = b'_5#y2L"F4Q8z\n\xec]/'

@app.route('/')
def index():
	if 'username' in session:
		return 'Logged in as %s' % escape(session['username'])
	return 'You are not logged in'

@app.route('/login', methods=['GET', 'POST'])
def login():
	if request.method == 'POST':
		session['username'] = request.form['username']
		return redirect(url_for('index'))
	return '''
		<form method="post">
			<p><input type=text name=username>
			<p><input type=submit value=Login>
		</form>
	'''

@app.route('/logout')
def logout():
	# remove the username from the session if it's there
	session.pop('username', None)
	return redirect(url_for('index'))

# 生成cookies
$ python -c 'import os; print(os.urandom(16))'
b'cookies-key'

############################### 消息闪现
# flash() 用于闪现一个消息。在模板中，使用 get_flashed_messages() 来操作消息。

##############################  日志
app.logger.debug('A value for debugging')
app.logger.warning('A warning occurred (%d apples)', 42)
app.logger.error('An error occurred')

############################ 集成WSGI中间件
from werkzeug.contrib.fixers import LighttpdCGIRootFix
app.wsgi_app = LighttpdCGIRootFix(app.wsgi_app)

############################# 使用flask扩展
# 扩展是帮助完成公共任务的包。例如 Flask-SQLAlchemy 为在 Flask 中轻松使用SQLAlchemy 提供支持。

