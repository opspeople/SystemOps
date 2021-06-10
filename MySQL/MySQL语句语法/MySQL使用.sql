连接MySQL

mysql -uroot -h localhost -p

查看有哪些数据库
	show databases;

选择数据库
	use databaseName;

查看数据库表
	show tables;

查看数据库表的列信息
	show columns from test_tables; 或者 describe test_tables;

查看服务器信息
	show status;

显示表、库的创建语句
	show create database databaseName;
	show create table test_table;