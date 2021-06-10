1.hosts文件位置
	C:\\Windows\System32\drivers\etc\hosts 

2.修改方式
	127.0.0.1 www.test.com

3.应用配置
	命令行输入
	# 查看DNS缓存内容
	ipconfig /displaydns

	# 删除DNS缓存内容，从而达到更新DNS的目的
	ipconfig /flushdns
	