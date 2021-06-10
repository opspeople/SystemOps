# 1.开头有注释
#!/bin/bash

# 2.代码有注释
    # 头注释
    # 脚本的参数注释
    # 脚本用途注释
    # 脚本注意事项注释
    # 脚本的写作时间，作者，版权等
    # 函数的说明注释
    # 单行命令注释

# 3.参数要规范
# 检查参数
if [ $# != 2 ]
then
    echo "Parameter incorrect."
    exit 1
fi

# 4.变量和魔数
# 将一些重要的环境变量定义在开头，确保这些变量的存在
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/apps/bin/"

# 5.缩进有规范

# 6.命名有标准

# 7.编码要统一

# 8.权限记得加

# 9.日志和回显
# 日志显示高亮，闪烁之类

# 10.密码要移除

# 11.长行要分行
\

# 12.编码细节规范
    # 代码有效率
    # 勤用双引号，几乎所有的大佬都推荐在使用”$”来获取变量的时候最好加上双引号。
    # 巧用main函数
        def func1():
            pass
        def func2():
            pass
        if __name__=='__main__':
            func1
            func2
    # 考虑作用域
    # 函数返回值
    # 间接引用值
    # 巧用heredocs,即在”<<”后定一个标识符，接着我们可以输入多行内容，直到再次遇到标识符为止
    # 学会查路径
        script_dir=$(cd $(dirname $0) && pwd)
        script_dir=$(dirname $(readlink -f $0 ))
    # 代码要简短
    # 命令并行化
        & wait
    # 全文检索
        find . type f | xagrs grep -a 23333
    # 使用新写法
        尽量使用func(){}来定义函数，而不是func{}
        尽量使用[[]]来代替[]
        尽量使用$()将命令的结果赋给变量，而不是反引号
        在复杂的场景下尽量使用printf代替echo进行回显
    # 其他小tip
        路径尽量保持绝对路径，绝多路径不容易出错，如果非要用相对路径，最好用./修饰
        优先使用bash的变量替换代替awk sed，这样更加简短
        简单的if尽量使用&& ||，写成单行。
        比如[[ x > 2]] && echo x
        当export变量时，尽量加上子脚本的namespace，保证变量不冲突
        会使用trap捕获信号，并在接受到终止信号时执行一些收尾工作
        使用mktemp生成临时文件或文件夹
        利用/dev/null过滤不友好的输出信息
        会利用命令的返回值判断命令的执行情况
        使用文件前要判断文件是否存在，否则做好异常处理
        不要处理ls后的数据(比如ls -l | awk ‘{ print $8 }’)，ls的结果非常不确定，并且平台有关
        读取文件时不要使用for loop而要使用while read
        使用cp -r命令复制文件夹的时候要注意如果目的文件夹不存在则会创建，如果存在则会复制到该文件的子文件夹下

# 13.静态检查工具shellcheck
    