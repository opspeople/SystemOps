MariaDB的介绍
	MariaDB是MySQL源代码的一个分支，采用GPL授权许可。

存储引擎
	MariaDB 	MySQL 
	XtraDB 		InnoDB



	Percona XtraDB是InnoDB存储引擎的增强版

MariaDB和MySQL的兼容性
	大多数方面是兼容的
	MariaDB10.0/10.1的GTID复制与MySQL5.6不兼容

MariaDB的新特性
	更多的存储引擎
		MyISAM
		BLACKHOLE
		CSV
		MEMORY
		ARCHIVE
		MERGE
		Aria(增强版的MyISAM)
		XtraDB (增强版的InnoDB)
		FederatedX
		OQGRAPH
		SphinxSE
		IBMDB2I
		TokuDB
		Cassandra
		CONNECT
		SEQUENCE
		Spider
		PBXT

	速度的提升
		MariaDB 5.3 对子查询优化，采用semi join半连接的方式将SQL改写为表关联join
		MariaDB 5.3 引入group commit for the binary log组提交技术，将多个并发提交的事务加入一个队列里，再将这个队列里的事务利用一次I/O合并提交，解决写日志时频繁刷磁盘的问题
		MariaDB 10.0 版本里引入基于表的多线程并行复制技术，如果主库上1秒内有10个事务，那么合并一个I/O提交，并在binlog里增加一个cid=xx标记，当cid的值一样时，Slave就可以进行并行复制，通过设置多个sql_thread线程实现。MySQL 5.5 是单进程串行复制；MySQL 5.6 是基于库级别的并行复制；MySQL 5.7 是基于表级别的并行复制。
		MariaDB 5.5 引入线程池thread pool技术，线程池的连接复用减少了建立连接的开销，减少了CPU上下文切换，适合高并发场景。
		处理内部的临时表时，MariaDB用Aria引擎代替了MyISAM引擎，这会使某些GROUP BY和DISTINCT请求速度更快，因为Aria有比MyISAM更好的缓存机制。

	扩展和新功能
		1.时间精确到微妙级别
		2.提供了虚拟列
		3.kill命令扩展
			MariaDB 5.3 版本里对kill命令进行了扩展，可以指定某个user用户，杀死所有查询
		4.修改表结构可显示执行进度
		5.提供了动态列（可以存储JSON格式）

	MariaDB 10.0 版本显著特点
		提供多源复制，但直到MySQL 5.7 才支持
		支持GTID同步复制
		创建用户支持创建角色权限通过show processlist可以查看内存占用
		执行 create or replace table ，等于先执行drop操作，在执行create操作
		执行delete from table returning命令，在删除前，可以返回要删除的记录，以便万一失手，可以拿到原始数据
		慢查询 slow log 日志里增加了explain执行计划
			# 在my.cnf 里添加代码：
			log-slow-verbosity = query_plan, explain
			# 结果会在慢查询日志把计划也打印出来，以方便排查问题

MySQL迁移至MariaDB
	1.卸载MySQL
	2.安装MariaDB
	3.启动MariaDB
	4.使用命令mysql_upgrade升级即可

	当处理内部的临时表时，MariaDB 5.5 10.0 用Aria引擎代替MyISAM引擎，MariaDB 10.1 可以通过设置参数 default_tmp_storage_engine=InnoDB作为内部临时表存储引擎，这将使某些GROUP BY 和 DISTINCT请求更快速，因为Aria有比MyISAM更好的缓存机制。
	如果临时表很多，则要增加aria_pagecache_buffer_size参数的值（缓存数据和索引），默认为128MB（而不是tmp_table_size参数）。
	如果没有MyISAM表，那么建议吧key_buffer_size调低，而且要调的非常低，例如64kB，仅提供给MySQL库中的系统表使用

Aira 
	Aria是早期MariaDB版本的默认存储引擎，自2007年以来，一直在开发，当前版本Aria 1.5 ，下个版本 2.0.
	Aria引擎前身为Maria，后来怕和MariaDB数据库搞混淆，又重新命名，是增强版MyISAM，解决了MyISAM崩溃安全恢复问题，也就是说，mysqld进程崩溃后，Aria将恢复所有表。
	不支持事务


MariaDB 10.1 企业版 安装 
> groupadd mysql 
> useradd mysql 
> cd /usr/local
> tar -zxvf mariadb-enterprise-10.1.10-linux-x86_64.tar.gz
> ln -s mariadb-enterprise-10.1.10-linux-x86_64 mysql 
> chown -R mysql.mysql mysql 
> scripts/mysql_install_db --user=mysql
> chown -R mysql.mysql /data 
> bin/mysqld-safe --defaults-file=/etc/my.cnf --user=mysql &

官方推荐使用jemalloc内存管理器获取更好的性能
yum -y install jemalloc*
添加配置
[mysqld_safe]
malloc-lig = /usr/lib64/libjemalloc.so 
