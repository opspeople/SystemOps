#!/usr/bin/env sh
# 1
OpenJDK 64-Bit Server VM warning: If the number of processors is expected to increase from one, then you should configure the number of parallel GC threads appropriately using -XX:ParallelGCThreads=N
# 解决办法：在虚拟机的设置中，将处理器的处理器核心数量改成2，重新执行启动命令后，能够正常运行。若还是未能执行成功，可进一步将处理器数量也改成2.
