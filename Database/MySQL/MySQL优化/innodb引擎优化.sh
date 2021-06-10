一、innodb引擎介绍
	innodb该MySQL提供了具有提交，回滚和崩溃恢复能力的事务安全(ACID兼容)存储引擎。

二、innodb参数调优内容
	1.内存利用
	2.日值控制
	3.文件IO分配，空间占用方面
	4.其他参数

	内存利用
		innodb最重要的一个参数
			innodb_buffer_pool_size
			参数用途：
				缓存innodb表的索引，数据，插入数据时的缓冲。

			参数默认值：
				8M

			设置注意事项：
				专用DB服务器可以设置在70~80%。不能动态更改，分配过大，会使swap占用过多，导致MySQL查询特别慢。




参数设置优化：
innodb_buffer_pool_size

> set global innodb_buffer_pool_size=48318382080;
> show variables like '%innodb_buffer_pool_size%';
