#!/bin/bash
工具地址
    https://github.com/onlyGuo/nginx-gui

# 安装步骤
1.下载解压
2.修改配置文件
    conf/conf.properties
    # nginx 安装路径        nginx.path = /usr/local/Cellar/nginx/1.15.12
    # nginx 配置文件全路径   nginx.config = /Users/gsk/dev/apps/nginx-1.15.12/conf/nginx.conf
    # account.admin = admin
3.重命名（Linux服务器需要）
    根据原作者的描述 针对linux 64位版本 需要将 lib/bin/下的 java_vms 文件 重命名为 java_vms_nginx_gui
4.在服务器上运行前面的步骤都完成以后，直接打包发布到服务器
    # 赋权sudo chmod -R 777 nginx-gui/
    # 后台启动nohup bash /root/web/nginx-gui/startup.sh > logs/nginx-gui.out &