# 1.在my.cnf文件直接添加[client]字段
[client]
user = root
password = password
port = 3306

# 2.通过mysql命令行工具 mysql_config_editor
mysql_config_editor -G vml -s /var/run/mysql.sock -uroot -p 
Enter password:
# 输入密码之后就会再这个用户目录下生成一个.mylogin.cnf的二进制文件
mysql_config_editor print -all # print之后就会看见，我们创建了一个标签vml,密码是加密的，这种方式是二进制，相对比较安全
# 登陆方式：
mysql --login-path=vml

# 3.通过my.cnf来配置，设置到~/.my.cnf来配置免密登陆
cat ~/.my.cnf 
[client]
user = root
password = password
port = 3306
