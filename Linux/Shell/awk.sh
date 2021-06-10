

awk [options] [file]

# 1.使用awk打印文件的列
# 打印文件的第一列和第二列
awk '{print $1,$2}' 

# 2.使用正则表达式awk命令
awk '/历史/{print $2}' # 打印匹配到"历史"的行的第二个字段

# 3.通过 awk 命令使用关系表达式
awk '$3 ~/历/ {print $2}' # 打印第3个字段包含"历"字的行的第二个字段
awk '$3 !~/历/ {print $2}' # 与上相反

# 4.