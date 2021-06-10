1.在MySQL库中新建用户并授权
	mysql> create user 'exporter'@'localhost' identified by 'Exporter_1234';
	mysql> grant process,replication client,select on *.* to 'exporter'@'localhost';

2.创建mysqld_exporter配置文件
vim /root/.my.cnf 
[client]
user=exporter
password=Exporter_1234

3.启动exporter客户端
	./mysqld_exporter --config.my-cnf=.my.cnf

	# nohup启动
	nohup /usr/local/bin/mysqld_exporter --config.my-cnf=/root/.my.cnf & > /var/log/mysqld-exporter.log

	# 添加系统服务启动
	vi /usr/lib/systemd/system/mysql_exporter.service
	[Unit]
	Description=http://prometheus.io

	[Service]
	Restart=on-failureExecStart=/usr/local/mysql_exporter/mysqld_exporter --config.my-cnf=/root/.my.cnf 

	[Install]
	WantedBy=multi-user.target

