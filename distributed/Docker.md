[TOC]

# Docker

## Docker概述

Docker 是一个**开源的应用容器引擎**，让开发者可以打包他们的应用以及依赖包到一个可移植的镜像中，然后发布到任何流行的 Linux或Windows操作系统的机器上，也可以实现虚拟化。容器是完全使用沙箱机制，相互之间不会有任何接口。

基于go语言开发并遵从Apache2.0协议开源。

**三大核心**：镜像images、容器container、仓库repository

优点：

- 灵活：即使是最复杂的应用也可以集装箱化。
- 轻量级：容器利用并共享主机内核。
- 可互换：您可以即时部署更新和升级。
- 便携式：您可以在本地构建，部署到云，并在任何地方运行。
- 可扩展：您可以增加并自动分发容器副本。
- 可堆叠：您可以垂直和即时堆叠服务。

## Docker的应用场景

- Web 应用的自动化打包和发布。
- 自动化测试和持续集成、发布。
- 在服务型环境中部署和调整数据库或其他的后台应用。
- 从头编译或者扩展现有的 OpenShift 或 Cloud Foundry 平台来搭建自己的 PaaS 环境。

## Docker原理

Docker是一个Client-Server结构的系统，Docker守护进程运行在主机上， 然后通过Socket连接从客户端访问Docker守护进程。

Docker守护进程从客户端接受命令，并按照命令，管理运行在主机上的容器。

一个docker 容器，是一个运行时环境，可以简单理解为进程运行的集装箱。

## Docker运行过程

当利用 `docker run` 来创建容器时，Docker在后台的标准执行过程是：

1. 检查本地是否存在指定的镜像。当镜像不存在时，会从公有仓库下载；
2. 利用镜像创建并启动一个容器；
3. 分配一个文件系统给容器，在只读的镜像层外面挂载一层可读写层。
4. 从宿主主机配置的网桥接口中桥接一个虚拟机接口到容器中；
5. 分配一个地址池中的IP地址给容器；
6. 执行用户指定的应用程序，执行完毕后容器被终止运行。

## Docker为什么比VM虚拟机快

1. docker有着比虚拟机更少的抽象层
2. docker利用宿主机的内核，而不需要加载操作系统内核

二者的不同：

VM(VMware)在宿主机器、宿主机器操作系统的基础上创建虚拟层、虚拟化的操作系统、虚拟化的仓库，然后再安装应用；
Container(Docker容器)，在宿主机器、宿主机器操作系统上创建Docker引擎，在引擎的基础上再安装应用。
所以说，新建一个容器的时候，docker不需要像虚拟机一样重新加载一个操作系统，避免引导。docker是利用宿主机的操作系统，省略了这个复杂的过程，秒级启动！虚拟机是加载Guest OS ，这是分钟级别的。

## Docker安装

Linux上安装Docker

https://docs.docker.com/engine/install/

```shell
# 1. 卸载老的版本
yum remove docker \
           docker-client \
           docker-client-latest \
           docker-common \
           docker-latest \
           docker-latest-logrotate \
           docker-logrotate \
           docker-engine
# 2. 安装需要的安装包
yum install -y yum-utils

# 3. 设置镜像的仓库 (阿里云镜像仓库)
yum-config-manager --add-repo \
	http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

# 更新yum软件包索引
yum makecache fast

# 4. 安装docker
yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin
# 指定版本安装
yum install docker-ce-<VERSION_STRING> docker-ce-cli-<VERSION_STRING> containerd.io docker-compose-plugin

# 安装包安装
yum install /path/to/package.rpm
```

Docker卸载

```shell
# 1.卸载依赖
yum remove docker-ce docker-ce-cli containerd.io docker-compose-plugin
# 2.删除资源
rm -rf /var/lib/docker
rm -rf /var/lib/containerd
```

## Docker命令

```shell
#启动docker
systemctl start docker
#验证
docker run hello-world
#版本
docker version
docker info
#停止docker
systemctl stop docker
#重启docker
systemctl restart docker
#查看docker状态
systemctl status docker
#查看仓库配置
cat /etc/docker/daemon.json
```

```shell
###镜像命令
#查看镜像
docker images
#搜索镜像
docker search 镜像名
#拉取镜像
docker pull 镜像名:tag
#为本地镜像打标签
docker tag 镜像名：tag
#将镜像保持到本地
docker save -o 存储文件名 存储的镜像
#删除镜像
docker rmi -f 镜像id   				#删除指定镜像
docker rmi -f $(docker images -aq)   #删除所有镜像
docker rmi 仓库名称：tag
```

```shell
###容器命令
#查看运行的容器
docker ps
#查看当前和历史运行的容器
docker ps -a
#查看容器信息
docker inspect 容器id
#新建容器并启动
docker run [param] image
--name		 	容器名称
-it				交互运行
-d				后台运行
-p				端口映射 -p 主机端口：容器端口
-v				卷挂载   -v 主机目录：容器目录
-e				配置环境

#启动和停止容器
docker start 容器id
docker stop 容器id
docker restart 容器id
docker  kill 容器id
#进入当前正在进行的容器
docker exec -it 容器id /bin/bash   开启新的终端
docker attach 容器id				 进入正在运行的终端
#退出容器
exit		#停止并退出
Ctrl+P+Q	#不停止并退出
#删除容器
docker rm 容器id
docker rm -f $(docker ps -aq)   #删除所有容器


#实例
docker pull centos
docker run -it centos /bin/bash
#查看容器内日志
docker logs -tf --tail 10 容器id
#查看容器内进程信息
docker top 容器id
#从容器内拷贝文件到主机上
docker cp 容器id:容器内路径 主机路径
```

## Docker技术底座

1. namespace  命名空间
2. cgroups    控制组
3. unionFS    联合文件系统

### namespace  命名空间

### cgroups         控制组

### unionFS         联合文件系统

## 容器数据卷

Docker将运用与运行的环境打包形成容器运行， Docker容器产生的数据，如果不通过docker commit生成新的镜像，使得数据做为镜像的一部分保存下来， 那么当容器删除后，数据自然也就没有了。 为了能保存数据在Docker中我们使用卷。|

**卷的设计目的就是数据的持久化，完全独立于容器的生存周期，因此Docker不会在容器删除时删除其挂载的数据卷。Docker容器卷的工作就是将docker容器数据通过映射进行备份+持久化到本地的主机目录**

- 使用方法

```shell
docker run -it -v 主机目录:容器目录

同步mysql数据和文件
docker run -d -p 6603:3306 -v /home/mysql/conf:/etc/mysql/conf.d -v /home/mysql/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 --name mysql01 mysql:5.7

```

```shell
# 卷常用命令
docker volume create [VOLUME_NAME] 		#创建卷
docker volume ls						#查看所有的卷
docker volume inspect [VOLUME_NAME]		#查看指定的卷
docker volume rm [VOLUME_NAME]			#删除卷
docker volume prune						#删除无用卷
```

- **匿名挂载**：就是在指定数据卷的时候，不指定容器路径对应的主机路径，这样对应映射的主机路径就是默认的路径`/var/lib/docker/volumes/`中自动生成一个**随机命名**的文件夹

- **具名挂载**：就是指定文件夹名称，区别于指定路径挂载，这里的指定文件夹名称是在Docker指定的默认数据卷路径下的。通过`docker volume ls`命令可以查看当前数据卷的目录情况。

```shell
-v 容器内路径		  #匿名挂载
-v 卷名:容器内路径		 #具名挂载
-v /主机路径:容器内路径  #指定路径挂载

#通过-v 容器内路径: ro	rw   改变读写权限
ro		readonly       #只读
rw		readwrite      #可读可写
# ro  只要看到ro就说明这个路径只能通过宿主机来操作，容器内部是无法操作!
```

- 容器间数据同步

使用`--volumes-from`，实现双向拷贝。

```shell
#创建docker01
docker run -it --name docker01 axing/centos
#不关闭该容器退出
CTRL + Q + P 
#创建docker02
docker run -it --name docker02 --volumes-from docker01 axing/centos
```

容器之间的配置信息的传递，数据卷容器的生命周期一直持续到没有容器使用为止。

但是一旦你持久化到了本地，这个时候，本地的数据是不会删除的。

## DockerFile

Dockerfile 是一个用来构建镜像的文本文件，文本内容包含了一条条构建镜像所需的指令和说明。

**构建步骤︰**
1、编写一个dockerfile 文件
2、docker build构建成为一个镜像
3、docker run运行镜像
4、docker push 发布镜像(DockerHub、阿里云镜像仓库!)

**基础知识∶**
1、每个保留关键字（指令）都是尽量是大写字母
2、执行从上到下顺序执行
3、#表示注释
4、每一个指令都会创建提交一个新的镜像层，并提交!

```shell
指令	       说明
FROM		#指定基础镜像
MAINTAINER	#镜像是谁写的，姓名+邮箱
RUN			#运行指定的命令
CMD			#容器启动时要运行的命令,只有最后一个会生效，可被替代
EMTRYPOINT	#容器启动时要运行的命令，可以追加命令
ADD			#将本地文件添加到容器中
COPY		#复制命令，功能类似ADD，只能是本地文件
WORKDIR		#镜像的工作目录
VOLUME		#挂载的目录
EXPOSE		#暴露端口配置
ONBUILD		#当构建一个被继承DockerFile，这个时候就会运行ONBUILD的指令，触发指令
ENV			#设置环境变量
```

**编写DockerFile文件**

第一步：编写dockerfile文件

/home/axing/Dockerfile

```shell
FROM centos:8.0                           #基础镜像         
MAINTAINER AXING<123456@qq.com>        	 #维护者信息
 
ENV MYPATH /usr/local                    #环境变量目录 k-v
WORKDIR $MYPATH                          #工作目录  用$取k
 
RUN yum -y install vim                   #执行构建命令  安装vim
RUN yum -y install net-tools             #执行构建命令  安装net-tools
 
EXPOSE 80                                #暴露端口 80
 
CMD echo $MYPATH                         #输出构建信息 mypath
CMD echo "---end---"                     #输出信息
CMD /bin/bash                            #进入/bin/bash命令行
```

第二部：构建镜像文件

```shell
cd /home/axing
docer build -f Dockerfile -t mycentos:1.0 .
```

第三步：启动镜像

```shell
docker run -it mycentos:1.0
```

查看一个镜像的构建历史

```shell
docker history 镜像id
```



## Docker网络