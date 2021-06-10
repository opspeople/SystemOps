#!/usr/bin/env ansible
# 控制机执行
ssh-keygent -t rsa
# 公钥私钥对

# 将生成的公钥私钥对id_rsa.pub发送到其他的服务器上
ssh-copy-id -i /root/.ssh/id_rsa.pub 192.168.116.141
# 登录其他服务器命
ssh 192.168.116.141