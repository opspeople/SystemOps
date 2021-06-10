influx
	-host 连接到远程主机
	-port 远程主机端口
	-socket 'Unix domain socket' 连接unix套接字
	-database 连接到指定数据库
	-password 密码
	-username 用户名
	-ssl 使用https请求
	-execute 'command' 执行命令并退出
	-format 'json|csv|column' 格式制定了服务器响应的格式
	-precision 指定时间戳的格式精度
		rfs3339(YYYY-MM-DDTHH:MM:SS.nnnnnnnZ),h(hours),m(minutes),s,ms,u,ns
	-consistency 'any|one|quorum|all' 设置写一致性级别
	-pretty 打开美化json打印
	-import 导入备份的数据库文件
	-pps 导入允许每秒多少个点，默认情况下，它是零，不会限制进口
	-path import的文件路径
	-compressed 如果导入文件被压缩，则设置为true
