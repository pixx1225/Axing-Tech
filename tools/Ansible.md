# Ansible

### 定义

&emsp;&emsp;ansible是一种自动化运维工具，基于Python开发，集合了众多运维工具（puppet、chef、func、fabric）的优点，实现了批量系统配置、批量程序部署、批量运行命令等功能。Ansible默认通过 SSH 协议管理机器.

&emsp;&emsp;ansible是基于 paramiko 开发的,并且基于模块化工作，本身没有批量部署的能力。真正具有批量部署的是ansible所运行的模块，ansible只是提供一种框架。ansible不需要在远程主机上安装client/agents，因为它们是基于**ssh**来和远程主机通讯的。

### 特点

1. 部署简单，只需在主控端部署Ansible环境，被控端无需做任何操作；
2. 默认使用SSH协议对设备进行管理；
3. 有大量常规运维操作模块，可实现日常绝大部分操作；
4. 配置简单、功能强大、扩展性强；
5. 支持API及自定义模块，可通过Python轻松扩展；
6. 通过Playbooks来定制强大的配置、状态管理；
7. 轻量级，无需在客户端安装agent，更新时，只需在操作机上进行一次更新即可；
8. 提供一个功能强大、操作性强的Web管理界面和REST API接口——AWX平台。

### 主要模块：

`Ansible`：Ansible核心程序。
`HostInventory`：记录由Ansible管理的主机信息，包括端口、密码、ip等。
`Playbooks`：“剧本”YAML格式文件，多个任务定义在一个文件中，定义主机需要调用哪些模块来完成的功能。
`CoreModules`：**核心模块**，主要操作是通过调用核心模块来完成管理任务。
`CustomModules`：自定义模块，完成核心模块无法完成的功能，支持多种语言。
`ConnectionPlugins`：连接插件，Ansible和Host通信使用

### 任务执行模式

Ansible 系统由控制主机对被管节点的操作方式可分为两类，即`adhoc`和`playbook`：

- ad-hoc模式(点对点模式)使用单个模块，支持批量执行单条命令。就相当于bash中的一句话shell。
- playbook模式(剧本模式)是Ansible主要管理方式，也是Ansible功能强大的关键所在。**playbook通过多个task集合完成一类功能**，可以简单地把playbook理解为通过组合多条ad-hoc操作的配置文件。

### 命令执行过程

1. 加载自己的配置文件，默认`/etc/ansible/ansible.cfg`；
2. 查找对应的主机配置文件，找到要执行的主机或者组；
3. 加载自己对应的模块文件，如 command；
4. 通过ansible将模块或命令生成对应的临时py文件(python脚本)， 并将该文件传输至远程服务器；
5. 对应执行用户的家目录的`.ansible/tmp/XXX/XXX.PY`文件；
6. 给文件 +x 执行权限；
7. 执行并返回结果；
8. 删除临时py文件，`sleep 0`退出；

### Ansible命令

```ansible
ansible-doc -l				#获取全部模块的信息 
ansible web -m ping 		#进行主机连通性测试
ansible web -m shell -a 'cat /etc/passwd |grep "keer"'
```





