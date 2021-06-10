#!/bin/bash


# 停止docker
docker stop container_d # 优雅停止
docker kill 容器id/容器名字 # 强制关闭容器


# 删除镜像：
docker rmi 容器id/容器名字

