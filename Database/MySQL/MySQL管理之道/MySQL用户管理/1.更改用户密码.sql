

#!/usr/bin/bash

# 1.设置root密码
> use mysql;
> update user set authentication_string=password('new pass') where user='root' and host='localhost';
> flush privileges;

> update user USER() identified by 'new-password';
> flush privileges;

# 初次登陆设置root密码
> ALTER USER 'root'@'localhost' IDENTIFIED BY 'Xuhua2@20';


忘记密码：
	跳过权限表：
		skip-grant-tables
	修改密码：
		update mysql.user set authentication_string=password('password') where user='root';