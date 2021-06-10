# 1.用户权限简介
# 	当我们创建过数据库用户后，还不能执行任何操作，需要为该用户分配适当的访问权限。
	
#	用户权限也是分级的，可以授予的权限有如下几组：
#	列级别
#	表级别
#	数据库级别
#	全局

#	权限信息存储在 mysql 系统库的 user、db、tables_priv、columns_priv、procs_priv 这几个系统表中
#	user 表：存放用户账户信息以及全局级别（所有数据库）权限
#	tables_priv 表：存放表级别的权限，决定了来自哪些主机的哪些用户可以访问数据库的这个表
#	columns_priv 表：存放列级别的权限，决定了来自哪些主机的哪些用户可以访问数据库表的这个字段
#	procs_priv 表：存放存储过程和函数级别的权限

	权限分类
	    数据类
	        select
	        insert
	        update
	        delete
	    结构类
	        create
	        alter
	        index
	        drop
	        create view
	        show view
	        create routine
	        alter routine
	        execute
	        event
	        trigger
	        create temporary tables 
	    管理类
	        grant option
	        super
	        process
	        file
	        reload
	        shutdown
	        show databases
	        lock tables
	        references
	        replication client
	        replication slave
	        create user
	        create tablespace

# 2.权限管理实战
# 创建用户
create user 'test_user'@'%' identified by 'Test_pass';

# 全局权限
GRANT super,select on *.* to 'test_user'@'%';

# 库权限
GRANT select,insert,update,delete,create,alter,execute on `testdb`.* to 'test_user'@'%';

# 表权限
GRANT select,insert on `testdb`.tb to 'test_user'@'%';

# 列权限
GRANT select (col1), insert (col1, col2) ON `testdb`.mytbl to 'test_user'@'%';

# 刷新权限
flush privileges;

# 查看某个用户的权限
show grants for 'test_user'@'%';

# 回收权限
revoke delete on `testdb`.* from 'test_user'@'%';

# 出于安全考虑，建议遵循以下几个经验原则
#	只授予能满足需要的最小权限，防止用户干坏事。比如用户只是需要查询，那就只给 select 权限就可以了。
#	创建用户的时候限制用户的登录主机，一般是限制成指定 IP 或者内网 IP 段。
#	及时记录各数据库用户权限等信息，以免忘记。
#	若有外部系统调用，应配置只读用户，并且权限要精确到表或视图。
#	定期清理不需要的用户，回收权限或者删除用户。