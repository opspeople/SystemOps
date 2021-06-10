# 创建项目目录
mkdir flask-tutorial
cd flask-tutorial

virtualenv -p /usr/local/python3.7.9/bin/python3 flask-tutorial
cd flask-tutorial/

项目布局如下:
/root/flask-tutorial/flask-tutorial/
├── flaskr/
│   ├── __init__.py
│   ├── db.py
│   ├── schema.sql
│   ├── auth.py
│   ├── blog.py
│   ├── templates/
│   │   ├── base.html
│   │   ├── auth/
│   │   │   ├── login.html
│   │   │   └── register.html
│   │   └── blog/
│   │       ├── create.html
│   │       ├── index.html
│   │       └── update.html
│   └── static/
│       └── style.css
├── tests/
│   ├── conftest.py
│   ├── data.sql
│   ├── test_factory.py
│   ├── test_db.py
│   ├── test_auth.py
│   └── test_blog.py
├── venv/
├── setup.py
└── MANIFEST.in
|__ app.py

# 如果使用了版本控制，那么应当忽略运行项目时产生的临时文件以及编辑代码时编辑 器产生的临时文件。
# 忽略文件的基本原则是：不是你自己写的文件就可以忽略。
# 举例 来说，假设使用 git 来进行版本控制，那么使用 .gitignore 来设置应当忽略 的文件， .gitignore 文件应当与下面类似:
.gitignore
venv/

*.pyc
__pycache__/

instance/

.pytest_cache/
.coverage
htmlcov/

dist/
build/
*.egg-info/