# Web 应用使用不同的 HTTP 方法处理 URL 
# 缺省情况下，一个路由只回应 GET 请求。
# 可以使用 route() 装饰器的 methods 参数来处理不同的 HTTP 方法:


from flask import request

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        return do_the_login()
    else:
        return show_the_login_form()


静态文件
# 动态的 web 应用也需要静态文件，一般是 CSS 和 JavaScript 文件。
# 只要在你的包或模块旁边创建一个名为 static 的文件夹就行了。 
# 静态文件位于应用的 /static 中。
url_for('static', filename='style.css')