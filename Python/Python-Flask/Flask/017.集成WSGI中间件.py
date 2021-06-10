# 如果想要在应用中添加一个 WSGI 中间件，那么可以包装内部的 WSGI 应用。
# 假设为了 解决 lighttpd 的错误，你要使用一个来自 Werkzeug 包的中间件，那么可以这样做:
from werkzeug.contrib.fixers import LighttpdCGIRootFix
app.wsgi_app = LighttpdCGIRootFix(app.wsgi_app)
