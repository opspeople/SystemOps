# 1.内置小工具 ftp服务器启动
# python3启动
python -m http.server
# 访问 http://127.0.0.1:8000

# 2.字符串转换为json
xuhua@yujian:~$ echo '{"name": "xuhua", "age": "20"}' | python3 -m json.tool{
    "name": "xuhua",
    "age": "20"     
}
