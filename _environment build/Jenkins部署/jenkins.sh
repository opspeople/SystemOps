#!/usr/bin/env sh
# 1.安装java环境
# 2.安装maven环境
# 3.下载Jenkins
wget https://prodjenkinsreleases.blob.core.windows.net/redhat-stable/jenkins-2.235.1-1.1.noarch.rpm

# 4.安装
rpm -ivh jenkins-2.235.1-1.1.noarch.rpm

# 5.增加java环境变量配置
vim /etc/rc.d/init.d/jenkins 
# 在candidates字段下添加配置：
/usr/local/jdk-14.0.1/bin/java

# 6.启动jenkins
systemctl daemon-reload jenkins
systemctl start jenkins
chkconfig --level 2345 jenkins on # 开机自启
