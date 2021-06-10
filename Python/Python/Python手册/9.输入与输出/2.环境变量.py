# 通过字典os.environ访问环境变量
import os
path = os.environ["PATH"]
user = os.environ["USER"]

# 修改环境变量
os.environ["FOO"] = "BAR"

