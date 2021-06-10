# 在远程主机上执行ansible管理主机上的脚本，脚本一直存在于管理主机上，不需要拷贝到远程主机后再执行

# 参数
chdir 指定一个远程主机中的目录，在执行对应的脚本之前，会先进入到chdir参数指定的目录中
ansible all -m script -a'chdir=/opt /opt/test.sh'

creates 指定一个远程主机中的文件，当指定的文件存在时，就不执行对应脚本
ansible all -m script -a'creates=/opt/testfile /opt/test.sh'

removes 指定一个远程主机中的文件，当指定的文件不存在时，就不执行对应脚本
ansible all -m script -a'removes=/opt/testfile /opt/test.sh'
