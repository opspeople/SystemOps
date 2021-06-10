# url_for() 函数用于构建指定函数的 URL
# 它把函数名称作为第一个参数
# 它可以接受任意个关键字参数，每个关键字参数对应URL中的变量
# 未知变量将添加到URL中作为查询参数

# 为什么不在把 URL 写死在模板中，而要使用反转函数 url_for() 动态构建？
	# 1.反转通常比硬编码 URL 的描述性更好。
	# 2.你可以只在一个地方改变 URL ，而不用到处乱找。
	# 3.URL 创建会为你处理特殊字符的转义和 Unicode 数据，比较直观。
	# 4.生产的路径总是绝对路径，可以避免相对路径产生副作用。
	# 5.如果你的应用是放在 URL 根路径之外的地方（如在 /myapplication 中，不在 / 中）， url_for() 会为你妥善处理。

from flask import Flask, escape, url_for

app = Flask(__name__)

@app.route('/')
def index():
    return 'index'

@app.route('/login')
def login():
    return 'login'

@app.route('/user/<username>')
def profile(username):
    return '{}\'s profile'.format(escape(username))

with app.test_request_context():
    print(url_for('index'))
    print(url_for('login'))
    print(url_for('login', next='/'))
    print(url_for('profile', username='John Doe'))


/
/login
/login?next=/
/user/John%20Doe