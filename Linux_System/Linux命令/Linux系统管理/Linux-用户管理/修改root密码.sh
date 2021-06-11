#!/usr/bin/bash

1.交互式
# passwd root
连续输入两次root密码即可

2.非交互式
echo "newpassword" | passwd --stdin username