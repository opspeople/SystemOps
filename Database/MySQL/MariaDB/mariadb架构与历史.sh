# 1.mariadb介绍.sh

			mariadb 			MySQL
存储引擎		XtraDB				InnoDB 			

XtraDB是InnoDB的增强版，在mariadb数据库中新建InnoDB表会默认转换为XtraDB表

MariaDB 
# > show engines; 		# 查看引擎

# > select version();		# 查看版本

MariaDB集成了更多的存储引擎：
	Aria
	SphinxSE
	TokuDB
	Cassandra
	CONNECT
	SEQUENCE
	Spider
	等

MariaDB速度的提升
	1.查询优化，采用semi join半连接方式将SQL改写为表关联join,提高了查询速度
	2.Mariadb5.3版本里引入group commit for the binary log组提交技术，
		将多个并发提交的事务放到一个队列里面，再将这个队列里的事务利用一次I/O合并提交，
		从而解决写日志时频繁刷磁盘的问题
	3.MariaDB 10.0版本里引入基于表的多线程并行复制技术，如果主库上1秒内有10多个事务，
		那么合并一个I/O提交一次，并在binlog里增加一个cid=XX标记，当cid的值一样时，
		slave就可以进行并行复制，通过设置多个sql_thread现场实现。
	4.MariaDB 5.5 引入线程池thread pool的技术，线程池的连接复用减少了建立连接的开销，减少了CPU上下文切换
		，非常适合高并发php短连接的应用场景
	5.处理临时表时，Mariadb用Aria引擎代理了MyISAM引擎，这会使某些GROUP BY和DISTINCT请求速度更快
		Aria有比MyISAM更好的缓存机制。

MariaDB新功能
	1.时间精确到微妙级别
	2.提供了虚拟列
	3.kill命令扩展
		> show processlist;
		> kill user root;
		> show processlist;
	4.修改表结构可显示执行进度
	5.提供了动态列（可以存储json格式）

MariaDB的显著特点
	提供多源复制
	支持GTID同步复制
	创建用户支持创建角色(role)权限
	通过> show processlist 查看内存占用
	执行create or replace table，等于先执行drop操作，再执行create操作，
	执行delete from table returning命令，在删除前，可以返回要删除的记录，以便万一失手，可以拿到原始数据
	慢查询日志(show log)里增加了explain执行计划
		在my.cnf里添加代码：
			log-slow-verbosity = query_plan,explain

将MySQL迁移至mariadb
	1.卸载MySQL
	2.用mariadb启动
	3.通过mysql_upgrade命令升级即可完成

