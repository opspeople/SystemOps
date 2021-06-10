# 数据库API定义了一组用于连接数据库服务器、执行SQL查询并获取结果的高级函数和对象。
# 其中主要的两个对象：
	# 1.用于管理数据库连接的Connection对象
	# 2.用于执行查询的Cursor对象

# 1.连接
connect(dsn='hostname:dbname', user='username', password='password')
