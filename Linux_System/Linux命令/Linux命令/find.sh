#!/usr/bin/env sh
# find 指定文件执行指定操作
find / -name "test*" | xargs rm -rf
find / -name "test*" -exec rm -rf {} \;
rm -rf $(find / -name "test*")

# 指定递归深度
find / -maxdepth 3 -name "*.mp3" | xargs rm -rf
find / -maxdepth 3 -name “test*” -exec rm -rf {} \; 
rm -rf $(find / -maxdepth 3 -name “test”) 