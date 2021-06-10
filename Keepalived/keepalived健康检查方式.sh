#!/usr/bin/env sh
# 检查方式有两种
# 第一种 HTTP_GET

real_server 192.168.116.142 80 {
	weight 1
	HTTP_GET {
		url {
			path /index.html
			digest 15bcc00f1a21c7dfb1e959c585d9a24c  # http://192.168.116.142/index.html的digest值，获取方法： /usr/local/keepalived/bin/genhash -s 192.168.116.142 -p 80 -u /index.html
			# status_code 200 http://192.168.116.142/index.html的状态返回码
		}
	}
}

# 第二种 SSL_GET
