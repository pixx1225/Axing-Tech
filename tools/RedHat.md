[TOC]

## RHCE

RHCE=RH124+RH134+RH294

RH124+RH134=RH199=EX200=RHCSA=3h

RH294=EX294=RHCE=4h

rht-vmctl reset all

rht-vmctl start all

rht-vmview view all

RHEL（Red Hat Enterprise Linux）

### 第一章：登录系统并获得帮助

#### 访问命令行

RHEL8种默认使用的shell叫Bash

shell版本有bash和sh

cat /etc/shells 查看系统可用的shell

echo $SHELL   查看系统默认的shell，就是 /bin/bash

普通用户提示符是：$，超级用户提示符是：#

shell退出：exit    ctrl+D

#### 使用桌面

RHEL8默认使用的图形化叫GNOME

Rocky Linux

#### 使用bash shell执行命令

ls -lrt

command1;command2    #多个命令

date +%Y%m%d    #显示 20230422

passwd    #更改用户自己的密码

file /etc/passwd    #file命令显示该文件的类型

more less head tail

wc  -l 行数 -w 字数 -c 字符数

tab补全

长命令换行书写使用反斜杠字符 \

查看历史命令history     ctrl + r 

#### OpenSSH服务

Open Secure Shell的简称，ssh使用的是加密传输

安装包名是openssh，服务是sshd，监听端口是22，使用的命令是ssh

ssh root@server

**免密登录**

密钥使用的是非对称加密，分为私钥和公钥

​	私钥放在本机端，公钥放在要登录的远端

​	使用ssh-keygen命令生成密钥对，私钥放在~/.ssh/id_rsa，公钥放在~/.ssh/id_rsa.pub

复制公钥到远端服务器

​	ssh-copy-id root@server

#### 在红帽企业Linux种获取帮助

使用man获取帮助

​	所有的man page都位于、usr/share/man

​	例如 man -f passwd， man 5 passwd

### 第二章：了解Linux文件架构

#### Linux文件系统层次架构

Linux下所有的东西都是文件

FHS标准

rhel8对某些目录做了改进

​	/bin  --  /usr/bin

​	/sbin  --  /usr/sbin

​	/lib --  /usr/lib

​	/lib64  --  /usr/lib64

​	/var/lock  --  /run/lock

​	/var/run  --  /run

man 7 hier

#### 根据名称导航文件

绝对路径和相对路径

路径导航 pwd

#### 使用命令行管理文件和目录

新建 touch/mkdir

查看 cat/more/less/head/tail/ls -l

复制 cp/cp -r

移动 mv

删除 rm/rm -r

#### 制作文件间的链接

硬链接 ln /home/file1 /home/file2  只能是文件 只能同一分区

软链接 ln -s /home/file1 /home/file2 快捷方式 源文件删了软链接都不可用

#### 通配符匹配文件名

echo Today is $(date +%Y%m%d)

单引号 内容所见即所打

双引号 内容变量会替换完再打印

### 第三章：管理本地Linux用户和组

#### 用户和组

cat /etc/passwd

cat /etc/group

#### 获取超级用户权限

1. 超级用户root (0)
2. 普通用户 （1000+）
3. 系统用户 （1-999）

配置sudo的方法

vim /etc/sudoers

sudo -l 用户可以查看自己可以sudo的命令

#### 管理本地用户账户

useradd -u 2000 -g student -G root -s /sbin/nologin devops

passwd devops

echo 'password' | passwd --stdin devops

usermod -L devops

usermod -U devops

userdel devops  清除/etc/passwd，保留家目录

userdel -r devops  清楚用户所有相关

UID

​	0超级管理员root

​	1-200系统用户uid，静态分配给系统进程和常见服务

​	201-999系统用户uid，动态分配给安装用户

​	1000+分配给普通用户

#### 管理本地组账户

groupadd -g 4000 huawei

groupmod -n xiaomi huawei  把华为改成小米

groupmod -g 6000 xiaomi

groupdel xiaomi

#### 管理用户密码

用户信息/etc/passwd

密码信息/etc/shadow

三个$，第一个表示hash算法，1表示MD5，6表示sha512

第二个表示salt，来自/dev/urandom随机数，hash后的密码通过salt加密后，得到第三个字符串

第三个=第一个$hash用户密码后+第二个$salt值

用户密码有效期chage

chage -l tom

chage -m 3 -M 90 -W 7 -I 14 tom

chage -d 0 tom 下次登录强制修改密码

chage -E 2023-06-01 tom 设置用户失效时间

限制访问

1. 锁定用户usermod -L tom
2. 设定用户过期usermod -L -e 1 tom
3. 设置不能登录的shell  usermod -s /sbin/nologin

### 第四章：控制对文件的访问

#### Linux文件系统权限

rwx分别是421

#### 命令行管理文件系统权限

chmod a+x /home/app

chmod -R 755 /home/app/dir

chown tom /home/app 修改所属人

chown :jerry /home/app 修改所属组 =chgrp

chown tom:jerry /home/app 

#### 管理默认权限和文件访问

u+s (suid) 作用在文件上，以拥有文件的用户身份执行文件

g+s (sgid) 作用在目录上，在目录中新建子对象，所属人跟建立人，所属组跟目录所属组

o+t (sticky) 作用在目录上，对目录具有写入权限的用户仅可以删除其所拥有的文件

默认权限

umask   全局/etc/profile和/etc/bashrc 用户~/.bashrc

新建目录权限=777-umask

新建文件权限=666-umask

### 第五章：管理SELinux

#### SELinux概述

是linux的一个安全模块，通过给程序、文件和端口配上各自的标签，如果程序和文件的标签能配上，那程序就能访问文件，如果端口标签和程序的标签能配上，通过端口就能访问程序。标签统称为selinux上下文，使用“类型上下文”来执行规则，以_t结尾。

命令结合-Z参数查看selinux属性，例如ps auxZ，semanage port -l

#### SELinux模式

- 强制模式，记录SElinux的所有日志，并严格执行规则

- 许可模式，记录SElinux的所有日志，但不作任何拦截

- 禁用模式，不记录也不拦截

#### 更改SELinux的模式

getenforce 获取当前模式

setenforce 1 把当前模式设置为强制模式

setenforce 0 把当前模式设置为许可模式

更改默认的SELinux模式，重启生效

vim /etc/selinux/config

​	SELINUX=enforcing

sestatus 查看当前selinux状态

#### 更改文件/目录的SELinux安全上下文

文件父目录的安全上下文决定该文件初始SELinux上下文

chcon 命令可以将文件的安全上下文更改成指定的安全上下文

​	chcon -t httpd_sys_content_t index.html

restorecon 命令使用安全策略中默认规则来确定给文件/目录的安全上下文

​	restorecon -RFvv /virtual

semanage fcontext 命令可以重写文件或目录的默认安全上下文

​	semanage fcontext -a -t httpd_sys_content_t /virtual

​	senamage port -a -t http_port_t -p tcp 9999

/var/log/messages查看日志

#### 更改SELinux布尔值

getsebool -a 查看系统所有的SELinux策略

semanage boolean -l 查看布尔值的当前值和永久值

### 第六章：调优系统性能

#### 监控进程

R运行  S休眠 D不可被终端的休眠状态 T暂停或跟踪状态 Z退出状态或僵尸进程 

x死掉的进程 s父进程 N低优先级进程 <高优先级进程

ps -l 查看自己bash有个的进程

ps aux 查看所有正在内存中的进程

pstree -Aup 查看所有进程的相关性

uptime 查看开机时间和系统负载

top 默认5秒刷新

#### 杀死进程

kill命令  kill -l 查看可用的选项

1挂起，重新加载配置

9强制终止 

15终止，默认 

18继续

19停止

killall -9 httpd 杀死同类进程

pkill -9 -u bob 杀用户-u或终端-t进程

以管理员管理用户

w 命令查看当前登录系统用户及他们的活动

#### 调整调优配置文件

tuned守护进程会在服务启动时或选择新的调优配置文件时应用系统配置

systemctl enable --now tuned

tuned-adm active

tuned-adm profile throughput-proformance

tuned-adm recommend

tuned-adm off

### 第七章：安装和更新软件包

#### 描述RPM软件包

name-version-release-arch.rpm  (noarch不限定架构)

httpd-tools-2.4.6-7.el7.x86_64.rpm

查看rpm包方法

​	rpm -qpl ***.rpm 列表包的内容

​	rpm2cpio ***.rpm | cpio -tv 列出包的内容

#### 使用RPM管理软件包

装包 rpm -ivh ***.rpm

更新包 rpm -Uvh ***.rpm

查看所有安装的包 rpm -qa

查看这个目录时哪个包装的 rpm -q -f /etc/yum.repos.d

删除包 rpm -e ...

#### 使用yum管理软件更新软件

yum repolist查看当前yum库有多少包可以装

yum help 查看帮助

查询

​	yum list http*

​	yum search http

​	yum info httpd

安装

​	yum -y install httpd

​	yum download httpd

​	yum localinstall httpd...rpm

更新

​	yum update 更新所有发现的更新包

​	yum update httpd

删除

​	yum remove httpd 删除其及依赖

​	rpm -e httpd

安装组套件

​	yum grouplist

​	yum groupinfo

​	yum groupinstall

​	yum group remove

​	yum clean all

yum history 查看最近10个安装和卸载历史

/var/log/dnf.rpm.log 查看相关安装和卸载日志

#### 启用yum软件存储库

查看当前yum源

​	yum repolist all

vim /etc/yum.repos.d/rhce.repo

​	[base]

​	name=rhce

​	baseurl=http://content.example.com/....

​	enabled=1

​	gpgcheck=0

yum clean all; yum makecache; yum repolist

yum-config-manager --add-repo="http://www.example.com/rhce"

#### 管理软件包模块流

yum module list

yum module info perl

yum module install perl

yum module install perl:9.6/devel

yum module remove perl

yum module reset perl

### 第八章：管理基本存储

#### 挂载

df -hT

du -sh *

mount /dev/vdb1 /mnt/data; df -hT; mount

去挂载 umount

#### 系统分区

MBR分区方案：主引导记录，BIOS固件，头部引导代码，支持单块硬盘最多四个主分区，最大2T

GPT分区方案：UEFI固件，头尾分区表信息，支持单块硬盘128个分区，最大8ZT

使用PARTED管理分区

​	parted /dev/vda print 显示磁盘上的分区表

​	parted /dev/vdb mklabel msdos 写入MBR磁盘标签，立即生效

​	parted /dev/vdb mklabel gpt 写入GPT磁盘标签，立即生效

lsblk 查看当前磁盘

创建MBR分区

​	parted /dev/vdb 以root用户执行，进入交互界面

​	mkpart 子命令传教新的主分区或扩展分区

​	parted /dev/vdb mkpart primary xfs 2048s 1000MB 非交互

创建GPT分区

​	parted /dev/vdb mkpart partition_name xfs 2048s 1000MB 非交互

创建文件系统

​	两种文件系统类型 xfs和ext4

​	mkfs.xfs /dev/vdb1

​	mkfs.ext4 /dev/vdb2

挂载文件系统

​	mount /dev/vdb1 /mnt

开机自动挂载文件系统

​	vim /etc/fstab

使用fdisk管理MBR分区

```shell
查看-新建-格式化-挂载-使用
lsblk或fdisk -l  查看分区情况
fdisk /dev/vdb 开启交互式分区
	m获取帮助
	p查看当前分区情况
	n新建分区
	t指定分区类型
	w保存写入
partprobe	通知内核
mkfs.ext4 /dev/vdb1	格式化
mkdir /mnt/data  新建文件
mount /dev/vdb1 /mnt/data  挂载
vim /etc/fstab 永久挂载  或者echo '/dev/vdb1 /mnt/data auto defaults 0 0'>> /etc/fstab;mount -a
mount -a 立即生效
lsblk

umount /dev/vdb1  去挂载
fdisk /dev/vdb
	p
	d
	w
partprobe
lsblk
```

使用gdisk管理GPT分区

```shell
查看-新建-格式化-挂载-使用
lsblk或fdisk -l  查看分区情况
gdisk /dev/vdb 开启交互式分区
	?获取帮助
	p查看当前分区情况
	n新建分区
	w保存写入
partprobe	通知内核
mkfs -t xfs /dev/vdb1	格式化
mkdir /mnt/data  新建文件
mount /dev/vdb1 /mnt/data  挂载
vim /etc/fstab 永久挂载  或者echo '/dev/vdb1 /mnt/data auto defaults 0 0'>> /etc/fstab;mount -a
mount -a 立即生效 
lsblk

umount /dev/vdb1  去挂载
gdisk /dev/vdb
	p
	d
	w
partprobe
lsblk
```

#### 交换分区

创建交换分区

```shell
swapon -s 查看当前交换分区
lsblk或fdisk -l  查看分区情况
fdisk /dev/vdb 开启交互式分区
	m获取帮助
	p查看当前分区情况
	n新建分区
	t指定82
	w保存写入
partprobe	通知内核
lsblk
mkswap /dev/vdb1 格式化交换分区
swapon /dev/vdb1 临时挂载
vim /etc/fstab 永久挂载 或者echo '/dev/vdb1 swap swap default 0 0'>> /etc/fstab;swapon -a
swapon -a 立即生效
```

### 第九章：控制服务和守护进程

#### systemV

系统核心第一个执行的程序是init，由init这个脚本程序处理系统服务

- 启动一个服务：/etc/init.d/httpd start或service httpd start
- 重启一个服务：/etc/init.d/httpd restart或service httpd restart
- 关闭一个服务：/etc/init.d/httpd stop或service httpd stop
- 设置开机启动：chkconfig httpd on
- 查看开机启动：chkconfig --list | grep :on

systemV方式下系统的运行等级

- init 0 关机
- init 1 单人维护模式
- init 2 多用户模式，不能使用nfs
- init 3 完全多用户模式，又叫命令行模式
- init 4 安全模式
- init 5 图形化多用户模式
- init 6 重启
- /etc/inittab设置开机进入的模式，man inittab

#### systemd

RHEL7开始弃用systemV方式管理服务，改用systemd方式管理服务

优点：

- 同时处理所有服务，加快开机流程
- 一个命令统一管理，systemctl，init，chkconfig，service
- 依赖自我检查并启动
- 向下兼容init服务，init 0 = systemctl poweroff

同一类型的systemd对象称为单元，systemctl可以管理多种单元

​	systemctl -t help

控制服务，service是服务单元，结尾是.service

控制启动，target是目标单元，结尾是.target

### 第十章：管理网络

#### 验证网络配置

识别网络接口即网卡

​	ip link

​	nmcli device status

显示IP地址

​	ip addr show eth0

​	ip -s link show ech0

检查主机之间的连接

​	ping和ping6

路由调试

​	route -n

​	ip route

​	tracepath

端口和服务调试

​	ss

​	netstat -tluanp

#### 使用nmcli配置网络

NetworkManager，设备 dev，连接 con

使用nmcli查看网络信息

​	nmcli dev status

​	nmcli dev show eth0

​	nmcli con show --active

​	nmcli con show "static-eth0"

通过nmcli创建网络连接

​	nmcli dev status

​	nmcli con add type ethernet con-name "eno2" ifname eno2

通过nmcli修改网络连接

nmcli con mod "eno2" ipv4.addresses "172.25.9.19/24" ipv4.gateway 172.25.0.154 ipv4.dns 8.8.8.8 ipv4.method manual

nmcli con mod "eno2" +ipv4.addresses "172.25.9.10/24"

```shell
nmcli con up 连接名   #激活一个连接
nmcli con down 连接名 #关闭一个连接，可能会被自动激活
nmcli dev dis 设备名  #彻底关闭一块网卡
```

nmtui 图形化

#### 编辑网络配置文件

/etc/sysconfig/network-scripts/ifcfg-name

修改了配置文件后需要重新加载生效

```shell
nmcli con reload
nmcli con down "ens3"
nmcli con up "ens3"
```

#### 配置主机名和名称解析

查看主机名hostname或hostnamectl

设置主机名hostname set-hostname www.163.com

设置主机名vim /etc/hostname

配置DNS

​	vim /etc/hosts

### 第十一章：分析和存储日志

### 第十二章：实施高级存储

#### 逻辑卷管理

LVM 全称logical Volume Management 逻辑卷管理

LVM组件定义

- 物理设备
- 物理卷 PV
- 卷组 VG
- 逻辑卷 LV

创建逻辑卷

​	1. 准备物理设备，使用fdisk或gdisk创建新分区

​	2. 创建物理卷

​		pvs  或 pvdisplay  查看

​		pvcreate /dev/vdb2 /dev/vdc

 3. 创建卷组

    ​	vgs  或 vgdisplay  查看

    ​	vgcreate disk1 /dev/vdb2 /dev/vdc

	4. 创建逻辑卷

    ​	lvs  或 lvdisplay  查看

    ​	lvcreate -L 6G -n lv1 disk1

	5. 格式化并挂载

    ​	mkfs.ext4 /dev/disk1/lv1

    ​	mkdir /mnt/dir2

    ​	echo '/dev/disk1/lv1 /mnt/dir2 auto default 0 0'>> /etc/fstab;mount -a

	6. 扩展

    ​	pvcreate /dev/vdd

    ​	vgextend disk1 /dev/vdd

    ​	lvextend -r -L 10G /dev/disk1/lv1

	7. 去载

    ​	umount /mnt/dir2

    ​	vim /etc/fstab 注释掉

    ​	lvremove /dev/disk1/lv1

    ​	vgremove disk1

    ​	pvremove /dev/vdb2 /dev/vdc /dev/vdd

#### Stratis管理分层存储

#### VDO压缩存储和删除重复数据

vdo虚拟数据优化器

两个模块：kvdo透明的方式控制数据压缩，uds重复数据删除

```shell
1.启动VDO
	安装vdo和kmod-kvdo
	yum list '*vdo*'
	yum install vdo kmod-kvdo
2.创建VDO
	vdo create --name=vdo1 --device=/dev/vdb --vdoLogicalSize=50G
	mkfs.xfs -K dev/mapper/vdo1   mkfs.ext4 -E
	mkdir /mnt/dir3
	echo "/dev/mapper/vdo1 /mnt/dir3 auto default,x-systemd.requires=vdo.service 0 0">> /etc/fstab;mount -a
3.分析VDO卷
	vdo list  vdo start  vdo stop
	vdo status | grep Compression
	vdo status | grep Deduplication
4.查看VDO卷信息
	vdostats --human-readable
```

​	安装

### 第十三章：计划将来的任务

### 第十四章：访问网络附加存储

NFS全称Network Files System网络文件系统

#### 自动挂载网络附加存储

自动挂载器是一种服务，它可以“根据需要”自动挂载NFS共享，并将在不再使用NFS共享时自动卸载这些共享

创建自动挂载

```shell
1.安装autofs软件包
	yum install autofs
2.向/etc/auto.master添加主映射文件
	vim /etc/auto.master
		/shares /etc/auto.demo
3.创建映射文件
	vim /etc/auto.demo
		work -rw,sync serverb:/shares/work
4.重启自动挂载服务
	systemctl restart autofs
	systemctl enable --now autofs
```

直接映射

​	vim /etc/auto.master

​		/- /etc/auto.direct

​	vim /etc/auto.direct

​		/mnt/docs -rw,sync serverb:/shares/docs

间接通配符映射多个目录

​	* -rw,sync serverb:/share/&      #挂载点位置写成通配符*，原位置的写成通配符&

​	重启autofs，此时serverb上/shares目录下的多个子目录就会挂到服务端的/shares/work

### 第十五章：管理网络安全

#### 概述

netfilter和nftables是RHEL8构建防火墙的基础模块

netfilter通过多个使用程序框架进行配置，其中包括iptables、ip6tables、arptables和ebtables

nftables则只是用nft程序，通过一个接口来管理所有协议，由此消除了以往不同前端和多个netfilter接口引起的争抢问题

firewalld是一种与netfilter交互的动态防火墙管理器，将所有的网络流量分为多个区域，从而简化防火墙管理，一个区域就是一个典型的应用场景。

firewall-cmd --getservices 列出预定义服务

#### 配置防火墙

firewall-config软件包可以提供图形化防火墙配置界面

​	yum install firewalld firewall-config

​	systemctl stop nftables; systemctl mask nftables

​	systemctl enable firewalld; systemctl start firewalld

配置方法

​	写文件做配置：/etc/firewalld/zones/*

​	使用命令行做配置：firewall-cmd

​	使用图形化做配置：firewall-config

​	使用cockpit页面配置

使用web控制台配置防火墙服务

使用命令行配置防火墙

```shell
firewall-cmd --state  #查看当前firewalld的状态
firewall-cmd --get-zones  #查看当前防火墙有哪些区域
firewall-cmd --get-default-zone  #查看默认区域
firewall-cmd --set-default-zone=dmz  #设置默认区域，即时生效
firewall-cmd --get-services  #查看所有预定义服务
firewall-cmd --list-all  #查看当前默认区域防火墙
firewall-cmd --list-service  #查看当前防火墙服务
firewall-cmd --zone=work --list-all  #查看当前特定区域防火墙
添加和删除放行http服务的规则
firewall-cmd --add-service=http --permanent; firewall-cmd --reload
firewall-cmd --zone=work --add-source=192.168.0.9/24 --permanent; firewall-cmd --reload
firewall-cmd --remove-service=http --permanent; firewall-cmd --reload
```

vim /etc/firewalld/zones/public.xml

firewall-cmd --reload; firewall-cmd --list-all

#### 控制SELinux端口标记

列出端口标签

​	semanage port -l | grep 80

管理端口标签

​	semanage port -a -t http_port_t -p tcp 8090

### 第十六章：运行容器

#### 介绍容器

#### 运行容器

安装容器管理工具

​	yum module install container-tools

容器的命名

​	registry_name/user_name/image_name:tag

下载镜像

​	podman pull registry.access.redhat.com/ubi8/ubi:latest

​	podman images #查看本地镜像

运行容器

​	podman run -it registry.access.redhat.com/ubi8/ubi:latest

​	-it与容器交互并分配终端 -d后台运行 -rm运行完后删除容器

#### 查找和管理容器镜像

podman配置容器registries

​	cat /etc/containers/registries.conf

​	常规用户 $HOME/.config/containers/registries.conf

查看配置信息

​	podman info

搜索容器镜像

​	podman search registry.redhat.io/rhel8

查看本地容器镜像

​	podman images

​	podman inspect registry.redhat.io/rhel8/python-36

删除本地容器镜像

​	podman rmi registry.redhat.io/rhel8/python-36

#### 实施高级容器管理

将主机端口映射到容器

​	podman  run  -p  hostport:containerport  registry.redhat.io/rhel8/httpd-24

列出所有正在使用的端口映射

​	podman port -a

在主机防火墙规则中添加端口

​	firewall-cmd --add-port=8000/tcp

将环境变量传递到容器中

​	podman run -e MYSQL_USER=user_name

列出运行中的容器

​	podman ps                     -a 列出所有

停止容器运行

​	podman stop 容器名

在主机上删除容器

​	podman rm 容器名

在容器中运行命令

​	podman exec 3rh2345kjh234 cat /etc/passwd

​	podman exec -it my_webserver /bin/bash

#### 容器附加持久存储

​	podman run [--volume|-v] host_dir:container_dir

#### 以服务的方式管理容器