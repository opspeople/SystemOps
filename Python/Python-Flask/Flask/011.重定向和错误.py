# 使用 redirect() 函数可以重定向。
# 使用 abort() 可以 更早退出请求，并返回错误代码

from flask import abort, redirect, url_for

@app.route('/')
def index():
    return redirect(url_for('login'))

@app.route('/login')
def login():
    abort(401)
    this_is_never_executed()

# 缺省情况下每种出错代码都会对应显示一个黑白的出错页面。
# 使用 errorhandler() 装饰器可以定制出错页面:
from flask import render_template

@app.errorhandler(404)
def page_not_found(error):
    return render_template('page_not_found.html'), 404

# 注意 render_template() 后面的 404 ，这表示页面对就的出错 代码是 404 ，即页面不存在。
# 缺省情况下 200 表示：一切正常。

