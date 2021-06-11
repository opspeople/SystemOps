#!/bin/bash
# 1.生成nginx basic auth文件
yum -y install httpd-utils
mkdir /etc/nginx/passwd
htpasswd -c /etc/nginx/passwd/.htpasswd prometheus
输入2次密码

# 2.nginx配置
http {
    server {
        listen 12321;
        servername prometheus.com;

        location /prometheus/ {
            auth_basic           "Prometheus";
            auth_basic_user_file /etc/nginx/passwd/.htpasswd;

            proxy_pass           http://localhost:9090/;
        }
    }
}

events {}

# 3.prometheus.service配置文件修改
[Unit]
Description=prometheus
After=network.target

[Service]
Type=simple
User=prometheus
ExecStart=/usr/local/prometheus/prometheus --config.file=/etc/prometheus/prometheus.yml --web.external-url=http://prometheus.com --storage.tsdb.path=/var/lib/prometheus
Restart=on-failure

[Install]
WantedBy=multi-user.target

# 4.访问
	# 4.1使用ip访问 http://195.203.190.106/graph
	# 4.2 使用域名访问，需要在hosts文件中添加域名解析
		http://prometheus.com/graph

# 正常访问
http://localhostL:9090/metrics


  - job_name: 'node-exporter'
    static_configs:
      - targets: ['your-ip:19090']
    basic_auth:
      username: yuankun
      password: your-password
