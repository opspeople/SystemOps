[root@localhost ~]# vi /etc/rsyslog.conf
#查看配置文件的内容
#rsyslog v5 configuration file
# For more information see /usr/share/doc/rsyslog-*/rsyslog_conf.html
# If you experience problems, see http://www.rsyslog.com/doc/troubleshoot.html
### MODULES ###
#加载棋块
$ModLoad imuxsock # provides support for local system logging (e.g. via logger command)
#加载imixsock模块，为本地系统登录提供支持
$ModLoad imklog # provides kernel logging support (previously done by rklogd)
#加载imklog模块，为内核登录提供支持
$ModLoad immark # provides --MARK-- message capability
#加载immark模块，提供标记信息的能力
# Provides UDP syslog reception
$ModLoad imudp
SUDPServerRun 514
#加载UPD模块，允许使用UDP的514端口接收采用UDP协议转发的日志
# Provides TCP syslog reception
$ModLoad imtcp
$InputTCPServerRun 514
#加栽TCP摸块,允许使用TCP的514编口接收采用TCP协议转发的日志


#### GLOBAL DIRECTIVES ####
#定义全局设置
# Where to place auxiliary files
$WorkDirectory /var/lib/rsyslog
#Use default timestamp format
$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat #定义曰志的时间使用默认的时间戳格式
#File syncing capability is disabled by default. This feature is usually not required,
#not useful and an extreme performance hit
$ActionFileEnableSync on
#文件同步功能。默认没有开启,是注释的
#Include all config files in /etc/rsyslog.d/
$IncludeConfig /etc/rsyslog.d/*.conf
#包含/etx/tsyslog.d/目录中所有的".conf"子配置文件。也就是说，这个目录中的所有子配置文件也同时生效
#$OmitLocalLogging on
#$IMJournalStateFile imjournal.state

#### RULES ####
#日志文件保存规则
#Log all kernel messages to the console.
#Logging much else clutters up the screen.
#kern.* /dev/console
#kern服务.所有曰志级别 保存在/dev/console
#这个日志默认没有开启,如果需要，则取消注释
#Log anything (except mail) of level info or higher.
#Don't log private authentication messages!
*.info;mail.none;authpriv.none;cron.none /var/log/messages
#所有服务.info以上级到的日志保存在/var/log/messages日志文件中
#mail, authpriv^ cron的日志不记录在/var/log/messages曰志文件中，因为它们都有自己的曰志文件
#所以/var/log/messages日志是最重要的系统日志文件，需要经常查看
#The authpriv file has restricted access.
authpriv.* /var/log/secure
#用户认证服务所有级别的日志保存在/vai/1og/secure日志文件中

#Log all the mail messages in one place.
mail.* -/var/log/maillog
#mail服务的所有级别的日志保存在/var/log/maillog 日志文件中
#"-"的含义是日志先在内存中保存.当曰志足够多之后.再向文件中保存

# Log cron stuff
cron.* /var/log/cron
#计対任务的所有日志保存在/var/log/cron日志文件中

# Everybody gets emergency messages
#所有日志服务的疼痛等级日志对所有在线用户广播
#Save news errors of level crit and higher in a special file. uucp,news.crit /var/log/spooler
#uucp和news曰志服务的crit以上级别的日志保存在/var/log/sppoler曰志文件中

#Save boot messages also to boot.log
local7.* /var/log/boot.log
#loacl7 日志服务的所有日志写入/var/log/boot.log 日志文件中 #会把开机时的检测信息在显示到屏幕的同时写入/var/log/boot.log 日志文件中

# ### begin forwarding rule ###
#定义转发规到
#The statement between the begin ... end define a SINGLE forwarding
#rule. They belong together, do NOT split them. If you create multiple
# forwarding rules, duplicate the whole block!
# Remote Logging (we use TCP for reliable delivery)
#
# An on-disk queue is created for this action. If the remote host is
# down, messages are spooled to disk and sent when it is up again. 
#SWorkDirectory /var/lib/rsyslog # where to place spool files
 
#$ActionQueueFileName fwdRulel # unique name prefix for spool files
#$ActionQueueMaxDiskSpace 1g # 1gb space limit (use as much as possible)
#$ActionQueueSaveOnShutdown on # save messages to disk on shutdown
#$ActionQueueType LinkedList t run asynchronously
#$ActionResumeRetryCount -1 # infinite retries if host is down
# remote host is: name/ip:port, e.g. 192.168.0.1:514, port optional 
#*•* @6remote-host:514
# ### end of the forwarding rule ##