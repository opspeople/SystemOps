#!/usr/bin/env ansible

# Playbooks 是 Ansible的配置,部署,编排语言.

# 示例
---
- hosts: webservers
  vars:
    http_port: 80
    max_clients: 200
  remote_user: root
  tasks:
  - name: ensure apache is at the latest version
    yum: pkg=httpd state=latest

  - name: write the apache config file
    template: src=/srv/httpd.j2 dest=/etc/httpd.conf
    notify:
    - restart apache
  - name: ensure apache is running
    service: name=httpd state=started
  handlers:
    - name: restart apache
      service: name=httpd state=restarted

# 1.playbook基础
# 1.1 主机与用户
---
- hosts: webservers
  remote_user: root

# 在tasks中定义远程用户
---
- hosts: webservers
  remote_user: root
  tasks:
  	- name: test connection
  	  ping:
  	  remote_user: yourname
# 使用sudo执行命令
---
- hosts: webservers
  remote_user: yourname
  sudo: yes

# 在tasks中使用sudo执行命令
---
- hosts: webservers
  remote_user: yourname
  tasks:
    - service: name=nginx state=started
      sudo: yes

# sudo到不同的用户
---
- hosts: webservers
  remote_user: yourname
  sudo: yes
  sudo_user: postgres

# 使用sudo时指定密码，可在运行ansible-playbook命令时加上 --ask-sudo-pass(-K)选项

# 2.tasks列表   ----  任务列表
# 每个play包含一个task列表。一个task在其所对应的所有主机上执行完毕之后，下一个task才会执行。
# 在运行 playbook 时（从上到下执行）,如果一个 host 执行 task 失败,这个 host 将会从整个 playbook 的 rotation 中移除. 如果发生执行失败的情况,请修正 playbook 中的错误,然后重新执行即可.

# tasks格式
tasks:
  -name: make sure apache is running
  service: name=httpd state=running

# 特殊的module: command及shell
tasks:
  - name: disable selinux
    command: /sbin/setenforce 0
# 使用command和shell模块时，我们需要关心返回码信息，如果有一条命令，它的成功执行的返回码不是0，你或许这样做
tasks:
  - name: run this command and ignore the result
  shell: /usr/bin/somecommand || /bin/true

或者：
tasks:
  - name: run this command and ignore the result
    shell: /usr/bin/somecommand
    ignore_errors: True 

# 如果action太长，可以使用space（空格）或者indent（缩进）隔开连续的一行
tasks:
  - name: copy ansible inventory file to client 
    copy: src=/etc/ansible/hosts dest=/etc/ansible/hosts
    		owner=root group=root mode=0644

# 在action行中可以使用变量。假设'vars'那里定义了一个变量'vhost'，可以如下使用：
tasks:
  - name: create a virtual host file for {{ vhost }}
    template: src=somefile.j2 dest=/etc/httpd/conf.d/{{ vhost }}


# 3.Handlers 在发生改变时执行的操作
# （当发生改动时）’notify’ actions 会在 playbook 的每一个 task 结束时被触发,而且即使有多个不同的 task 通知改动的发生, ‘notify’ actions 只会被触发一次.
handlers:
  - name: restart memcached
    service: name=memcached state=restarted
  - name: restarted apache
    service: name=apache state=restarted

---
- hosts: webservers
  tasks:
    - name: template configuration file
      template: src=template.j2 dest=/etc/foo.conf
      notify:
        - restart memcached
        - restart apache

# Handlers 最佳的应用场景是用来重启服务,或者触发系统重启操作.除此以外很少用到了.

# 3.执行playbook
ansible-playbook playbook.yml -f 10

ansible-playbook playbook.yml --list-hosts # 查看该playbook执行会影响哪些hosts

