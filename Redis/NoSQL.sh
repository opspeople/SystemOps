#!/bin/bash
# 1.NoSQL概述
单机MySQL时代->[缓存+MySQL+垂直拆分的时代]->[分库分表+水平拆分+MySQL集群]

# 2.什么是NoSQL
Not Only SQL
# 特点：
    a.方便扩展（数据之间不存在关系，很好扩展）
    b.大数据量高性能（Redis 1秒写8万次，读取11万行）
# 传统 RDBMS 和 NoSQL
传统的 RDBMS
    - 结构化组织
    - SQL
    - 数据和关系都存在单独的表中 row col
    - 操作操作，数据定义语言
    - 严格的一致性
    - 基础的事务
    - .....
Nosql
    - 不仅仅是数据
    - 没有固定的查询语言
    - 键值对存储，列存储，文档存储，图形数据库（社交关系）
    - 最终一致性，
    - CAP定理和BASE （异地多活） 初级架构师！（狂神理念：只要学不死，就往死里学！）
    - 高性能，高可用，高可扩
    - ....

# 3.NoSQL分类
KV键值对：
    Redis
    Memecache
文档型数据库： 
    MongoDB
    ConthDB
列储存：
    HBase
    分布式文件系统
图关系数据库：
    Neo4j,InfoGrid

