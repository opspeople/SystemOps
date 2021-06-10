# 在 Flask 中由全局 对象 request 来提供请求信息。

本地环境
# 通过使用 with 语句 可以绑定一个测试请求，以便于交互。
from flask import request

with app.test_request_context('/hello', method='POST'):
    # now you can do something with the request until the
    # end of the with block, such as basic assertions:
    assert request.path == '/hello'
    assert request.method == 'POST'

# 另一种方式是把整个 WSGI 环境传递给 request_context() 方法
from flask import request

with app.request_context(environ):
    assert request.method == 'POST'


请求对象
from flask import request
# 通过使用 method 属性可以操作当前请求方法，通过使用 form 属性处理表单数据（在 POST 或者 PUT 请求 中传输的数据）
@app.route('/login', methods=['POST', 'GET'])
def login():
    error = None
    if request.method == 'POST':
        if valid_login(request.form['username'],
                       request.form['password']):
            return log_the_user_in(request.form['username'])
        else:
            error = 'Invalid username/password'
    # the code below is executed if the request method
    # was GET or the credentials were invalid
    return render_template('login.html', error=error)

# 要操作 URL （如 ?key=value ）中提交的参数可以使用 args 属性
searchword = request.args.get('key', '')

# 用户可能会改变 URL 导致出现一个 400 请求出错页面，这样降低了用户友好度。
# 因此， 我们推荐使用 get 或通过捕捉 KeyError 来访问 URL 参数

文件上传
# 用 Flask 处理文件上传很容易，只要确保不要忘记在你的 HTML 表单中设置 enctype="multipart/form-data" 属性就可以了。
# 否则浏览器将不会传送你的文件。
# 已上传的文件被储存在内存或文件系统的临时位置。
# 你可以通过请求对象 files 属性来访问上传的文件。
# 每个上传的文件都储存在这个 字典型属性中。
# 这个属性基本和标准 Python file 对象一样，另外多出一个 用于把上传文件保存到服务器的文件系统中的 save() 方法。

from flask import request

@app.route('/upload', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        f = request.files['the_file']
        f.save('/var/www/uploads/uploaded_file.txt')
    ...
# 如果想要知道文件上传之前其在客户端系统中的名称，可以使用 filename 属性。
# 但是请牢记这个值是 可以伪造的，永远不要信任这个值。
# 如果想要把客户端的文件名作为服务器上的文件名， 可以通过 Werkzeug 提供的 secure_filename() 函数:
from flask import request
from werkzeug.utils import secure_filename

@app.route('/upload', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        f = request.files['the_file']
        f.save('/var/www/uploads/' + secure_filename(f.filename))
    ...

Cookies
# 要访问 cookies ，可以使用 cookies 属性。
# 可以使用响应 对象 的 set_cookie 方法来设置 cookies 。
# 请求对象的 cookies 属性是一个包含了客户端传输的所有 cookies 的字典。
# 在 Flask 中，如果使用 会话 ，那么就不要直接使用 cookies ，因为 会话 比较安全一些。
# 读取 cookies:
from flask import request

@app.route('/')
def index():
    username = request.cookies.get('username')
    # use cookies.get(key) instead of cookies[key] to not get a
    # KeyError if the cookie is missing.

# 储存 cookies:
from flask import make_response

@app.route('/')
def index():
    resp = make_response(render_template(...))
    resp.set_cookie('username', 'the username')
    return resp

# 注意， cookies 设置在响应对象上。通常只是从视图函数返回字符串， Flask 会把它们 转换为响应对象。
# 如果你想显式地转换，那么可以使用 make_response() 函数，然后再修改它。
