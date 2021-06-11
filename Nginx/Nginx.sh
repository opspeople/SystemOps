#!/bin/bash
# Nginx 最初的设计,是成为一个HTTP 服务器，一个能解决ClOK 问题的HTTP 服务器。
# 关于Cl OK 这个问题，Daniel Kegel 在http://www.kegel.com/c 1 Ok . html 页面有具体描述，它旨在设计一个同时连接处理10000 连接数的Web 服务器。
# 为了实现这个目标，Nginx通过基于事件的连接一处理机制，井且操作系统也要使用相应的事件机制，便可以解决ClOK 问题。

# 1.Nginx的安装及第三方模块安装
# 1.1 使用包管理器安装nginx
vi /etc/yu皿.rep。s.d/nginx.repo
[nginx]
name=nginx rep。
baseurl=http://nginx. 。rg/packages/centos/7/$basearch/
gpgcheck=O
enabled=l

yum -y install nginx

# 1.2 从源代码安装Nginx
# 为了从源代码编译Nginx ，系统需要满足某些必要条件。
# 除了编译器之外，如果想分别启用SSL 支持和使用rewrite 模块，
# 那么还需要提供相应的OpenSSL 与PCRE (Perl Compatible Regular Expressions ）库及开发头文件。
# rewrite 模块是默认安装的。
# 如果你没有PCRE 库与开发头文件，你需要在配置阶段禁用rewrite 模块。
# 通用配置选项
--prefix=<path>		# Nginx安装路径
--sbin=<paht>		# nginx二进制文件路径，如果没有指定，这个路径会依赖于--prefix
--conf-path=<path>	# nginx配置文件路径
--error-log-path=<path>	# 错误日志路径
--pid-path=<path>		# nginx master进程的pid，通常在/var/run下
--lock-path=<path>		# 共享存储器互斥锁文件的路径
--user=<user>			# worker进程运行的用户
--group=<user>			# worker进程运行的组
--with-file-aio			# 为FreeBSD 4.3+和Linux 2.6.22+系统启用异步I/O
--with-debug			# 启用调试日志

# 优化编译选项
--with-cc=<path>		# 设置一个不在PATH下的C编译器
--with-cpp=<path>		# 设置C预处理器的相应路径
--with-cc-opt=<option>	# 指定必要的include文件路径
--with-ld-opt=<options>	# 包含连接器库的路径(-L<path>)和运行路径(-R<path>)
--with-cpu-opt=<cpu>	# 为特定的CPU构建Nginx

# 为Web或Mail服务器配置Nginx
# Nginx 是一个独一无二的高性能Web 服务器，它也被设计成为一个邮件代理服务器。
# 根据你构建Nginx 的目标，可将其配置成一个Web 加速器、Web 服务器、邮件代理，或者是集三者为一体
# 邮件代理的配置选项
--with-mail			# 启用mail模块，该模块默认没有被激活
--with-mail_ssl_module	# 为了代理任何一种类型的使用SSL/TLS的mail，需要激活该模块
--with-mail_pop3_module	# 在启用mail模块后，单独禁用POP3模块
--with-mail_imap_module	# 在启用mail 模块后，单独地禁用IMAP 模块
--without-mail_smtp_module	# 在启用mail 模块后，单独地禁用SMTP 模块
--without-http				# 该选项将会完全禁用http 棋块，如果你只想支持mail ，那么可以使用它
# 典型的mail代理
$./configure --with-mail --with-mail_ssl_module --with-openssl=$(BUILD_DIR)/openssl-1.0.1p

# 指定路径的配置选项
--without-http-cache	# 在使用upstream 模块时， Nginx 能够配置本地缓存内容。这个选项能够禁用缓存
--with-http_perl_module	# Nginx 配置能够扩展使用Perl 代码。这个选项启用这个模块（然而， I/0 受阻塞时，使用这个棋块会降低性能。）
--with-perl_modules_path=<path>	# 额外嵌入的Perl模块，使用该选项指定该Perl解析器的路径，也可以通过配置选项来指定perl模块解析器的位置
--with-perl=<path>		# 如果在默认的路径中没有找到Perl，那么指定Perl的路径
--http-log-path=<path>	# nginx访问日志的默认路径
--http-client-body-temp-path=<path>	# 从客户端收到请求后，该选项设置的目录用于作为请求体临时存放的目录。如果 WebDAV 模块启用，那么推荐设置该路径为同一文件系统上的目录作为最终的目的地
--http-proxy-temp-path=<path>		# 在使用代理后，通过该选项设置存放临时文件路径
--http-fastcgi-temp-path=<path>		# 设置FastCGI 临时文件的目录
--http-uwsgi-temp-path= <path>		# 设置uWSG工临时文件的目录
--http-scgi-temp-path=<path>		# 设置SCGII临时文件的目录

# 配置SSL支持
# 使用不带--with-ssl选项的--with-http_ssl_module或者--with-mail_ssl_module，就使用的系统上自带的OpenSSL库
# 为了使用具有优化椭圆曲线的OpenSSL 来构建Nginx ，您将使用如下的命令：
./configure --with-http_ssl_module \
			--with-openssl=$(BUILD_DIR)/openssl-1.0.1p \
			--with-openssl-opt=enable-ec_nistp_64_gcc_128

# 使用其他各种模块
--with-http_ssl_module 		# 对流量进行加密,在URL中开始部分将会是https （需要OpenSSL 库）
--with-http_realip_module	# Nginx 在七层负载均衡器或者是其他设备之后,它们将http头中的客户端IP地址传递，那么你将会需要启用这个模块。在多个客户处于一个IP地址的情况下使用
--with-http_addition_module	# 这个模块作为一个输出过滤器，使你能够在请求经过一个location 前或者后时在该location 本身添加内容
--with-http_xslt_module		# 该模块用于处理XML 响应转换，基于一个或者多个XSLT 格式（需要1 工bxml2 和libxslt 库）
--with-http_image_filter_module # 该模块被作为图像过滤器使用，在将图像投递到客户之前进行处理（需要libgd 库）
--with-http_geoip_module		# 设置各种变量以便在配置文件中的区段使用，基于地理位置查找客户端IP 地址（需要MaxMind GeoIP 库和相应的预编译数据库文件）
--with-http_sub_module			# 该模块实现了替代过滤，在响应中用一个字符串替代另一个字符串，提醒一句： 使用该模块隐式禁用标头缓存
--with-http_dav_module			# 启用这个模块将激活使用WebDAV 的配置指令。
--with-http_flv_module			# 如果需要提供Flash 流媒体视频文件，那么该模块将会提供伪流媒体
--with-http_mp4_module			# 支持H.264/AAC 文件伪流媒体
--with-http_gzip_static_module	# 当被调用的资源没有. gz 结尾格式的文件时，如果想支持发送预压缩版本的静态文件，那么使用该模块
--with-http_gunzip_module		# 对于不支持gzip 编码的客户，该模块用于为客户解压缩预压缩内容
--with-http_random_index_module	# 如果你想提供从一个目录中随机选择文件的索引文件，那么这个模块需要被激活
--with-http_secure_link_module	# 该模块提供了一种机制，它会将一个散列值链接到一个URL 中，因此，只有那些使用正确的密码能够计算链接
--with-http_stub_status_module	# 启用这个模块后会收集Nginx 自身的状态信息。输出的状态信息可以使用RRDtool 或类似的内容来绘制成图

# 网络加速器的配置
./configure --with-http_ssl_module \
			--with-http_realip_module \
			--with-http_geoip_module \
			--with-http_stub_status_module \
			--with-openssl=${BUILE_DIR}/openssl-1.0.1p

# web服务器
./configure --with-http_stub_status_module

# 禁用不再使用的模块
--without-http_charset_module	# 该字符集模块负责设置Content-Type 响应头，以及从一个字符集转换到另一个字符集
--without-http_gzip_module		# gzip 模块作为一个输出过滤器， 在将内容投递到客户时对内容进行压缩
--without-http_ssl_module		# 该模块是一个过滤器， 用于处理SSI 包含。如果启用了Perl 模块， 那么额外的SSI 指令（ perl ）可用
--without-http_userid_module	# user id 模块能够使得Nginx 设置cookies ，用于客户标识。变量$uid_set 和$uid_got 可以记录用户跟踪
--without-http_access_module	# access 模块基于IP 地址控制访问location
--without-http_auth_basic_module	# 该模块通过HTTP 基本身份验证限制访问
--without-http_autoindex_module	# 如果一个目录中没有index 文件，那么autoindex 模块能够收集这个目录列出文件
--without-http_geo_module		# 该模块能够让你基于客户端IP 地址设置配置变量，然后根据这些变量的值采取行动
--without-http_map_module		# map 模块能够让你映射一个变量到另一个变盐
--without-http_split_clients_module	# 该模块创建用于A/B测试的变量
--without-http_referer_module		# 该模块能够让Nginx 阻止基于Referer HTTP 头的请求
--without-http-rewrite_module		# 通过rewrite 模块能够让你基于变量条件改变URI
--without-http_proxy_module			# 使用proxy 模块允许Nginx 将请求传递到其他服务器或者服务器组
--without-http_fastcgi_module		# FastCG 工模块自吕够让Nginx~夺请求传递到JFastCGI 服务器
--without-http_uwsgi_module			# 该模块能够让Nginx 将请求传递到uWSGI 服务器
--without-http_memcached_module		# 该模块能够使得Nginx 与一个memcached 服务捺进行交互，将响应放置到变盘查询中
--without-http_limit_conn_module	# 该模块能够使得Nginx 基于某些键，通常是IP 地址，设置连接限制
--without-http_empty_gif_module		# 在内存中空的GIF 模块产生一个l 像索× l 像素的透明GIF图像
--without-http_browser_module		# browser 模块允许基于User-Agent HTTP 请求头配置，变量的设置基于在该头中发现的版本
--without-http_upstream_ip_hash_module # 该模块定义了一组可以与不同的代理棋块结合使用的服务器

# 查找并安装第三方模块
1.下载模块
2.解压
3.查看README文件
4.通过./configure-add-module=<path>选项使用这个模块

###################################################################################
# 2.配置指南
# 2.1基本配置格式
<section> {
	<directive> <parameters>;
}

# 2.2 Nginx全局配置参数
user 				# 配置worker 进程的用户和组,如果忽略group ，那么group 的名字等于该参数指定用户的用户组
worker_processes	# 指定worker 进程启动的数量。这些进程用于处理客户的所有连接。
					# 选择一个正确的数量取决于服务器环境、磁盘子系统和网络基础设施。一个好的经验法则是设置该参数的值与CPU 绑定的负载处理器核心的数量相同，并用1.5～2 之间的数乘以这个数作为工／ O 密集型负载
error_log			# 是所有错误写入的文件。该指令的第二个参数指定了被记录错误的级别（ debug 、info 、notice 、warn 、error 、crit 、alert 、emerg ）。
pid 				# 设置记录主进程ID 的文件，这个配置将会覆盖编译时的默认配置
use 				# 该指令用于指示使用什么样的连接方法。这个配置将会覆盖编译时的默认配置，如果配置该指令，那么需要一个events 区段。
					# 通常不需要覆盖，除非是当编译时的默认值随着时间的推移产生错误时才需要被覆盖设置
worker_connections	# 该指令配置一个工作进程能够接受并发连接的最大数。

# 2.3 使用 include 文件
include /opt/local/etc/nginx/mime.types;
include /opt/local/etc/nginx/vhost/*.conf;

nginx测试配置文件
nginx -t -c <path-to-nginx.conf>

# 2.4 http的server部分
# 客户端指令
chunked_transfer_encoding	# 在发送给客户端的响应中， 该指令允许禁用http/1 . 1 标准的块传输编码
client_body_buffer_size		# 为了阻止临时文件写到磁盘，可以通过该指令为客户端请求体设置缓存大小， 默认的缓存大小为两个内存页面
client_body_in_file_only	# 用于调试或者是进一步处理客户端请求体。该指令设置为“ on ”能够将客户端请求体强制写入到磁盘文件
client_body_in_single_buffers # 为了减少复制的操作，使用该指令强制Ng i nx 将整个客户端请求体保存在单个缓存中
client_body_temp_path		# 该指令定义一个命令路径用于保存客户端请求体
client_body_timeout			# 该指令指定客户体成功读取的两个操作之间的时间间隔
client_header_buffer_size	# 该指令为客户端请求头指定一个缓存大小，当请求头大于lKB 时会用到这个设置
client_header_timeout		# 该超时是读取整个客户端头的时间长度
client_max_body_size		# 该指令定义允许最大的客户端请求头，如果大于这个设置，那么客户端将会是413 (Request Entity Too Large ）错误
keepalive_disable			# 该指令对某些类型的客户端禁用keep-alive 请求功能
keepalive_requests			# 该指令定义在一个keep-alive 关闭之前可以接受多少个请求
keepalive_timeout			# 该指令指定keep-alive 连接持续多久。第二个参数也可以设置，用于在响应头中设置“ keepalive ”头
large_client_header_buffers	# 该指令定义最大数量和最大客户端请求头的大小
msie_padding				# 为了填充响应的大小至5 1 2 字节，对于MSIE 客户端，大于400 的状态代码会被添加注释以便满足5 1 2 字节，通过启用该命令可以阻止这种行为
msie_refresh				# 对于MSIE 客户端，该指令可启用发送一个refresh 头，而不是red 工re ct
# 文件I/O指令
aio 			# 该指令启用异步文件工／ O 。该指令对于现代版本的FreeBSD和所有Linux 发行版都有效。在FreeBSD 系统下， aio 可能被用于sendf ile 预加载数据。在Linux 下，则需要directio 指令，自动禁用sendf ile
directio		# 该指令用于启用操作系统特定的标志或者功能提供大于给定参数的文件。在Linux 系统下，使用ai 。时需要使用该指令
directio_alignment 	# 该指令设置directio 的算法。默认值为5 1 2 ，通常足够了，但是在L inux 的XFS 下推荐增加为4KB
open_file_cache		# 该指令配置一个缓存用于存储打开的文件描述符、目录查询和文件查询错误
open_file_cache_errors	# 该指令按照open file cache ，启用文件查询错误缓存
open_file_cache_min_uses	# open_file_cache 缓存的文件描述符保留在缓存中，使用该指令配置最少使用文件描述符的次数
open_file_cache_valid		# 该指令指定对open_file_cache 缓存有效性检查的时间间隔
postpone_output				# 该指令指定Nginx 发送给客户端最小的数值，如果可能的话，没有数据会发送，直到达到此值
read_ahead			# 如果可能的话，内核将预读文件到设定的参数大小。目前支持FreeBSD 和Linux (Linux 会忽略大小）
sendfile			# 该指令使用sendfile (2 ）直接复制数据从一个到另一个文件描述符
sendfile_max_chunk	# 该指令设置在一个sendfile (2 ）中复制最大数据的大小，这是为了阻止worker “贪婪”

# Hash指令
# hash 指令控制Nginx 分配给某些变量多大的静态内存。
# 在启动和重新配置时，Nginx会计算需要的最小值
# 在Nginx 发出警告时，只需要调整一个飞hash_max_size 指令的参数值就可以达到效果。
# *_hash_bucket_size 变量被设置了默认值，以便满足多处理器缓存行降低检索所需要的检索查找，因此基本不需要改变，
server_names_hash_bucket_size	# 该指令指定用于保存server_name 散列表大小的“桶”
server_names_hash_max_size		# 该指令指定server_name 散列表的最大大小
types_hash_bucket_size			# 该指令指定用于存储散列表的“桶”的大小
types_hash_max_size				# 该指令指定散列类型表的最大大小
variables_hash_bucket_size		# 该指令指定用于存储保留变量“桶”的大小
variables_hash_max_size			# 该指令指定存储保留变量最大散列值的大小

# Socket 指令
# Socket 指令描述了Nginx 如何设置创建TCP 套接字的变量选项。
lingering_close				# 该指令指定如何保持客户端的连接，以便用于更多数据的传输
lingering_time				# 在使用lingering close 指令的连接中，该指令指定客户端连接为了处理更多的数据需要保持打开连接的时间
lingering_timeout			# 结合lingering close ，该指令显示Nginx 在关闭客户端连接之前，为获得更多数据会等待多久
reset_timedout_connection	# 使用这个指令之后，超时的连接将会被立即关闭，释放相关的内存。默认的状态是处于FIN WAITl ，这种状态将会一直保持连接
send_lowat		# 如果非零， Nginx 将会在客户端套接字尝试减少发送操作
send_timeout	# 该指令在两次成功的客户端接收响应的写操作之间设置－个超时时间
tcp_nodelay		# 启用或者禁用TCP_NODELAY 选项，用于keep-alive 连接
tcp_nopush		# 仅依赖于sendf ile 的使用。它能够使得Nginx 在－ 个数据包中尝试发送响应头以及在数据包中发送一个完整的文件

# 2.5 虚拟服务器部分
# 任何由关键字 server 开始的部分被称作"虚拟服务器"部分。
# 它描述的是一组根据不同的server name 指令逻辑分割的资源，这些虚拟服务器响应HTTP 请求，
# 因此它们都包这些虚拟服务器响应HTTP 请求，因此它们都包含在http 部分中。
# 一个虚拟服务器由listen 和server name 指令组合定义， listen 指令定义了一个IP 地址、端口组合或者是UNIX 域套接字路径。
listen address[:port];
listen port;
listen unix:path;
# 其他可选参数
default_server 		# 该参数定义这样一个组合： address:port 默认的请求被绑定在此
setfib				# 该参数为套接字监听设置相应的FIB
backlog				# 该参数在listen （）的调用中设置backlog 参数调用
rcvbuf				# 在套接字监听中，该参数设置SO_RCVBUF 参数
sndbuf				# 在套接字监昕中，该参数设置SO_SNDBUF 参数
accept_filter		# 该参数设置接受的过滤器： dataready 或者httpready dataready
deferred			# 该参数使用延迟的accept （）调用设置TCP_DEFER_ACCEPT选项
bind				# 该参数为address :port 套接字对打开一个单独的bind （）调用
ipv6only			# 该参数设置IPV6_V60NLY 参数的值
ssl 				# 该参数表明该端口仅接受HTTPS 的连接
so_keepalive		# 该参数为TCP 监昕套接字配置keepalive

# server name 指令是相当简单的，但可以用来解决一些配置问题。
# 它的默认值为""，这意味着server部分没有server_name指令对于没有设置Host 头字段的请求，它将会匹配
# 该server 处理。这种情况可用于如丢弃这种缺乏Host 头的请求。
server {
	listen 80;
	return 444;
}

# 除了普通的字符串之外， Nginx 也接受通配符作为server_name 指令的参数。
通配符可以替代部分子域名： ＊.example.com
通配符可以替代部分顶级域： www.example.＊
一种特殊形式将匹配子域或域本身： .example.com （匹配＊ .example.com 也包括example.com ）

通过在域名前面加上波浪号（～），正则表达式也可以被作为参数应用于server_name
server_name ~^www\.example\.com$;
server_name ~^www(\d+).example\.(com)$ ;
# 对于一个特定的请求，确定哪些虚拟服务器提供该请求的服务时， Nginx 应该遵循下面的逻辑。
	1. 匹配IP 地址和listen 指令指定的端口。
	2. 将Host 头字段作为一个字符串匹配server name 指令。
	3. 将Host 头字段与server_name 指令值字符串的开始部分做匹配。
	4. 将Host 头字段与server_name 指令值字符串的结尾部分做匹配。
	5. 将Host 头字段与sever_name 指令值进行正则表达式匹配。
	6. 如果所有Host 头匹配失败，那么将会转向listen 指令标记的default server 。
	7. 如果所有的Host 头匹配失败，并且没有default se凹er，那么将会转向第一个server的listen 指令，以满足第l 步。

# locations where,when,how
# location 指令可以用在虚拟服务器sever 部分，井且意味着提供来自客户端的URI 或者内部重定向访问
# 除少数情况外， location 也可以被嵌套使用，它们被作为特定的配置尽可能地处理请求。
location [modifier] uri {...}
location @name {...}

# 命名location仅对内部访问重定向，在进入一个location 之前，它会保留被请求的URI部分
# 命名location 只能够在server 级别定义。
location命名通配符
= 	# 该修饰符使用精确匹配并且终止搜索
~ 	# 该修饰符使用区分大小写的正则表达式匹配
~*	# 该修饰符使用不区分大小写的正则表达式匹配
^~	# 如果该location 是最佳的匹配，那么对于匹配这个location 的字符串，该修饰符不再进行正则表达式检测。
	# 注意，这不是一个正则表达式匹配，它的目的是优先于正则表达式的匹配
