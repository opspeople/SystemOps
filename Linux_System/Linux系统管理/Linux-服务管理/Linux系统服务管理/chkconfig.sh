#!/usr/bin/env sh
/usr/sbin/chkconfig

# chkconfig命令主要用来更新（启动或停止）和查询系统服务的运行级信息。
# 谨记chkconfig不是立即自动禁止或激活一个服务，它只是简单的改变了符号连接。
# 用法
usage:   chkconfig [--list] [--type <type>] [name]
         chkconfig --add <name>
         chkconfig --del <name>
         chkconfig --override <name>
         chkconfig [--level <levels>] [--type <type>] <name> <on|off|reset|resetpriorities>

# 参数说明
--add 	# 增加所指定的系统服务，让chkconfig指令得以管理它，并同时在系统启动的叙述文件内增加相关数据。
--del 	# 删除所指定的系统服务，不再由chkconfig指令管理，并同时在系统启动的叙述文件内删除相关数据。
--level # <等级代号> 　指定读系统服务要在哪一个执行等级中开启或关毕

# 各等级示意：
# 等级0表示：表示关机
# 等级1表示：单用户模式
# 等级2表示：无网络连接的多用户命令行模式
# 等级3表示：有网络连接的多用户命令行模式
# 等级4表示：不可用
# 等级5表示：带图形界面的多用户模式
# 等级6表示：重新启动

# level选项可以指定要查看的运行级而不一定是当前运行级。
# 对于每个运行级，只能有一个启动脚本或者停止脚本。
# 当切换运行级时，init不会重新启动已经启动的服务，也不会再次去停止已经停止的服务。

# chkconfig –list [name]：显示所有运行级系统服务的运行状态信息（on或off）。如果指定了name，那么只显示指定的服务在不同运行级的状态。
# chkconfig –add name：增加一项新的服务。chkconfig确保每个运行级有一项启动(S)或者杀死(K)入口。如有缺少，则会从缺省的init脚本自动建立。
# chkconfig –del name：删除服务，并把相关符号连接从/etc/rc[0-6].d删除。
# chkconfig [--level levels] name：设置某一服务在指定的运行级是被启动，停止还是重置。

# 运行级文件：
# 每个被chkconfig管理的服务需要在对应的init.d下的脚本加上两行或者更多行的注释。第一行告诉chkconfig缺省启动的运行级以及启动和 停止的优先级。如果某服务缺省不在任何运行级启动，那么使用 – 代替运行级。第二行对服务进行描述，可以用\ 跨行注释。
# 例如，random.init包含三行：
# chkconfig: 2345 20 80
# description: Saves and restores system entropy pool for \
# higher quality random number generation.

# 使用范例
chkconfig –list        #列出所有的系统服务
chkconfig –add httpd        #增加httpd服务
chkconfig –del httpd        #删除httpd服务
chkconfig –level httpd 2345 on        #设置httpd在运行级别为2、3、4、5的情况下都是on（开启）的状态
chkconfig –list        #列出系统所有的服务启动情况
chkconfig –list mysqld        #列出mysqld服务设置情况
chkconfig –level 35 mysqld on        #设定mysqld在等级3和5为开机运行服务，–level 35表示操作只在等级3和5执行，on表示启动，off表示关闭
chkconfig mysqld on        #设定mysqld在各等级为on，“各等级”包括2、3、4、5等

# 如何增加一个服务：
1.服务脚本必须存放在/etc/ini.d/目录下；
2.chkconfig –add servicename
在chkconfig工具服务列表中增加此服务，此时服务会被在/etc/rc.d/rcN.d中赋予K/S入口了；
3.chkconfig –level 35 mysqld on