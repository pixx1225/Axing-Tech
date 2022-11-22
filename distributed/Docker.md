[TOC]

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
-it				交互运行运行
-d				后台方式运行
-p				指定容器端口 -p 主机端口：容器端口（常用的映射）
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
2. cgroups         控制组
3. unionFS         联合文件系统