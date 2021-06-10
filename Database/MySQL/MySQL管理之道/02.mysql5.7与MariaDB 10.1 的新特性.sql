1.性能提升
	在OLTP只读模式下，MySQL 5.7 有近100万的QPS（Queries Per Second），比MySQL 5.6 性能高3倍

	官方服务器的硬件配置如下：
		Intel(R)Xeon(R)CPU E7-8890 v3.
		4 sockets x 18 cores-HT(144 CPU threads)
		2.5 Ghz , 512 GB RAM
		Linux kernel 3.16.

2.安全性提升
	默认开启SSL
		MySQL 5.7 和 Percona 5.7 版本支持。在MySQL 5.7 启动的时候，使用OpenSSL可以自动生成SSL和RSA证书和密钥文件。
		安全套接层(Secure Sockets Layer ,SSL ) 及其继任者传输层安全(Transport Layer Security, TLS)是为网络通信提供安全及数据完整性的一种安全协议。TLS与SSL在传输层对网络连接进行加密，用以保障在Internet上传输之安全，利用数据加密技术，可确保数据在网络上之传输过程不会被截取及窃听。
		MySQL 5.7 SSL 的配置与使用方式
			不使用如下安装方式：
				> mysqld_install_db --user=mysql
			使用如下安装方式：
				> mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/data/mysql

			开启SSL加密：
				> mysql_ssl_rsa_setup # 执行完成后会在/data目录下生成.pem后缀文件，这就是SSL连接所需要的文件。

			启动MySQL：
				> mysqld_safe --user=mysql &

			修改root密码：
				set password=password('Newpassword');

			配置免密登陆：
			> mysql_config_editor set --login-path=client --host=localhost --user=root --password
			Enter password: 输入密码
			> mysql --login-path=client
			> mysql 

		创建用户时指定该用户通过SSL连接：
			> grant all privileges on *.* to 'ssluser'@'%' identified by 'Aa123456' REQUIRE SSL;

		使用ssluser用户登陆并验证：
			> mysql -ussluser -h192.168.116.129 -p'Aa123456'

			> show variables like '%ssl%';

	2.不再明文显示用户密码
		MySQL 5.6/5.7 Percona 5.6/5.7版本里支持
		MariaDB 10.1 对于binlog中和用户密码相关的操作是不加密的

		> show binlog events;

	3.sql_mod的改变
		MySQL 5.7/MariaDB 10.1默认启用STRICT_TRANS_TABLES严格模式。该模式为严格模式，用户进行数据的严格校验，错误数据不能插入，报error，并且事务回滚。
		在MySQL 5.6和MariaDB 10.1 中，默认SQL_MODE模式为空。

	4.更改索引名字不会锁表
		只在MySQL 5.7和Percona 5.7支持 
		> alter tables sbtest rename index k to idx_k;

	5.在线DDL修改varchar字段属性时不所报
		MySQL 5.7

	6.InnoDB/MyISAM存储引擎支持中文全文索引
		只在MySQL 5.7和Percona 5.7支持 

	7.InnoDB Buffer Pool预热改进
		MySQL 5.7 Percona 5.7支持
		问题：mysql重启之后，如何将之前频繁访问的数据重新加载回Buffer中？
		为了解决这个问题，提供了一个新特性来快速预热Buffer_Pool缓冲池，只需要在my.cnf中添加如下命令即可：
		innodb_buffer_pool_dump_at_shutdown = 1 # 用户在关闭时把热数据dump到本地磁盘
		innodb_buffer_pool_dump_now = 1 		# 采用手工方式把数据dump到本地磁盘
		innodb_buffer_pool_load_at_startup = 1 	# 启动时把热数据加载到内存
		innodb_buffer_pool_load_now = 1 		# 采用手工方式把热数据加载到内存

		只有正常关闭mysql是才会dump到磁盘

		innodb_buffer_pool_dump_pct 允许DBA控制每个缓冲池最近使用页的百分比来导出，以减缓导出InnoDB Buffer Pool所有页占用过大的磁盘I/O，默认值25.

		MariaDB默认值为100.

	8.在线调整innodb_buffer_pool_size大小不重启MySQL进程
		MySQL 5.7 支持
		> set global innodb_buffer_pool_size = 256*1024*1024;