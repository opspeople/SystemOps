1.下载PostgreSQL
2.rpm -ivh install PostgreSQL 
3.安装完成后，初始化PostgreSQL数据库
    /usr/pgsql-12/bin/postgresql-12-setup initdb
4.初始化完成后，启动服务
    systemctl start postgresql-12 && systemctl enable postgresql

5.postgreSQL配置文件
/var/lib/pgsql/12/data/postgresql.conf 
/var/lib/pgsql/12/data/pg_hba.conf 
/var/lib/pgsql/12/data/postgresql.auto.conf
/var/lib/pgsql/12/data/pg_ident.conf 


5.连接postgres
# su - postgres 切换到postgres
-bash-4.2$ posql 进去postgresql
psql (12.4)
Type "help" for help

postgres=# create user postgresql with password 'PGxh2020';
CREATE ROLE
postgres=#
