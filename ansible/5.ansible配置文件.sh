#!/usr/bin/env ansible
# 1.ansible配置文件读取顺序
ANSIBLE_CONFIG 	# 环境变量
ansible.cfg 	# 当前目录
.ansible.cfg	# 当前用户家目录中
/etc/ansible/ansible.cfg	# ansible默认配置文件

# 2.配置文件不同段详解
[defaults]	# 通用默认段
action_plugins 	# “行为”是 ansible中的一段代码,用来激活一些事件,例如执行一个模块,一个模版,等等
	action_plugins = ~/.ansible/plugins/action_plugins/:/usr/share/ansible_plugins/action_plugins

ansible_managed	# 设置可以哪个用户修改和修改时间,这个设置可以告知用户,Ansible修改了一个文件,并且手动写入的内容可能已经被覆盖
	ansible_managed = Ansible managed: {file} modified on %Y-%m-%d %H:%M:%S by {uid} on {host}

ask_pass		# 这个可以控制,Ansible 剧本playbook 是否会自动默认弹出弹出密码.默认为no::
	ask_pass=True

ask_sudo_pass	# 类似 ask_pass,用来控制Ansible playbook 在执行sudo之前是否询问sudo密码.默认为no
	ask_sudo_pass=True

bin_ansible_callbacks	# 用来控制callback插件是否在运行 /usr/bin/ansible 的时候被加载,这个模块将用于命令行的日志系统,发出通知等特性. Callback插件如果存在将会永久性的被 /usr/bin/ansible-playbook 加载,不能被禁用
	bin_ansible_callbacks=False

callback_plugins	# Callbacks 在ansible中是一段代码,在特殊事件时将被调用.并且允许出发通知. 这是一个以开发者为中心的特性,可以实现对Ansible的底层拓展,并且拓展模块可以位于任何位置
	callback_plugins = ~/.ansible/plugins/callback_plugins/:/usr/share/ansible_plugins/callback_plugins

command_warnings	# 从Ansible 1.8 开始,当shell和命令行模块被默认模块简化的时,Ansible 将默认发出警告.
	command_warnings = False

connection_plugins	# 连接插件允许拓展ansible拓展通讯信道,用来传输命令或者文件. 这是一个开发者中心特性,拓展插件可以从任何不同地方加载
	connection_plugins = ~/.ansible/plugins/connection_plugins/:/usr/share/ansible_plugins/connection_plugins

deprecation_warnings	# 允许在ansible-playbook输出结果中禁用“不建议使用”警告
	deprecation_warnings = True

display_skipped_hosts	# 如果设置为`False`,ansible 将不会显示任何跳过任务的状态.默认选项是现实跳过任务的状态
	display_skipped_hosts=True

error_on_undefined_vars	# 从Ansible 1.3开始,这个选项将为默认,如果所引用的变量名称错误的话, 将会导致ansible在执行步骤上失败
	error_on_undefined_vars=True

executable # 这个选项可以在sudo环境下产生一个shell交互接口. 用户只在/bin/bash的或者sudo限制的一些场景中需要修改.大部分情况下不需要修改
	executable = /bin/bash

filter_plugins	# 开发者核心的特性,允许Ansible从任何地方载入底层拓展模块
	filter_plugins = ~/.ansible/plugins/filter_plugins/:/usr/share/ansible_plugins/filter_plugins

force_color		# 到没有使用TTY终端的时候，这个选项当用来强制颜色模式
	force_color=1

force_handlers	# 即便这个用户崩溃,这个选项仍可以继续运行这个用户
	force_handlers = True

forks	# 与主机通信时的默认并行进程数
	_forks=5

gathering 
hash_behaviour	# 
	hash_behaviour=replace	# 合法的值为’replace’(默认值)或者‘merge’.

host_key_checking	# 在Ansible 1.3或更新版本中将会检测主机密钥
	host_key_checking=True

inventory	# 默认库文件位置,脚本,或者存放可通信主机的目录
	inventory = /etc/ansible/hosts

jinja2_extensions
	jinja2_extensions = jinja2.ext.do,jinja2.ext.i18n

library	# ansible默认搜寻模块的位置
	library = /usr/share/ansible

log_path # Ansible 将会在选定的位置登陆执行信息.请留意用户运行的Ansible对于logfile有权限
	log_path=/var/log/ansible.log

lookup_plugins # 允许模块插件在不同区域被加载
	lookup_plugins = ~/.ansible/plugins/lookup_plugins/:/usr/share/ansible_plugins/lookup_plugins

module_lang

module_name # 这个是/usr/bin/ansible的默认模块名（-m）. 默认是’command’模块. 之前提到过,command模块不支持shell变量,管道,配额. 所以也许你希望把这个参数改为’shell
	module_name = command

nocolor # 默认ansible会为输出结果加上颜色,用来更好的区分状态信息和失败信息.如果你想关闭这一功能,可以把’nocolor’设置为‘1’:
	nocolor=0

nocows # 默认ansible可以调用一些cowsay的特性,使得/usr/bin/ansible-playbook运行起来更加愉快.为啥呢,因为我们相信系统应该是一 比较愉快的经历.如果你不喜欢cows,你可以通通过将’nocows’设置为‘1’来禁用这一选项
	nocows=0

pattern	# 如果没有提供“hosts”节点,这是playbook要通信的默认主机组.默认值是对所有主机通信,如果不想被惊吓到,最好还是设置个个选项
	hosts=*

poll_interval # 对于Ansible中的异步任务,这个是设置定义,当具体的poll interval 没有定义时,多少时间回查一下这些任务的状态, 默认值是一个折中选择15秒钟.这个时间是个回查频率和任务完成叫回频率和当任务完成时的回转频率的这种
	poll_interval=15

private_key_file	# 如果你是用pem密钥文件而不是SSH 客户端或秘密啊认证的话,你可以设置这里的默认值,来避免每一次提醒设置密钥文件位置``–ansible-private-keyfile``
	private_key_file=/path/to/file.pem

remote_port # 这个设置是你系统默认的远程SSH端口,如果不指定,默认为22号端口
	remote_port=22

remote_tmp	# Ansible 通过远程传输模块到远程主机,然后远程执行,执行后在清理现场.在有些场景下,你也许想使用默认路径希望像更换补丁一样使用, 这时候你可以使用这个选项
	remote_tmp = $HOME/.ansible/tmp

remote_user # 这是个ansible使用/usr/bin/ansible-playbook链接的默认用户名. 注意如果不指定,/usr/bin/ansible默认使用当前用户名称
	remote_user = root

roles_path # roles 路径指的是’roles/’下的额外目录,用于playbook搜索Ansible roles.比如, 如果我们有个用于common roles源代码控制仓库和一个不同的 playbooks仓库,你也许会建立一个惯例去在 /opt/mysite/roles 里面查找roles
	roles_path = /opt/mysite/roles
			# 多余的路径可以用冒号分隔,类似于其他path字符串
	roles_path = /opt/mysite/roles:/opt/othersite/roles

sudo_exe # 如果在其他远程主机上使用另一种方式执行sudo草做, sudo程序的路径可以用这个参数更换,使用命令行标签来拟合标准sudo
	sudo_exe=sudo

sudo_flags # sudo支持的时候,传递给sudo而外的标签. 默认值为”-H”, 意思是保留原用户的环境.在有些场景下也许需要添加或者删除 标签,大多数用户不需要修改这个选项
	sudo_flags=-H

sudo_user # sudo使用的默认用户,如果``–sudo-user`` 没有特指或者’sudo_user’ 在Ansible playbooks中没有特指,在大多数的逻辑中 默认为: ‘root’
	sudo_user=root

system_warnings # 允许禁用系统运行ansible相关的潜在问题警告（不包括操作主机）
	system_warnings = True

timeout # 这个事默认SSH链接尝试超市时间
	timeout=10

transport 

vars_plugins # 这是一个开发者中心选项,允许底层拓展模块从任何地方加载
	vars_plugins = ~/.ansible/plugins/vars_plugins/:/usr/share/ansible_plugins/vars_plugins

valut_password_file	# 这个用来设置密码文件,也可以通过命令行指定``–vault-password-file``
	vault_password_file = /path/to/vault_password_file

[paramiko] # paramiko配置段
record_host_keys # 默认设置会记录并验证通过在用户hostfile中新发现的的主机（如果host key checking 被激活的话）. 这个选项在有很多主机的时候将会性能很差.在 这种情况下,建议使用SSH传输代替. 当设置为False时, 性能将会提升,在hostkey checking 被禁用时候,建议使用
	record_host_keys=True

[ssh_connection] # SSH设置段
ssh_args # 如果设置了的话,这个选项将会传递一组选项给Ansible 然不是使用以前的默认值
	ssh_args = -o ControlMaster=auto -o ControlPersist=60s
	# 用户可以提高ControlPersist值来提高性能.30 分钟通常比较合适.

control_path # 这个是保存ControlPath套接字的位置. 默认值是
	control_path=%(directory)s/ansible-ssh-%%h-%%p-%%r

scp_if_ssh # 又是用户操控一个一个没有开启SFTP协议的远程系统.如果这个设置为True,scp将代替用来为远程主机传输文件
	scp_if_ssh=False

pipelining 	# 在不通过实际文件传输的情况下执行ansible模块来使用管道特性,从而减少执行远程模块SSH操作次数.如果开启这个设置,将显著提高性能. 然而当使用”sudo:”操作的时候, 你必须在所有管理的主机的/etc/sudoers中禁用’requiretty’.
			# 默认这个选项为了保证与sudoers requiretty的设置（在很多发行版中时默认的设置）的兼容性是禁用的. 但是为了提高性能强烈建议开启这个设置
	pipelining=False

