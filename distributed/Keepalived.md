[TOC]

# Keepalived

### Keepalived简介

**keepalived**是linux下一个轻量级的高可用解决方案，Keepalived 是使用C语言编写的`路由热备软件`，该项目软件起初是专门为`LVS`负载均衡设计的，用来管理并监控LVS集群系统中各个服务节点的状态，后来又加入了可以实现高可用的`VRRP`功能。 因此，Keepalived除了能够管理LVS软件外，还可以作为其他服务（例如：`Nginx`，`Haproxy`，`MySQL`等）的高可用解决方案软件。

Keepalived 主要是通过`VRRP`协议实现高可用功能的。VRRP是Virtual Router Redundancy Protocol（`虚拟路由器冗余协议`）的缩写，VRRP出现的目的就是为了解决静态路由单点故障问题的，它能够保证当个别节点宕机时，整个网络可以不间断地运行。

所以，Keepalived一方面具有配置管理LVS的功能，同时还具有对LVS下面节点进行健康检查的功能，另一方面也可实现系统网络服务的高可用功能。

keepalived 有三个重要的功能，分别是：

- 管理LVS负载均衡软件
- 实现LVS集群节点的健康检查
- 作为系统网络服务的高可用性

### 高可用

高可用HA（High Availability）是分布式系统架构设计中必要的一环，主要是为了减少系统不能提供服务时间。假设系统能一直提供服务，可用性为100%，如果系统每运行100个时间单位，会有1个时间单位无法提供服务，则系统可用性为99%。两台服务器启动相同的业务系统，当有一台机器宕机，另外一台服务器快速接管服务，对于用户来讲是无感知的。

### VRRP

（1）VRRP也就是虚拟路由冗余协议，它的出现就是为了解决静态路由的单点故障。

（2）VRRP是通过一种竞选协议机制将路由任务交给某台VRRP路由器。

（3）VRRP用 IP多播的方式（默认多播地址（224.0_0.18))实现高可用对之间通信。

（4）工作时主节点发包，备节点接包，当备节点接收不到主节点发的数据包时，就启动接管程序接管主节点的资源。备节点可以有多个，通过优先级竞选，但一般Keepalived系统工作中都是一对。

（5）VRRP使用了加密协议加密数据，但Keepalived官方目前还是推荐用明文的方式配置认证类型和密码。

### Keepalived工作原理

（1）Keepalived高可用之间是通过VRRP进行通信的，VRRP是通过竞选机制来确定主备的，主的优先级高于备，因此，工作时主会优先获得所有的资源，备节点处于等待状态，当主挂了的时候，备节点就会接管主节点的资源，然后顶替主节点对外提供服务。

（2）在Keepalived服务之间，只有作为主的服务器会一直发送VRRP广播包，告诉备它还活着，此时备不会抢占主，当主不可用时，即备监听不到主发送的广播包时，就会启动相关服务接管资源，保证业务的连续性。接管速度最快可以小于`1`秒。



**keepalived 启动后会有三个进程**

父进程： 内存管理，子进程管理等等

子进程1： VRRP 子进程； 功能:发送信息

子进程2： healthchecker 子进程； 功能：负责检查本机的健康状况的

注：healthchecker子进程负责检查各主机间的主机状态，当发现某台主机上的服务不可用时，将通 知vrrp子进程，由vrrp子进程来完成服务的切换

### Keepalived安装

```shell
yum install keepalived -y
```

### Keepalived启停

```shell
#建议配置应用用户的sudo权限
echo 'user1 ALL=(root) NOPASSWD: {command},ALL' > /etc/sudoers
#启动
sudo /sbin/keepalived -f /home/app/keepalived/etc/keepalived/keepalived.conf
#停止
sudo /home/app/keepalived/etc/scripts/killkeepalived.sh
/bin/pkill keepalived
ps -ef | grep keepalived | grep -v grep | awk '{print $2}' | xargs kill -9
```



### Keepalived配置文件

```
实验环境准备：
master:192.168.30.149
backup:192.168.30.157
vip:192.168.30.250(虚拟出来的)用户访问的地址
```

```xml
【主机master】
! Configuration File for keepalived
#全局配置
global_defs {
   notification_email {#设置报警邮件地址
      #收件人地址
   }
   router_id nginx001 #主机标识，默认情况下是主机名，可以配置成主机名
}
#VRRP脚本配置
vrrp_script chk_nginx_service {
  script "/etc/keepalived/chk_nginx.sh" #周期性执行的脚本
  interval 2		#运行脚本的间隔时间，秒
  weight 2			#权重，priority值减去此值要小于备服务的priority值
  timeout 5			#超时时间，超秒后脚本被认为执行失败
  fall 3			#检测几次状态为失败才为失败，整数
  rise 2			#检测几次状态为正常才为正常，整数
}
#VRRP配置
vrrp_instance VI_1 {
    state MASTER                #角色类型MASTER|BACKUP
	nopreempt            		#非抢占模式 
    interface ens33             #网卡名称
    virtual_router_id 55        #虚拟路由id（需要与BACKUP一致）
    priority 100                #优先级，数字大的优先级高
    advert_int 1                #1秒检查一次
    authentication { 
        auth_type PASS          #认证类型 主备之间必须一样
        auth_pass 3333          #认证密码 主备之间必须一样
    }
    virtual_ipaddress {
        192.168.30.250          #虚拟ip(vip)
    }
    track_script {				#脚本监控状态
        chk_nginx_service
    }
	notify_master "/etc/keepalived/start_haproxy.sh start"  #当前节点成为master时，通知脚本执行任务
    notify_backup "/etc/keepalived/start_haproxy.sh stop"   #当前节点成为backup时，通知脚本执行任务
    notify_fault  "/etc/keepalived/start_haproxy.sh stop"   #当前节点出现故障，执行的任务;
}
【备机backup】
其他都一样，不一样的如下
#VRRP配置
vrrp_instance VI_1 {
    state BACKUP                #角色类型MASTER|BACKUP
```

