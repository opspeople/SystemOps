#!/usr/bin/env ansible
# 1.语法格式
ansible <pattern_goes_here> -m <module_name> -a <arguement>

# 2.例
ansible webserber -m service -a 'name=httpd state=restarted'

