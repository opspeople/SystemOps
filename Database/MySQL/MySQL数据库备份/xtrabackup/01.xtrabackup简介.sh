#!/usr/bin/bash

# Xtrabackup是由percona开源的免费数据库热备份软件，它能对InnoDB数据库和XtraDB存储引擎的数据库非阻塞地备份（对于MyISAM的备份同样需要加表锁）；mysqldump备份方式是采用的逻辑备份，其最大的缺陷是备份和恢复速度较慢，如果数据库大于50G，mysqldump备份就不太适合。
# Xtrabackup优点
	# 1）备份速度快，物理备份可靠

	# 2）备份过程不会打断正在执行的事务（无需锁表）

	# 3）能够基于压缩等功能节约磁盘空间和流量

	# 4）自动备份校验

	# 5）还原速度快

	# 6）可以流传将备份传输到另外一台机器上

	# 7）在不增加服务器负载的情况备份数据

# Xtrabackup备份原理
# 在InnoDB内部会维护一个redo日志文件，我们也可以叫做事务日志文件。事务日志会存储每一个InnoDB表数据的记录修改。
# 当InnoDB启动时，InnoDB会检查数据文件和事务日志，并执行两个步骤：它应用（前滚）已经提交的事务日志到数据文件，
# 并将修改过但没有提交的数据进行回滚操作。
# Xtrabackup在启动时会记住log sequence number（LSN），并且复制所有的数据文件。
# 复制过程需要一些时间，所以这期间如果数据文件有改动，那么将会使数据库处于一个不同的时间点。
# 这时，xtrabackup会运行一个后台进程，用于监视事务日志，并从事务日志复制最新的修改。
# Xtrabackup必须持续的做这个操作，是因为事务日志是会轮转重复的写入，并且事务日志可以被重用。
# 所以xtrabackup自启动开始，就不停的将事务日志中每个数据文件的修改都记录下来。上面就是xtrabackup的备份过程。
# 接下来是准备（prepare）过程。在这个过程中，xtrabackup使用之前复制的事务日志，对各个数据文件执行灾难恢复（就像mysql刚启动时要做的一样）。当这个过程结束后，数据库就可以做恢复还原了。
# 过程是备份---->准备。就是说：先将文件全部复制过来，再根据事务日志对部分操作进行回滚。
# 以上的过程在xtrabackup的编译二进制程序中实现。程序innobackupex可以允许我们备份MyISAM表和frm文件从而增加了便捷和功能。
# Innobackupex会启动xtrabackup，直到xtrabackup复制数据文件后，然后执行FLUSH TABLES WITH READ LOCK来阻止新的写入进来并把MyISAM表数据刷到硬盘上，之后复制MyISAM数据文件，最后释放锁。
# 备份MyISAM和InnoDB表最终会处于一致，在准备（prepare）过程结束后，InnoDB表数据已经前滚到整个备份结束的点，而不是回滚到xtrabackup刚开始时的点。这个时间点与执行FLUSH TABLES WITH READ LOCK的时间点相同，所以myisam表数据与InnoDB表数据是同步的。
# 类似oracle的，InnoDB的prepare过程可以称为recover（恢复），myisam的数据复制过程可以称为restore（还原）。

# xtrabackup的安装：
# 官网下载rpm包或者tar.gz包解压就能用，此外需要通过epel的yum安装依赖包libev
# yum install libev -y
# rpm -ivh percona-xtrabackup-24-2.4.3-1.el6.x86_64.rpm
# rpm包释放的可执行文件如下：
# /usr/bin/innobackupex    # 封装过的perl脚本
# /usr/bin/xbcloud
# /usr/bin/xbcloud_osenv
# /usr/bin/xbcrypt
# /usr/bin/xbstream
# /usr/bin/xtrabackup      # 主程序


# Xtrabackup增量备份介绍
# xtrabackup增量备份的原理是：

	# 1)、首先完成一个完全备份，并记录下此时检查点LSN；

	# 2)、然后增量备份时，比较表空间中每个页的LSN是否大于上次备份的LSN，若是则备份该页并记录当前检查点的LSN。

	# 增量备份优点：

	# 1)、数据库太大没有足够的空间全量备份，增量备份能有效节省空间，并且效率高；

	# 2)、支持热备份，备份过程不锁表（针对InnoDB而言），不阻塞数据库的读写；

	# 3)、每日备份只产生少量数据，也可采用远程备份，节省本地空间；

	# 4)、备份恢复基于文件操作，降低直接对数据库操作风险；

	# 5)、备份效率更高，恢复效率更高。
