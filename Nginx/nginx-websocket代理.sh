location / {
	proxy_pass http://socket.xh.com/;
	proxy_set_header Host $host:$server_port;
	proxy_http_version 1.1;
	proxy_set_header Upgrade $http_upgrade;
	proxy_set_header Connection "Upgrade";
}
