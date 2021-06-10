location /api {
	rewrite ^/api/tenant/calls/(.*)/recording /query/recordings/open/call/$1/stream? break;
	proxy_set_header   Accept-Encoding  "";
	proxy_set_header   Host             $host;
	proxy_set_header   X-Real-IP        $remote_addr;
	proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
	proxy_set_header   X-Forwarded-Proto  $scheme;
	proxy_http_version      1.1;
	proxy_set_header   Upgrade $http_upgrade;
	proxy_set_header   Connection "upgrade";
	proxy_redirect  off;
	proxy_pass http://query;
}