1.自定义返回给客户端的404错误页面
	charset utf-8;				# 仅在需要中文时修该该选项
	error_page 404 /404.html;	# 自定义错误页面


2.查看服务器状态信息
	开启 --with-http_stub_status_module状态页面
	./configure \
	--with-http_ssl_module \			# 开启SSL加密功能
	--with-stream \						# 开启TCP、UDP代理模块
	--with-http_stub_status_module 		# 开启status状态页面

	启用Nginx服务并查看监听端口状态
	ss命令可以查看系统中启动的端口信息，该命令常用选项如下：
		-a显示所有端口的信息
		-n以数字格式显示端口号
		-t显示TCP连接的端口
		-u显示UDP连接的端口
		-l显示服务正在监听的端口信息，如httpd启动后，会一直监听80端口
		-p显示监听端口的服务名称是什么（也就是程序名称）

	修改Nginx配置文件，定义状态页面
	[root@proxy ~]# cat /usr/local/nginx/conf/nginx.conf
	… …
	location /status {
	                stub_status on;
	                 #allow IP地址;
	                 #deny IP地址;
	        }
	… …
	[root@proxy ~]# /usr/local/nginx/sbin/nginx -s reload

	优化后，查看状态页面信息
	[root@proxy ~]# curl  http://192.168.4.5/status
	Active connections: 1 
	server accepts handled requests
	 10 10 3 
	Reading: 0 Writing: 1 Waiting: 0

	Active connections：当前活动的连接数量。
	Accepts：已经接受客户端的连接总数量。
	Handled：已经处理客户端的连接总数量。（一般与accepts一致，除非服务器限制了连接数量）。
	Requests：客户端发送的请求数量。
	Reading：当前服务器正在读取客户端请求头的数量。
	Writing：当前服务器正在写响应信息的数量。
	Waiting：当前多少客户端在等待服务器的响应。

3.优化Nginx并发量
	3.1 优化前使用ab高并发测试
	[root@proxy ~]# ab -n 2000 -c 2000 http://192.168.4.5/
	Benchmarking 192.168.4.5 (be patient)
	socket: Too many open files (24)                //提示打开文件数量过多

	3.2 修改Nginx配置文件，增加并发量
	[root@proxy ~]# vim /usr/local/nginx/conf/nginx.conf
	.. ..
	worker_processes  2;                    //与CPU核心数量一致
	events {
	worker_connections 65535;        //每个worker最大并发连接数
	}
	.. ..
	[root@proxy ~]# /usr/local/nginx/sbin/nginx -s reload

	3.3 优化Linux内核参数（最大文件数量）
	[root@proxy ~]# ulimit -a                        //查看所有属性值
	[root@proxy ~]# ulimit -Hn 100000                //设置硬限制（临时规则）
	[root@proxy ~]# ulimit -Sn 100000                //设置软限制（临时规则）
	[root@proxy ~]# vim /etc/security/limits.conf
	    .. ..
	*               soft    nofile            100000
	*               hard    nofile            100000

	#该配置文件分4列，分别如下：
	#用户或组    硬限制或软限制    需要限制的项目   限制的值

4.优化Nginx数据包头缓存
	4.1 优化前，使用脚本测试长头部请求是否能获得响应
	[root@proxy ~]# cat lnmp_soft/buffer.sh 
	#!/bin/bash
	URL=http://192.168.4.5/index.html?
	for i in {1..5000}
	do
	    URL=${URL}v$i=$i
	done
	curl $URL                                //经过5000次循环后，生成一个长的URL地址栏
	[root@proxy ~]# ./buffer.sh
	.. ..
	<center><h1>414 Request-URI Too Large</h1></center>        //提示头部信息过大

	4.2 修改Nginx配置文件，增加数据包头部缓存大小
	[root@proxy ~]# vim /usr/local/nginx/conf/nginx.conf
	.. ..
	http {
	client_header_buffer_size    1k;        //默认请求包头信息的缓存    
	large_client_header_buffers  4 4k;        //大请求包头部信息的缓存个数与容量
	.. ..
	}
	[root@proxy ~]# /usr/local/nginx/sbin/nginx -s reload

	4.3 优化后，使用脚本测试长头部请求是否能获得响应

	[root@proxy ~]# cat buffer.sh 
	#!/bin/bash
	URL=http://192.168.4.5/index.html?
	for i in {1..5000}
	do
	    URL=${URL}v$i=$i
	done
	curl $URL
	[root@proxy ~]# ./buffer.sh

5.浏览器本地缓存静态数据
	改Nginx配置文件，定义对静态页面的缓存时间
	[root@proxy ~]# vim /usr/local/nginx/conf/nginx.conf
	server {
	        listen       80;
	        server_name  localhost;
	        location / {
	            root   html;
	            index  index.html index.htm;
	        }
	location ~* \.(jpg|jpeg|gif|png|css|js|ico|xml)$ {
	expires        30d;            //定义客户端缓存时间为30天
	}
	}
	[root@proxy ~]# cp /usr/share/backgrounds/day.jpg /usr/local/nginx/html
	[root@proxy ~]# /usr/local/nginx/sbin/nginx -s reload
	#请先确保nginx是启动状态，否则运行该命令会报错,报错信息如下：
	#[error] open() "/usr/local/nginx/logs/nginx.pid" failed (2: No such file or directory)

	