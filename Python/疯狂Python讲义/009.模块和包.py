# 1.模块化编程
# 1.1 导入模块的语法
# 导入整个模块 import 模块名1[as 别名1], 模块名2[as 别名2],...
# 导入模块中指定成员 from 模块名 import 成员名[as 别名1]
# 1.2 定义模块
# 任意一个以.py结尾的文件都是一个模块
# 1.3 为模块编写说明文档
# 在模块开始处定义一个字符串直接量即可
# 2 加载模块
# 2.1 使用环境变量
# Python将会根据PYTHONPATH环境变量的值来确定到哪里去加载模块
# PYTHONPATH环境变量的值是多个路径的集合
# 在windows平台上设置环境变量
# 右击“计算机”，单击“属性”菜单项，选择“高级系统设置”，“系统属性”下得“环境变量”，在“系统变量”中新建
# 名为“PYTHONPATH”，值为python模块文件所在文件夹的路径
# 在Linux上设置环境变量
# vim ~/.bash_profile
# PYTHONPATH=.:/home/pythonmodule
# source ~/.bash_profile
# 2.2 默认的模块加载路径
>>> import sys,pprint
>>> pprint.pprint(sys.path)
['',
 'D:\\Python3.9.2\\Lib\\idlelib',
 'D:\\Python3.9.2\\python39.zip',
 'D:\\Python3.9.2\\DLLs',
 'D:\\Python3.9.2\\lib',
 'D:\\Python3.9.2',
 'C:\\Users\\xuhua\\AppData\\Roaming\\Python\\Python39\\site-packages',
 'D:\\Python3.9.2\\lib\\site-packages']

# 3 使用包
# 3.1 什么是包
# 为了更好的管理多个模块源文件，Python提供了包的概念
# 包就是一个文件夹，在该文件夹下包含了一个__init__.py文件，该文件夹可用于包含多个模块源文件
# 包的本质依然是模块
# 3.2 定义包
# （1）创建一个文件夹，该文件夹的名字就是该包的包名
# （2）在该文件夹内添加一个__init__.py文件即可

# 3.2 导入包的成员
# 有包结构如下
test_package
|-arithmetic_chart.py
|- billing.py
|- print_shape.py
|--__init__.py
# 导入包内成员
import test_package
import test_package.billing
from test_package import billing
# 4 查看模块内容
# 4.1 查看包含什么
dir(test_package)
