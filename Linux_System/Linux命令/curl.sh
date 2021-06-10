# curl get请求
curl http://ip:port/url?args

curl "http://www.baidu.com"  如果这里的URL指向的是一个文件或者一幅图都可以直接下载到本地

curl -i "http://www.baidu.com"  显示全部信息

curl -l "http://www.baidu.com" 只显示头部信息

curl -v "http://www.baidu.com" 显示get请求全过程解析

# curl Post 请求
curl -d "args" "protocol://address:port/url"
curl -d "user=Summer&passwd=123456" "http://ip:port/url"