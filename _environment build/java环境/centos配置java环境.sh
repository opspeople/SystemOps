#!/usr/bin/env sh
# 1.下载
wget https://download.oracle.com/otn-pub/java/jdk/14.0.1+7/664493ef4a6946b186ff29eb326336a2/jdk-14.0.1_linux-x64_bin.tar.gz?AuthParam=1592885503_39f22e9855373260b563cc6f6017e93b
# 2.解压
tar -zxf jdk-14.0.1_linux-x64_bin.tar.gz

# 3.添加路径配置
vim /etc/profile
export JAVA_HOME=/home/software/jdk1.8.0_65
export JRE_HOME=/home/software/jdk1.8.0_65/jre
export CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib:$CLASSPATH
export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH

# 4.加载配置
source /etc/profile

# 5.验证
java -version