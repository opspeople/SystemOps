#!/bin/bash

# 在 运行应用之前，需要在终端里导出 FLASK_APP 环境变量:
export FLASK_APP=app.py
export FLASK_ENV=development # 打开调试模式
flask run

# windows下
set FLASK_APP=hello.py

# 在 PowerShell 下:
PS C:\path\to\app> $env:FLASK_APP = "hello.py"

# 还可以使用 python -m flask
export FLASK_APP=hello.py
python -m flask run
 * Running on http://127.0.0.1:5000/

# 运行时外网可访问
flask run --host=0.0.0.0 --port=5000