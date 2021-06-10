#!/bin/bash
prometheus安全模型

1.不受信任的用户能够访问Prometheus服务器的HTTP API，从而访问数据库中的所有数据

2.只有受信任的用户才能访问Prometheus命令行、配置文件、规则文件和运行时配置

