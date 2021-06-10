groupadd mysql
useradd -g mysql mysql
cd /usr/local
tar -zxf mariadb-enterprise-10.1.10-linux-x86_64.tar.gz
ln -s mariadb-enterprise-10.1.10-linux-x86_64 mysql
chown -R mysql:mysql mysql
scripts/mysql_install_db --user=mysql
chown -R mysql:mysql /data
bin/mysqld_safe --default-file=/etc/my.cnf --user=mysql &

# 内存管理器配置
yum -y install jemalloc*
# 在my.cnf文件里添加如下参数
[mysqld_safe]
malloc-lib = /usr/lib64/libjemalloc.so

> show variables like '%malloc%';
