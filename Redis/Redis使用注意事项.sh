# 1.停止使用 keys *
    当数据库太大时，执行时间很长，执行期间任何命令无法执行
    
# 2.找出Redis执行缓慢的原因
    Redis 没有非常详细的日志
    Redis 提供了一个命令统计工具 INFO commandstats
    查看所有命令统计的快照，比如命令执行了多少次，执行命令所耗费的毫秒数(每个命令的总时间和平均时间)

# 3.hashes是你最佳选择
    127.0.0.1:6379> HSET foo first_name "Joe" 
    (integer) 1 
    127.0.0.1:6379> HSET foo last_name "Engel" 
    (integer) 1 
    127.0.0.1:6379> HSET foo address "1 Fanatical Pl" 
    (integer) 1 
    127.0.0.1:6379> HGETALL foo
    1) "first_name" 
    2) "Joe" 
    3) "last_name" 
    4) "Engel" 
    5) "address" 
    6) "1 Fanatical Pl" 
    127.0.0.1:6379> HGET foo first_name
    "Joe"
# 4.设置key值得存活时间

# 5.选择合适的回收策略

# 6.不要耗尽一个实例
    从3.0.0版本开始，Redis就支持集群了
    Redis集群允许你基于key范围分离出部分包含主/从模式的key

# 7.内核越多越好吗
    Redis 是一个单线程进程，即使启用了持久化最多也只会消耗两个内核。

# 8.高可用
    Redis Sentinel 已经经过了很全面的测试