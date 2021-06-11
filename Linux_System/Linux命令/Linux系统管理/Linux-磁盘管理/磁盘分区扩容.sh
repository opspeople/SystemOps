#!/usr/bin/env sh
# 1.查看目前的使用情况
[root@localhost Desktop]# df -h
Filesystem               Size  Used Avail Use% Mounted on
/dev/mapper/centos-root   50G  3.4G   47G   7% /
devtmpfs                 902M     0  902M   0% /dev
tmpfs                    917M  144K  917M   1% /dev/shm
tmpfs                    917M  9.0M  908M   1% /run
tmpfs                    917M     0  917M   0% /sys/fs/cgroup
/dev/mapper/centos-home   48G   33M   48G   1% /home
/dev/sda1                497M  158M  340M  32% /boot
tmpfs                    184M   12K  184M   1% /run/user/0
# /dev/mapper/centos-root 大小50G我们增大3G

# 2.添加新的磁盘/dev/sdb
[root@localhost Desktop]# fdisk -l

Disk /dev/sda: 107.4 GB, 107374182400 bytes, 209715200 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x0005efd6

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048     1026047      512000   83  Linux
/dev/sda2         1026048   209715199   104344576   8e  Linux LVM

Disk /dev/mapper/centos-root: 53.7 GB, 53687091200 bytes, 104857600 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/centos-swap: 2147 MB, 2147483648 bytes, 4194304 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/centos-home: 50.9 GB, 50944016384 bytes, 99500032 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/sdb: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0xf0480a7c

   Device Boot      Start         End      Blocks   Id  System

# 3.分区新磁盘
fdisk /dev/sdb

　　fdisk的交互模式，依次输入

n  --创建新分区
p  --创建主分区
<回车>  --默认分区编号
<回车>  --默认起始扇区位置。
<回车>  --默认结束扇区位置。
t  --设置分区类型
8e  类型为LVM
w  --写入分区表

# 4.查看新磁盘分区情况
[root@localhost Desktop]# fdisk -l /dev/sdb

Disk /dev/sdb: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0xf0480a7c

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048    41943039    20970496   8e  Linux LVM

# 5.查看卷分组
[root@localhost Desktop]# vgdisplay -v   ##找到centos
    Using volume group(s) on command line.
  --- Volume group ---
  VG Name               centos
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  4
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                3
  Open LV               3
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               99.51 GiB
  PE Size               4.00 MiB
  Total PE              25474
  Alloc PE / Size       25458 / 99.45 GiB
  Free  PE / Size       16 / 64.00 MiB
  VG UUID               eajt4v-Jdef-HZmX-U6AL-kOTp-lc1w-nHXcBe

# 6.为新增的分区创建物理卷
[root@localhost Desktop]# pvcreate /dev/sdb1
##提示是否擦除xfs签名，可以根据实际情况选择
WARNING: ext4 signature detected on /dev/sdb1 at offset 1080. Wipe it? [y/n]: y
  Wiping ext4 signature on /dev/sdb1.
  Physical volume "/dev/sdb1" successfully created

# 7.查看结果
[root@localhost Desktop]# pvdisplay /dev/sdb1
##可以看到新创建的20GiB大小的物理卷：
  "/dev/sdb1" is a new physical volume of "20.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/sdb1
  VG Name               
  PV Size               20.00 GiB
  Allocatable           NO
  PE Size               0   
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               JSpfvR-zsge-XRVU-CRT2-ubec-LcmO-oZtxmD

# 8.扩展卷分组，"centos"是vgdisplay命令查到的卷分组名
[root@localhost Desktop]# vgextend centos /dev/sdb1
  Volume group "centos" successfully extended

# 9.查看逻辑卷，并扩展逻辑卷
lvdisplay

　　可以看到/dev/centos/root目前的LV Size是50G。
[root@localhost Desktop]# lvextend -L +3G /dev/centos/root
Size of logical volume centos/root changed from 50.00 GiB (12800 extents) to 53.00 GiB (13568 extents).
Logical volume root successfully resized.
　　注：+3G是我们要新增加的分区大小。

# 10.扩展后执行
[root@localhost Desktop]# xfs_growfs /dev/centos/root
meta-data=/dev/mapper/centos-root isize=256    agcount=4, agsize=3276800 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0        finobt=0
data     =                       bsize=4096   blocks=13107200, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal               bsize=4096   blocks=6400, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
data blocks changed from 13107200 to 13893632
　　
     将文件系统扩大，完成。

　　因为安装CentOS用的xfs分区，所以使用命令xfs_growfs扩展文件系统大小。xfs_growfs 同步文件系统

# 11.查看结果
[root@localhost Desktop]# df -hT
Filesystem              Type      Size  Used Avail Use% Mounted on
/dev/mapper/centos-root xfs        53G  3.4G   50G   7% /
devtmpfs                devtmpfs  902M     0  902M   0% /dev
tmpfs                   tmpfs     917M  144K  917M   1% /dev/shm
tmpfs                   tmpfs     917M  9.0M  908M   1% /run
tmpfs                   tmpfs     917M     0  917M   0% /sys/fs/cgroup
/dev/mapper/centos-home xfs        48G   33M   48G   1% /home
/dev/sda1               xfs       497M  158M  340M  32% /boot
tmpfs                   tmpfs     184M   12K  184M   1% /run/user/0
