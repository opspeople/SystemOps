######### 红帽企业版Linux安装
# 下载红帽iso映像
curl -C -O 'URL'

# 检验完整性
md5sum rhel*.iso

# 挂载ISO映像到回环设备
mount -o loop rhel*.iso /mnt/iso 


######### 硬件和设备配置
# 设备驱动程序
# Linux内核的一个主要工作是提供对机器硬件的访问。对CPU和内存的管理，是内核核心功能的一部分。
