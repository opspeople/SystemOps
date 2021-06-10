# 视图函数的返回值会自动转换为一个响应对象。
# 如果返回值是一个字符串，那么会被 转换为一个包含作为响应体的字符串、一个 200 OK 出错代码 和一个 text/html 类型的响应对象。
# 如果返回值是一个字典，那么会调用 jsonify() 来产生一个响应。
# 以下是转换的规则：
	# 1.如果视图返回的是一个响应对象，那么就直接返回它。
	# 2.如果返回的是一个字符串，那么根据这个字符串和缺省参数生成一个用于返回的 响应对象。
	# 3.如果返回的是一个字典，那么调用 jsonify 创建一个响应对象。
	# 4.如果返回的是一个元组，那么元组中的项目可以提供额外的信息。
		# 元组中必须至少 包含一个项目，且项目应当由 (response, status) 、 (response, headers) 或者 (response, status, headers) 组成。 
		# status 的值会重载状态代码， headers 是一个由额外头部值组成的列表 或字典。
	# 5.如果以上都不是，那么 Flask 会假定返回值是一个有效的 WSGI 应用并把它转换为 一个响应对象。

# 如果想要在视图内部掌控响应对象的结果，那么可以使用 make_response() 函数。
@app.errorhandler(404)
def not_found(error):
    return render_template('error.html'), 404

# 可以使用 make_response() 包裹返回表达式，获得响应对象，并对该对象 进行修改，然后再返回
@app.errorhandler(404)
def not_found(error):
    resp = make_response(render_template('error.html'), 404)
    resp.headers['X-Something'] = 'A value'
    return resp

