#!/bin/bash
rsync功能：
    可以保存整个目录树和文件系统
    可以增量同步数据
    可以保留原文件的权限、时间等属性
    加密传输数据
    可以使用rcp\ssh等方式传输文件（也可直接通过socket传输）
    支持匿名传输

rsync的传输模式：
    ssh模式
    daemon模式，以daemon方式运行时rsync server会卡一个873端口，等待客户端去连接，连接时，rsync server
    会检查口令是否相符，若通过口令查核，则可以通过进行文件传输，第一次连通完成时，会把整份文件传输一次，以后则只进行增量备份；

四种工作模式：
    1.本地模式
        rsync -av testdir /tmp/
        包括testdir目录一起复制过去
    
    2.远程模式
        本地复制到远程test目录下
            rsync -av testdir 192.168.1.2:test
    
    3.查询模式
        查看本地文件
            rsync -a 192.168.1.2:test
    
    4.服务器模式
        rsync在后台启动一个守护进程，这个守护进程在服务端永久运行，用于接收文件传输请求。客户端可以把文件传输给守护进程，也可以向守护进程请求文件。
        -a,--archive 归档模式，以递归方式传输文件，并保持所有文件的属性
        -v,--verbose 输出详细信息模式

服务器模式配置介绍
    服务端配置：
        yum -y install rsync 
        cat /etc/rsyncd.conf
        uid=nobody
        gid=nobody
        use chroot=no
        max connections=100
        strict modes=yes
        pid file=/var/run/rsyncd.pid
        lock file=/var/run/rsync.lock
        log file=/var/log/rsyncd.log
        port=873

        [data01]
        path=/data
        ignore errors
        read only=no
        hosts allow=192.168.1.2 192.168.1.3
        hosts deny=*
        list=false
        uid=root 
        gid=root 
        auth users=testuser01
        secrets file=/etc/rsyncd.secrets

        cat /etc/rsyncd.secrets
        testuser01:password01

        /etc/rsyncd.secrets为密码文件，内容: testuser01:password01 
        chmod 600 /etc/rsyncd.secrets

        启动rsync服务端
        /usr/bin/rsync --daemon

        开机启动rsync，把/usr/local/rsync –daemon加入文件/etc/rc.local

    客户端配置：
        创建rsyncd.pass文件
        cat /etc/rsyncd.pass 
        password01

        从服务端拉取文件(拉取data01目录下得testdir01目录)：
            rsync -a testuser01@ServerIP::data01/testdir01 /data --password-file=/etc/rsyncd.pass 
        
        同步目录：
            rsync -a testuser01@ServerIP::data01 /data --password-file=/etc/rsyncd.pass
        
        上传文件：
            rsync -a /data/testfile.txt testuser01@ServerIP::data01 --password-file=/etc/rsyncd.pass


        上传指定服务端端口： --port=21
    

同步log脚本:
#!/bin/bash

myTime=$1

if [ -z $myTime ];then
    myTime=`date +'%Y-%m-%d' -d "-1 day"`
fi

#获取IP
ip=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`

#上传文件并重命名文件，加上ip后缀。${ip##*.}为获取ip最后一个.之后的数字
#这么做是为了集群部署上传的log名称不会冲突
rsync -a /logs/mstore.log.$myTime backup@10.127.92.181::log_8281/log/mstore_${ip##*.}.log.$myTime --password-file=/etc/backupserver.pass --port=8088


rsync参数详解：
-a、--archive参数表示存档模式，保存所有的元数据，比如修改时间（modification time）、权限、所有者等，并且软链接也会同步过去。

--append参数指定文件接着上次中断的地方，继续传输。

--append-verify参数跟--append参数类似，但会对传输完成后的文件进行一次校验。如果校验失败，将重新发送整个文件。

-b、--backup参数指定在删除或更新目标目录已经存在的文件时，将该文件更名后进行备份，默认行为是删除。更名规则是添加由--suffix参数指定的文件后缀名，默认是~。

--backup-dir参数指定文件备份时存放的目录，比如--backup-dir=/path/to/backups。

--bwlimit参数指定带宽限制，默认单位是 KB/s，比如--bwlimit=100。

-c、--checksum参数改变rsync的校验方式。默认情况下，rsync 只检查文件的大小和最后修改日期是否发生变化，如果发生变化，就重新传输；使用这个参数以后，则通过判断文件内容的校验和，决定是否重新传输。

--delete参数删除只存在于目标目录、不存在于源目标的文件，即保证目标目录是源目标的镜像。

-e参数指定使用 SSH 协议传输数据。

--exclude参数指定排除不进行同步的文件，比如--exclude="*.iso"。

--exclude-from参数指定一个本地文件，里面是需要排除的文件模式，每个模式一行。

--existing、--ignore-non-existing参数表示不同步目标目录中不存在的文件和目录。

-h参数表示以人类可读的格式输出。

-h、--help参数返回帮助信息。

-i参数表示输出源目录与目标目录之间文件差异的详细情况。

--ignore-existing参数表示只要该文件在目标目录中已经存在，就跳过去，不再同步这些文件。

--include参数指定同步时要包括的文件，一般与--exclude结合使用。

--link-dest参数指定增量备份的基准目录。

-m参数指定不同步空目录。

--max-size参数设置传输的最大文件的大小限制，比如不超过200KB（--max-size='200k'）。

--min-size参数设置传输的最小文件的大小限制，比如不小于10KB（--min-size=10k）。

-n参数或--dry-run参数模拟将要执行的操作，而并不真的执行。配合-v参数使用，可以看到哪些内容会被同步过去。

-P参数是--progress和--partial这两个参数的结合。

--partial参数允许恢复中断的传输。不使用该参数时，rsync会删除传输到一半被打断的文件；使用该参数后，传输到一半的文件也会同步到目标目录，下次同步时再恢复中断的传输。一般需要与--append或--append-verify配合使用。

--partial-dir参数指定将传输到一半的文件保存到一个临时目录，比如--partial-dir=.rsync-partial。一般需要与--append或--append-verify配合使用。

--progress参数表示显示进展。

-r参数表示递归，即包含子目录。

--remove-source-files参数表示传输成功后，删除发送方的文件。

--size-only参数表示只同步大小有变化的文件，不考虑文件修改时间的差异。

--suffix参数指定文件名备份时，对文件名添加的后缀，默认是~。

-u、--update参数表示同步时跳过目标目录中修改时间更新的文件，即不同步这些有更新的时间戳的文件。

-v参数表示输出细节。-vv表示输出更详细的信息，-vvv表示输出最详细的信息。

--version参数返回 rsync 的版本。

-z参数指定同步时压缩数据
