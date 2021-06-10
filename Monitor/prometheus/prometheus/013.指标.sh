#!/bin/bash

USE方法

01.cpu使用率
node在5分钟内使用率的平均值
avg(irate(node_cpu_seconds_total{job='node'}[5m])) by (instance)

avg(irate(node_cpu_seconds_total{job='node',mode='idle'}[5m])) by (instance)

02.cpu饱和度
CPU的数量：
count by (instance)(node_cpu_seconds_total{mode='idle'})
