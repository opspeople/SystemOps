#!/usr/bin/env ansible

# Tasks Include Files And Encouraging Reuse

1.task重用
--- 
# possibly saved as tasks/foo.yml
- name: placeholder foo
  command: /bin/foo

- name: placeholder bar
  command: /bin/bar

# 在一个playbook中，引用给task
tasks:
  - include: tasks/foo.yml

# 给include传递变量，称之为"参数化的include"
# 例：部署多个wordpress实例：
tasks:
  - include: wordpress.yml wp_user=timmy
  - include: wordpress.yml wp_user=alice
  ...

# include语法传递列表和字典参数
tasks:
  - { include: wordpress.yml, wp_user: timmy, ssh_keys: [ 'keys/one.txt', 'keys/two.txt' ]}

2.在handler中使用include
---
# this might be a file like handlers/handlers.yml
- name: restart apache
  service: name=apache state=restarted
# 然后在主playbook文件中，在一个play的最后使用include包含handlers.yml
handlers:
  - include: handlers/handlers.yml

# playbook之间使用include
- name: this is a  play the top level of a file
  hosts: all
  remote_user: root 

  tasks:
  - name: say hi
    tags: foo
    shell: echo "hi..."

- include: load_balancers.yml
- include: webservers.yml
- include: dbservers.yml

3.Roles
组织playbook最好的方式：Roles
# Roles基于一个已知的文件结构，去自动的加载某些vars_file,tasks以及handlers

# 一个项目的结构如下：
site.yml
webservers.yml
fooservers.yml
roles/
	common/
		files/
		templates/
		tasks/
		handlers/
		vars/
		defaults/
		meta/
	webservers/
		files/
		templates/
		tasks/
		handlers/
		vars/
		defaults/
		meta/

# 一个playbook如下：
---
- hosts: webservers
  roles:
    - common
    - webservers

# 如果 roles/x/tasks/main.yml 存在, 其中列出的 tasks 将被添加到 play 中
# 如果 roles/x/handlers/main.yml 存在, 其中列出的 handlers 将被添加到 play 中
# 如果 roles/x/vars/main.yml 存在, 其中列出的 variables 将被添加到 play 中
# 如果 roles/x/meta/main.yml 存在, 其中列出的 “角色依赖” 将被添加到 roles 列表中 (1.3 and later)
# 所有 copy tasks 可以引用 roles/x/files/ 中的文件，不需要指明文件的路径。
# 所有 script tasks 可以引用 roles/x/files/ 中的脚本，不需要指明文件的路径。
# 所有 template tasks 可以引用 roles/x/templates/ 中的文件，不需要指明文件的路径。
# 所有 include tasks 可以引用 roles/x/tasks/ 中的文件，不需要指明文件的路径。

# 如果 roles 目录下有文件不存在，这些文件将被忽略。比如 roles 目录下面缺少了 ‘vars/’ 目录，这也没关系。

# 如果你在 playbook 中同时使用 roles 和 tasks，vars_files 或者 handlers，roles 将优先执行。

# 而且，如果你愿意，也可以使用参数化的 roles，这种方式通过添加变量来实现，比如:
---
- hosts: webservers
  roles:
    - common
    - { role: foo_app_instance, dir: '/opt/a',  port: 5000 }
    - { role: foo_app_instance, dir: '/opt/b',  port: 5001 }

# 当一些事情不需要频繁去做时，你也可以为 roles 设置触发条件，像这样:
---

- hosts: webservers
  roles:
    - { role: some_role, when: "ansible_os_family == 'RedHat'" }
# 它的工作方式是：将条件子句应用到 role 中的每一个 task 上。

# 最后，你可能希望给 roles 分配指定的 tags。比如:
---
- hosts: webservers
  roles:
    - { role: foo, tags: ["bar", "baz"] }

# 如果 play 仍然包含有 ‘tasks’ section，这些 tasks 将在所有 roles 应用完成之后才被执行。
# 如果你希望定义一些 tasks，让它们在 roles 之前以及之后执行，你可以这样做:
---

- hosts: webservers

  pre_tasks:
    - shell: echo 'hello'

  roles:
    - { role: some_role }

  tasks:
    - shell: echo 'still busy'

  post_tasks:
    - shell: echo 'goodbye'

4.角色默认变量 Role Default Variable
# 角色默认变量允许你为 included roles 或者 dependent roles(见下) 设置默认变量。
# 要创建默认变量，只需在 roles 目录下添加 defaults/main.yml 文件。
# 这些变量在所有可用变量中拥有最低优先级，可能被其他地方定义的变量(包括 inventory 中的变量)所覆盖。
角色依赖 Role Dependencies
# “角色依赖” 使你可以自动地将其他 roles 拉取到现在使用的 role 中。”
# 角色依赖” 保存在 roles 目录下的 meta/main.yml 文件中
# 这个文件应包含一列 roles 和 为之指定的参数，下面是在 roles/myapp/meta/main.yml 文件中的示例:
---
dependencies:
  - { role: common, some_parameter: 3 }
  - { role: apache, port: 80 }
  - { role: postgres, dbname: blarg, other_parameter: 12 }

# “角色依赖” 可以通过绝对路径指定，如同顶级角色的设置:
---
dependencies:
   - { role: '/path/to/common/roles/foo', x: 1 }

# “角色依赖” 也可以通过源码控制仓库或者 tar 文件指定，使用逗号分隔：路径、一个可选的版本（tag, commit, branch 等等）、一个可选友好角色名（尝试从源码仓库名或者归档文件名中派生出角色名）:
# “角色依赖” 总是在 role （包含”角色依赖”的role）之前执行，并且是递归地执行。
# 默认情况下，作为 “角色依赖” 被添加的 role 只能被添加一次，如果另一个 role 将一个相同的角色列为 “角色依赖” 的对象，它不会被重复执行。
# 但这种默认的行为可被修改，通过添加 allow_duplicates: yes 到 meta/main.yml 文件中。
# 比如，一个 role 名为 ‘car’，它可以添加名为 ‘wheel’ 的 role 到它的 “角色依赖” 中:

---
dependencies:
- { role: wheel, n: 1 }
- { role: wheel, n: 2 }
- { role: wheel, n: 3 }
- { role: wheel, n: 4 }
# wheel 角色的 meta/main.yml 文件包含如下内容:
---
allow_duplicates: yes
dependencies:
- { role: tire }
- { role: brake }

# 最终的执行顺序是这样的:
tire(n=1)
brake(n=1)
wheel(n=1)
tire(n=2)
brake(n=2)
wheel(n=2)
...
car

5.在roles中嵌入模块
roles/
   my_custom_modules/
       library/
          module1
          module2

- hosts: webservers
  roles:
    - my_custom_modules
    - some_other_role_using_my_custom_modules
    - yet_another_role_using_my_custom_modules