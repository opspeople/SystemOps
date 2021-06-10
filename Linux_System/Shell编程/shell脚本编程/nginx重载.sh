#!/bin/bash
set -eu
NGINX_CONFIG_FILE=/etc/nginx/nginx.conf

config_test() {
    nginx -c $NGINX_CONFIG_FILE -t
}

# 在此处直接把nginx的master pid可以通过反引号来获取echo后的值
get_nginx_master_pid(){
    echo `ps auxf | grep -E "nginx:[[:space:]]+master"| awk '{print $2}'`
}

reload() {
    # `get_nginx_master_pid` 获得nginx master pid
    kill -HUP `get_nginx_master_pid`
}

# 入口函数
main() {
    config_test
    reload
}

# main在此需要获取脚本本身的参数， 故将$@传递给main函数
main $@

# set命令
•set -e: bash脚本遇到错误立即退出
•set -n: 检查脚本语法但不执行
•set -u: 遇到未设置的变量立即退出
•set -o pipefail: 控制在管道符执行过程中有错误立即退出
•set -x: 分步调试命令

# 在写脚本时，我们可以直接在脚本开头简写为如下格式:
#!/bin/bash
set -euxo pipefail

# 检查bash脚本的语法时，可以这样写:
bash -n main.sh