# 1.阿里云镜像仓库配置
# CentOS7
rm -rf /etc/yum.repos.d/*.repo
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
yum clean all
yum makecache 


# CentOS6
rm -rf /etc/yum.repos.d/*.repo
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-6.repo
yum clean all
yum makecache 


#CentOS8
rm -rf /etc/yum.repos.d/*.repo
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-8.repo
yum clean all
yum makecache 