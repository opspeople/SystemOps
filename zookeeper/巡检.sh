#!/bin/bash

# 1.查看zookeeper版本
yum -y install nc && echo stat|nc 127.0.0.1 2181
Zookeeper version: 3.4.6-8--1, built on 04/01/2017 21:27 GMT
Clients:
 /192.168.1.77:42914[1](queued=0,recved=69,sent=69)
 /127.0.0.1:56395[0](queued=0,recved=1,sent=0)
 /192.168.1.77:44758[1](queued=0,recved=152204,sent=152204)
 /192.168.1.77:60389[1](queued=0,recved=124290,sent=124290)
 /192.168.1.77:44714[1](queued=0,recved=266757,sent=266762)
 /192.168.1.77:42915[1](queued=0,recved=402,sent=402)
 /192.168.1.77:44701[1](queued=0,recved=133173,sent=133173)

Latency min/avg/max: 0/0/774
Received: 1806378
Sent: 1806386
Connections: 7
Outstanding: 0
Zxid: 0x14f828
Mode: standalone
Node count: 846