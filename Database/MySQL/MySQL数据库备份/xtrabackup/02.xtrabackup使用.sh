#!/usr/bin/bash

# 1.完全备份
innobackupex --user=dbuser --password=dbpassword /path/to/backup/dir/
# 生成的是一个以当前日期命名的文件夹
# 创建最小权限的备份用户
> grant process,reload,lock tables,replication client on *.* to 'backupuser'@'localhost' identified by 'Aa123456';
> flush privileges;
# 使用innobakupex备份时，其会调用xtrabackup备份所有的InnoDB表，复制所有关于表结构定义的相关文件(.frm)、以及MyISAM、MERGE、CSV和ARCHIVE表的相关文件，同时还会备份触发器和数据库配置信息相关的文件。这些文件会被保存至一个以时间命名的目录中。

# 在备份的同时，innobackupex还会在备份目录中创建如下文件：
	# (1)xtrabackup_checkpoints —— 备份类型（如完全或增量）、备份状态（如是否已经为prepared状态）和LSN(日志序列号)范围信息； 4
	# 每个InnoDB页(通常为16k大小)都会包含一个日志序列号，即LSN。LSN是整个数据库系统的系统版本号，每个页面相关的LSN能够表明此页面最近是如何发生改变的。
	# (2)xtrabackup_binlog_info:mysql服务器当前正在使用的二进制日志文件及至备份这一刻为止二进制日志事件的位置。
	# (3)xtrabackup_binlog_pos_innodb:二进制日志文件及用于InnoDB或XtraDB表的二进制日志文件的当前position。
	# (4)xtrabackup_binary:备份中用到的xtrabackup的可执行文件；
	# (5)backup-my.cnf:备份命令用到的配置选项信息；
	# 在使用innobackupex进行备份时，还可以使用--no-timestamp选项来阻止命令自动创建一个以时间命名的目录；如此一来，innobackupex命令将会创建一个BACKUP-DIR目录来存储备份数据。

# 完全备份、恢复示例
# 备份(node1)：
systemctl stop mysqld
innobackupex --user=root --password=xxx --no-timestamp /backupdir/
scp -r /backups/ root@node2:/datadir/

# 恢复(node2)：
# 停止mysql服务并删除mysqld的数据目录下所有文件
systemctl stop mysqld
rm -rf /data/mysql/*
# 恢复前的整理操作
innobackupex --apply-log /datadir/
# 恢复
innobackupex --copy-back /datadir/
chown -R mysql.mysql /data/mysql/*
# 启动MySQL
systemctl start mysqld


# 2.增量备份
# 每个InnoDB的页面都会包含一个LSN信息，每当相关的数据发生改变，相关的页面的LSN就会自动增长。
# 这正是InnoDB表可以进行增量备份的基础，即innobackupex通过备份上次完全备份之后发生改变的页面来实现。
# 要实现第一次增量备份，可以使用下面的命令进行：
innobackupex --user=dbuser --password=dbpassword --incremental /backup --incremental-basedir=BASEDIR 
# BASEDIR 完全备份所在的目录，执行此命令结束后，innobackupex命令会在/backup目录中创建一个新的以时间命名的目录以存放所有的增量备份数据。
# 另外，在执行过增量备份之后再一次进行增量备份时，其--incremental-basedir应该指向上一次的增量备份所在的目录。
# 注意：增量备份仅能应用于InnoDB或XtraDB表，对于MyISAM表而言，执行增量备份时其实进行的是完全备份。
 