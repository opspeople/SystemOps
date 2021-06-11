#!/bin/bash

# CentOS7 中的Systemd的Unit文件配置说明
# 参考链接：https://mp.weixin.qq.com/s/Xc6BzlcHldYDEygkbdresQ
# Systemd使用单元(Units)来管理系统服务和程序。
# 系统单元使用配置文件来控制其相关操作。
# 单元配置文件有三种类型：默认单元配置文件，系统特定的单元配置文件和运行时的单元配置文件。

# 默认单元配置文件
	# /usr/lib/systemd/system 
	# 当安装新软件包时，在安装过程中，单元配置文件会在/usr/lib/systemd/system目录中生成。
# 运行时单元配置文件
	# /run/systemd/system
	# 分别在units启动和停止时，会自动生成和删除
# 系统特定的配置文件
	# /etc/systemd/system
	# 包含定制的单元配置。通过这些配置文件，用户可以覆盖units的默认行为。

当我们对系统服务和程序的状态进行任何更改时，例如：start, stop, enable, 和disable时，systemd读取并执行其单元配置文件。按照以下顺序检查单元配置文件。
系统特定的单元配置文件、运行时单元配置文件、默认单元配置文件。
 
Unit配置文件书写格式
一个单元配置文件包含控制该单元的所有必需信息，例如；启动Units文件的路径，在Units之前和之后需要启动的 service/units 的名称，文档、手册的位置，依赖项信息，冲突信息等。
Unit配置文件中的信息通常分为三部分。[Unit]，[Type], [Install]。
下面寻找一个Unit配置文件来解释：

[root@localhost ~]# cat /usr/lib/systemd/system/sshd.service 
[Unit]
Description=OpenSSH server daemon
Documentation=man:sshd(8) man:sshd_config(5)
After=network.target sshd-keygen.target
Wants=sshd-keygen.target

[Service]
Type=notify
EnvironmentFile=-/etc/crypto-policies/back-ends/opensshserver.config
EnvironmentFile=-/etc/sysconfig/sshd
ExecStart=/usr/sbin/sshd -D $OPTIONS $CRYPTO_POLICY
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure
RestartSec=42s

[Install]
WantedBy=multi-user.target

Unit部分

该部分通常包含 描述、文档、与其他程序依赖的设置、包括在什么服务 之前 或者 之后 启动该Units的设置等。

Description: 该语句提供简要的描述。可以在systemctl list-units或者systemctl status [Units]时看到描述。

Documentation: 该语句提供手册（帮助文档）页面的位置以及访问手册页面的命令。

After: 该语句列出了在该单元之后应激活的单元。仅仅是规范服务启动的顺序，并没有强制要求启动。

Before: 该语句列出了在该单元之前应激活的单元。仅仅是规范服务启动的顺序，并没有强制要求启动。

Wants: 定义该单元启动之后还需要启动哪些unit。

Requires: 明确了定义该单元需要在哪个单元启动之前才能启动，如果前面的unit没有启动，那么该unit也不会被启动。

Conflicts: 该语句列出了在启动该单元之前必须停止的单元/服务。

一个单元的After/Before语句定义了该单元应该启动的顺序。一个单元的want/Requires语句定义了该单元的依赖关系。



Type部分

该部分表示Unit的类型。类型有[Service],[Socket],[Timer],[Mount],[Path]等类型，本文中使用的是sshd.service当例子，所以这边就使用[Service]类型来介绍。
下面列举常用语句：

Type : 表示启动的类型，有以下几种类型：simple为默认值、forking、oneshot等类型。

EnvironmentFile: 可以有多个该语句、后面跟配置文件。

ExecStart: 后面接启动的语句

ExecStop: 后面接停止服务的语句

ExecReload: 后面接重启服务的语句

KillMode: 该语句如果是process，当终止进程时，它会终止主程序。如果时none时，则不会关闭程序。

Install部分

该部分时将此Unit安装到哪一个target中去。常用会安装在multi-user.target
WantedBy: 自动启动该Unit的Target名称。例如，如果在此语句中看到multi-user.target，则意味着当系统进入“multi-user.target”运行级别时，此Unit将自动启动。
可以看到，当执行systemctl enable sshd.service时，会将sshd.service从/usr/lib/systemd/system目录中创建超链接到/etc/systemd/system/multi-user.target.wants下面。