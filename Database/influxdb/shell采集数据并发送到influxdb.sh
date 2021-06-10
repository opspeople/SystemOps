#!/bin/bash
#获取pid
read -p “输入要查询的pid:” pid

#通过循环持续将数据写入influxDB
while true; do

#查询jvm数据并写入jvm.txt文件

jstat -gcutil $pid | awk ‘NR!=1{printf “t_jvm,host=server S0=%f,S1=%f,E=%f,O=%f,M=%f,CCS=%f,YGC=%i,YGCT=%f,FGC=%i,FGCT=%f,GCT=%f\n”,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11;fflush();}’ > “/tmp/jvm.txt”;
#将数据写入influxDB
curl -i -XPOST ‘http://localhost:8086/write?db=data_68’ --data-binary @/tmp/jvm.txt;

#每2秒执行一次
sleep 2
done
