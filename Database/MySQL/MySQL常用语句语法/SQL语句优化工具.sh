影响数据库的因素：
	服务器硬件
	磁盘IO
	sql查询速度
	网卡流量

1.mysqltuner.pl
	这是mysql一个常用的数据库性能诊断工具，主要检查参数设置的合理性包括日志文件、存储引擎、安全建议及性能分析。针对潜在的问题，给出改进的建议，是mysql优化的好帮手。
	项目地址：https://github.com/major/MySQLTuner-perl
	下载 wget https://raw.githubusercontent.com/major/MySQLTuner-perl/master/mysqltuner.pl
	使用	./mysqltuner.pl --socket /var/lib/mysql/mysql.sock

2.tuning-primer.sh
	这是mysql的另一个优化工具，针于mysql的整体进行一个体检，对潜在的问题，给出优化的建议。
	项目地址：https://github.com/BMDan/tuning-primer.sh
	目前，支持检测和优化建议的内容如下：
		慢查询日志
		最大连接数
		工人线程
		密钥缓冲区[仅限MyISAM]
		查询缓存
		排序缓冲区
		加盟
		临时表
		表缓存
		表锁定
		表扫描[read_buffer][仅限MyISAM]
		InnoDB状态
	下载 wget https://launchpad.net/mysql-tuning-primer/trunk/1.6-r1/+download/tuning-primer.sh
	使用 ./tuning-primer.sh

3.pt-variable-advisor
	pt-variable-advisor 可以分析MySQL变量并就可能出现的问题提出建议
	安装：
		https://www.percona.com/downloads/percona-toolkit/LATEST/
		wget https://www.percona.com/downloads/percona-toolkit/3.0.13/binary/redhat/7/x86_64/percona-toolkit-3.0.13-re85ce15-el7-x86_64-bundle.tar
		yum install percona-toolkit-3.0.13-1.el7.x86_64.rpm
	使用：
		pt-variable-advisor是pt工具集的一个子工具，主要用来诊断你的参数设置是否合理
		pt-variable-advisor localhost --socket /var/lib/mysql/mysql.sock

4.pt-qurey-digest
	pt-query-digest 主要功能是从日志、进程列表和tcpdump分析MySQL查询。
	安装
		具体参考3.1节
	使用
		pt-query-digest主要用来分析mysql的慢日志，与mysqldumpshow工具相比，py-query_digest 工具的分析结果更具体，更完善。
		pt-query-digest /var/lib/mysql/slowtest-slow.log

	常用用法分析
		1）直接分析慢查询文件:
		pt-query-digest /var/lib/mysql/slowtest-slow.log > slow_report.log

		2）分析最近12小时内的查询：
		pt-query-digest --since=12h /var/lib/mysql/slowtest-slow.log > slow_report2.log

		3）分析指定时间范围内的查询：
		pt-query-digest /var/lib/mysql/slowtest-slow.log --since '2017-01-07 09:30:00' --until '2017-01-07 10:00:00' > > slow_report3.log

		4）分析指含有select语句的慢查询
		pt-query-digest --filter '$event->{fingerprint} =~ m/^select/i'/var/lib/mysql/slowtest-slow.log> slow_report4.log
		5）针对某个用户的慢查询
		pt-query-digest --filter '($event->{user} || "") =~ m/^root/i'/var/lib/mysql/slowtest-slow.log> slow_report5.log
		6）查询所有所有的全表扫描或full join的慢查询
		pt-query-digest --filter '(($event->{Full_scan} || "") eq "yes") ||(($event->{Full_join} || "") eq "yes")'/var/lib/mysql/slowtest-slow.log> slow_report6.log
