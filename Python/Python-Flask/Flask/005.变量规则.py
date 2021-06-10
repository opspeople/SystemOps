
# 通过把 URL 的一部分标记为 <variable_name> 就可以在 URL 中添加变量
# 标记的 部分会作为关键字参数传递给函数
# 通过使用 <converter:variable_name> ，可以 选择性的加上一个转换器，为变量指定规则。

# 转换器类型
string  接受任何不包含斜杠的文本
int 	接受正整数
float	接受正浮点数
path 	类似 string ，但可以包含斜杠
uuid 	接受 UUID 字符串


@app.route('/')
def index():
	return 'Index Page'

@app.route('/hello/<username>')
def hello(username):
	return 'Hello %s!' % escape(username)

@app.route('/num/<int:int_num>')
def number_int(int_num):
	return 'The number is %d.' % int_num

@app.route('/path/<path:subpath>')
def sub_path(subpath):
	return 'The path is %s' % subpath

