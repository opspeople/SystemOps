### redis-benchmark 是一个压力测试工具
### 命令参数详解
-h 指定服务器主机名
-p 指定服务器端口
-s 指定服务器socket
-c 指定并发数连接
-n 指定请求数
-d 以字节的形式指定 SET/GET 值的数据大小
-k 1=keep alive 0=reconnect
-r SET/GET/INCR 使用随机key，SADD 使用随机值
-P 通过管道传输<numreq>请求
-q 强制退出redis，仅显示query/sec值
--csv 以csv格式输出
-l 生产循环，永久执行测试
-t 仅运行以逗号分隔的测试命令列表
-l idel模式，仅打开N个idle连接并等待

