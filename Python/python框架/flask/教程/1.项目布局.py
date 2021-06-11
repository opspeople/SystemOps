# 创建项目文件夹
# mkdir flask-project

教程项目包含如下内容:
	flaskr/ ，一个包含应用代码和文件的 Python 包。
	tests/ ，一个包含测试模块的文件夹。
	venv/ ，一个 Python 虚拟环境，用于安装 Flask 和其他依赖的包。
	告诉 Python 如何安装项目的安装文件。
	版本控制配置，如 git 。不管项目大小，应当养成使用版本控制的习惯。
	项目需要的其他文件。

1. /home/user/Projects/flask-tutorial
2. ├── flaskr/
3. │ ├── __init__.py
4. │ ├── db.py
5. │ ├── schema.sql
6. │ ├── auth.py
项目布局
项目布局
本文档使用 书栈网 · BookStack.CN 构建 - 36 -
7. │ ├── blog.py
8. │ ├── templates/
9. │ │ ├── base.html
10. │ │ ├── auth/
11. │ │ │ ├── login.html
12. │ │ │ └── register.html
13. │ │ └── blog/
14. │ │ ├── create.html
15. │ │ ├── index.html
16. │ │ └── update.html
17. │ └── static/
18. │ └── style.css
19. ├── tests/
20. │ ├── conftest.py
21. │ ├── data.sql
22. │ ├── test_factory.py
23. │ ├── test_db.py
24. │ ├── test_auth.py
25. │ └── test_blog.py
26. ├── venv/
27. ├── setup.py
28. └── MANIFEST.in
