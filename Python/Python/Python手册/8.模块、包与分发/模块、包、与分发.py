# spam.py
a = 37
def foo():
	print("I'm foo and a is %s" % a)
def bar():
	print("I'm bar and I'm calling foo")

import spam # 导入spam模块
from spam import bar # 从spam模块导入bar

# 模块搜索路径
import sys
sys.path.append("mymodules.zip")

# 安装第三方库
1.下载需要安装的第三方库文件
2.解压第三方库文件
3.安装第三方库文件到默认路径(site-packages)目录下
cd 解压后的第三方库文件目录
python setup.py install 
4.安装第三方库文件到指定用户目录
cd 解压后的第三方库文件目录
python setup.py install --user
5.安装到特定的路径
python setup.py install --prefix=/dir
