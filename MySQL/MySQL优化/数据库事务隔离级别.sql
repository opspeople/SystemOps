# 查看当前事务隔离级别
show variables like '%tx_isolation%';


# 查看全局事务隔离级别
select @@global.tx_isolation;
# 查看会话的事务隔离级别
slect @@session.tx_isolation;

# 提示：在MySQL 8.0.3 中，tx_isolation 变量被 transaction_isolation 变量替换了。在 MySQL 8.0.3 版本中查询事务隔离级别，只要把上述查询语句中的 tx_isolation 变量替换成 transaction_isolation 变量即可

# 设置事务隔离级别
set [session|global] transaction isolation level {read uncommitted|read committed|repeatable read|serializable}

set tx_isolation='read-committed'; # 直接修改当前session的事务隔离级别

