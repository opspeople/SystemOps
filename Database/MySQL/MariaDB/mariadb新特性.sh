# mariadb新特性.sh
1.性能提升
	MySQL5.7是5.6的3倍

2.安全性提升
	默认开启SSL
		该功能只在MySQL5.7和Percona5.7版本里支持，在启动的时候，使用OpenSSL可以自动生成SSL和RSA证书和密钥文件。

		SSL Secure Socket Layer
		TLS Transport Layer Security

	MySQL5.7配置SSL
		groupadd mysql
		useradd -g mysql mysql
		cd /usr/local
		tar -zxf mysql-5.7.10-linux-glibc2.5-x86_64.tar.gz
		ln -s mysql-5.7.10-linux-glibc2.5-x86_64 mysql
		chown -R mysql:mysql mysql
		安装mysql
		bin/mysqld --initialize --user=mysql --basedir=/usr/mysql --datadir=/data/mysql 

		获取mysql初始密码：
			grep temporary /var/log/mysql.log

		开启ssl加密：
			bin/mysql_ssl_rsa_setup

		将数据目录属性改为mysql
			chown -R mysql:mysql /data 

		启动MySQL
			bin/mysqld_safe --user=mysql &
		第一次登陆需要修改密码：
			mysql> set password=password('Test2020,./');

		如果不想每次都输入密码，MySQL5.6/5.7版本里提供了mysql_config_editor工具
		用于用户安全认证：
			shell>mysql_config_editor set --login-path=client --host=localhost --user=root --password
			Enter password: 输入密码
			shell> cat .mylogin.cnf 
			'乱码'
			在该用户目录下会生成一个隐藏文件.mylogin.cnf
			shell>mysql --login-path=client # 进行免密登陆

		创建用户的时候，需要指定该用户通过SSL连接，可以通过命令：
			grant all privileges on *.* to 'ssluser'@'%' identified by 'Test2020,./' require ssl;

	不再明文显示用户密码
		加密版本MySQL5.6/5.7和Percona5.6/5.7版本里支持。 
		Mariadb10.1对于binlog中和用户密码相关的操作是不加密的。

	sql_mode的改变
		MySQL5.7/Mariadb10.1中，默认启用STRICT_TRANC_TABLES严格模式。
		严格模式：
			用于进行数据的严格校验，错误数据不能插入，报error错，并且事务回滚
		mysql> set sql_mode=''; # 不进行数据校验，错误也能插入
		mysql> set sql_mode="STRICT_TRANC_TABLES"; # 进行数据校验，错误数据不能插入

	InnoDB存储引擎的提升
		更改索引名字不会锁表 只在MySQL5.7和Percona5.7里支持

		在线DDL修改varchar字段属性时不锁表

		InnoDB/MyISAM存储引擎支持中文全文索引

		InnoDB Buffer Pool预热改进
			该功能只支持MySQL5.7和Percona5.7版本。 
			在MySQL重启时，将之前频繁访问的数据重新加载回Buffer中。
			在my.cnf中添加如下配置即可：
				innodb_buffer_pool_dump_at_shutdown = 1
				# 在关闭时将数据dump到贝蒂磁盘
				innodb_buffer_pool_dump_now = 1
				# 采用手工方式将热数据dump到本地

				innodb_buffer_pool_load_at_startup = 1
				# 在启动时将数据加载到内存
				innodb_buffer_pool_load_now = 1 
				# 手工将热数据加载到内存

			# 只有机器正常关闭mysql或pkill mysql时，才会把热数据dump到内存，机器宕机或者pkill -9 mysql，是不会dump的

		在线调整innodb_buffer_pool_size不重启MySQL进程
			在MySQL5.7里支持 
			# 注意：调整的过程中，用户的请求会阻塞，在业务低峰期调整
			> show variables like 'innodb_buffer_pool_size'; # 查看大小
			> set global innodb_buffer_pool_size = 256*1024*1024;
			调整时，内部会把数据页移动到一个新的位置，单位是块。如果想提升移动的速度，则需要调整innodb_buffer_pool_chunk_size参数的大小，默认是128MB
			innodb_buffer_pool_chunk_size大小的计算公式是：innodb_buffer_pool_size/innodb_buffer_pool_instances
			若innodb_buffer_pool_size为2GB，innodb_buffer_pool_instances实例为4个，系统自动会把innodb_buffer_pool_chunk_size调整为512MB

		回收(收缩)undo log回滚日志物理文件空间
			undo log回滚日志是保存在共享表空间ibdata1文件里的，随着业务的不停运转，ibdata1文件会越来越大，想要回收极其困难和复杂，
			必须先将mysqldump -A全库数据导出，然后删掉data目录，之后重新初始化安装，最后再把全库的SQL文件导入，这样才可以实现ibdata1文件的回收。

			MySQL5.7可以实现在线回收
				在安装MySQL时就需要指定，否在等创建数据库以后再指定就会报错
					innodb_undo_directory=/data2/ # 指定存放的目录，默认是数据目录
					innodb_undo_logs=128 # 指定回滚段128kb
					innodb_undo_tablespaces=4 # 指定有多少个undo Log文件


			把Undo Log从共享表空间里ibdata1拆分出去，注意在安装MySQL时，需要再my.cnf里指定，否则等数据库已经启动后再指定，就会报错。
				相关参数解释:
					innodb_undo_log_truncate # 参数设置为1，即开启在线回收(收缩)undo log日志文件，支持动态设置
					innodb_undo_tablespaces # 参数必须设置大于或等于2，即回收(收缩)一个undo log日志文件时，要保证另一个undo log是可用的
					innodb_undo_logs # undo回滚段的数量，至少大于等于35，默认为128
					innodb_max_undo_log_size # 当超过这个阈值（默认是1G）时，会触发truncate回收undolog日志文件，支持动态设置
					innodb_purge_rseg_truncate_frequency # 控制回收undo log的频率，undo log空间在它的回滚段没有得到释放之前不会收缩，
															 # 想要增加释放回滚区间的频率，就得降低innodb_purge_rseg_truncate_frequency设定值

			Innodb提供通用表空间
				共享表空间 把所有表都存放在ibdata1文件里
				通用表空间 可以指定某些表存放在同一个share.ibd文件里

			Innodb独立表空间指定存放路径
				mysql5.6/MySQL5.7 Percona5 Mariadb10.0/10.1

			迁移单独一张Innodb表到远程服务器
				MySQL5.6/5.7、Percona5.6/5.7和Mariadb10.0/10.1支持

			修改Innodb redo log事务日志文件大小更人性化

			死锁可以打印到错误日志里
				innodb_print_all_deadlocks=1

			支持innodb只读事务

			支持innodb表空间数据碎片整理


	4.JSON格式支持
		4.1支持用JSON格式存储数据

		4.2动态列支持用JSON格式存储数据


	5.支持虚拟列
		5.1 MySQL 5.7支持函数索引

		5.2 Mariadb 10.0/10.1支持函数索引

	6.功能提示
		6.1 支持杀死慢的SQL
			Mariadb 10.1和Percona 5.6/5.7支持，MySQL5.7不支持

		6.2 支持一张表有多个insert/delete/updata触发器
			MySQL5.7支持

		6.3 引入线程池(Thread Pool)技术

		6.4 提供审计日志功能

		6.5 支持explain update 

		6.6 在MySQL5.7中按Ctrl+C组合键不会退出客户端

		6.7 可将错误日志打印到系统日志文件中
			/usr/local/mysql/bin/mysqld_safe --defaults-file=/etc/my.cnf --syslog --user=mysql 

		6.8 支持创建角色
			Mariadb 10.0/10.1支持
			mysql> create role develop;
			mysql> grant select,insert,update on *.* to develop;
			mysql> grant develop to 'dev'@'%' identified by '123456';
			# 开启角色
			mysql> set default role develop;
			mysql> set role develop;

		6.9 支持TokuDB存储引擎
			TokuDB是一个insert高性能、支持事务处理的存储引擎。

	7.优化器改进
		7.1 针对子查询select采用半连接优化
			MySQL的子查询一直以来以性能差著称，解决的方案是用关联(join)查询代替子查询。
			半连接子查询优化默认开启，通过语句
			show variables like 'optimizer_switch'\G;来查看

		7.2 优化派生子查询

		7.3 优化排序limit

		7.4 优化in条件表达式

		7.5 优化union all

		7.6 支持索引下推优化

		7.7 支持multi range read索引优化

		7.8 支持batched key access 索引优化

		7.9 支持hash join索引优化

	8.半同步复制改进
		8.1 半同步复制简介
			默认情况下，MySQL5.5/5.6/5.7和Mariadb10.0/10.1的复制功能是异步的，异步复制可以提供最佳的性能，主库吧Binlog日志发送给从库，这一动作就结束了，并不会验证从库是否接受完毕，但这同时也带来了很高的风险，这就意味着当主服务器或从服务器发送故障时，有可能从机没有接受到主机发送过来的Binlog日志，造成主服务器/从服务器的数据不一致，甚至在恢复时造成数据丢失

			半同步复制
				semi replication
				可以确保从服务器接受完主服务器发送的Binlog日志文件并写入自己的中继日志(Relay log)里，然后会给主服务器一个反馈，告诉对方已经接收完毕，这时主库线程才返回给当前session告知操作完成。

		8.2 半同步复制的安装配置
			采用MySQL的二进制版本（官方编译好的版本，无需configure、make、make install等），半同步复制插件在目录/usr/local/mysql/lib/plugin下，
			shell > ll -h semisync_*
			semisync_master.so
			semisync_slave.so
			master配置：
			mysql-master > install plugin rpl_semi_sync_master soname 'semisync_master.so';
			mysql-master > set global rpl_semi_sync_master_enabled=ON;
			mysql-slave > install plugin rpl_semi_sync_slave soname 'semisync_slave.so';
			mysql-slave > set global rpl_semi_sync_slave_enabled=ON;

			在my.cnf的配置中加入如下配置：
			rpl_semi_sync_master_enabled=1
			rpl_semi_sync_slave_enabled=1

		8.3 参数说明
			master主库的4个参数：
				rpl_semi_sync_master_enabled=ON 在主库上开启半同步复制
				rpl_semi_sync_master_timeout=10000 该参数默认为10000毫秒，即10s，这个参数动态可调，用来表示如果主库在某次事务中的等待时间超过10秒，则降级为异步复制模式，不再等待slave从库。如果主库再次探测到slave恢复，则自动再次回到半同步复制模式。