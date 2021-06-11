# 临时一次加速
#阿里源加速
pip install pytest -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com

#清华源加速
pip install pytest -i https://pypi.tuna.tsinghua.edu.cn/simple/

# 加速器写入文件
# 1.查找pip配置文件路径
pip -v config list 
For variant 'global', will try loading 'C:\ProgramData\pip\pip.ini'
For variant 'user', will try loading 'C:\Users\xuhua\pip\pip.ini'
For variant 'user', will try loading 'C:\Users\xuhua\AppData\Roaming\pip\pip.ini'
For variant 'site', will try loading 'd:\python3.7.9\pip.ini'

# 2.编辑配置文件 C:\Users\xuhua\pip\pip.ini
# 插入内容如下：
[global]
index-url=http://mirrors.aliyun.com/pypi/simple/
[install]
trusted-host=mirrors.aliyun.com