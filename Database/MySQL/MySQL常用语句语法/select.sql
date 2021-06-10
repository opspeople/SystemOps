#!/usr/local/bin/mysql
# 1.将一个字段的值插入另一个字段记录，借助中间虚拟表
UPDATE order_flow SET create_time =
    (SELECT b.receiveTime FROM 
          ( SELECT a.receiveTime FROM order_flow a WHERE a.flowId = 1) -- 此处相当于一个虚拟的表，简称b
b) 
WHERE flowId = 1;