# 在 Python 内部生成 HTML 不好玩，且相当笨拙。
# 因为你必须自己负责 HTML 转义， 以确保应用的安全。
# 因此， Flask 自动为你配置 Jinja2 模板引擎。

# 使用 render_template() 方法可以渲染模板，
# 你只要提供模板名称和需要 作为参数传递给模板的变量就行了。


from flask import render_template

@app.route('/hello/')
@app.route('/hello/<name>')
def hello(name=None):
    return render_template('hello.html', name=name)