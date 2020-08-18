[TOC]

# TechSkill

> 工欲善其事，必先利其器

## 软件工具总汇

1. 推荐安装浏览器 Google Chrome
   谷歌浏览器插件：Postman-REST Client，Grammarly，Adblock Plus
2. Win中推荐安装文本编辑器 Notepad++ 或 Sublime
   Mac中推荐安装文本编辑器 Sublime
3. Win中推荐画图工具 Visio
4. 推荐安装Markdown编辑器 Typora
5. Win中解压软件 7-Zip
   Mac中解压软件 The Unarchiver
6. Mac中视频播放软件 IINA
7. 推荐桌面共享软件 TeamViewer
8. Win推荐安装卸载工具 IObitUninstaler

Java开发：**JetBrains IntelliJ IDEA，Eclipse**

Python开发：**JetBrains PyCharm，Anacoda**

数据库：**Navicat**

终端工具：

1. **XShell**（Xmanager)
2. **MobaXterm**
3. **Putty**

工具链：

- 代码管理（SCM）：**GitHub**、**GitLab**、BitBucket、SubVersion
- 构建工具：**Ant**、Gradle、**maven**
- 自动部署：Capistrano、CodeDeploy
- 持续集成（CI）：Bamboo、Hudson、**Jenkins**
- 配置管理：**Ansible**、Chef、Puppet、SaltStack、ScriptRock GuardRail
- 容器：**Docker**、LXC、第三方厂商如AWS
- 编排：**Kubernetes**、Core、Apache Mesos、DC/OS
- 服务注册与发现：**Zookeeper**、etcd、Consul
- 脚本语言：**shell**、python、ruby、
- 日志管理：ELK、Logentries
- 系统监控：Datadog、Graphite、Icinga、Nagios
- 性能监控：AppDynamics、New Relic、Splunk
- 压力测试：JMeter、Blaze Meter、loader.io
- 预警：PagerDuty、pingdom、厂商自带如AWS SNS
- HTTP加速器：Varnish
- 消息总线：**ActiveMQ**、SQS
- 应用服务器：**Tomcat**、JBoss
- Web服务器：**Apache**、**Nginx**、IIS
- 数据库：MySQL、Oracle、PostgreSQL等关系型数据库；cassandra、mongoDB、**redis**等NoSQL数据库
- 项目管理（PM）：**Jira**、Asana、Taiga、Trello、Basecamp、Pivotal Tracker

### Java 开发

**JDK环境变量配置：**
我的电脑—属性—高级系统配置—环境变量—：

```
系统变量—新建：
JAVA_HOME:
C:\DevApps\Java\jdk1.8.0_251 (即JDK安装目录)
CLASSPATH:
.;%JAVA_HOME%\lib;%JAVA_HOME%\lib\dt.jar;%JAVA_HOME%\lib\tools.jar
Path：
%JAVA_HOME%\bin 和 %JAVA_HOME%\jre\bin

最后测试：cmd中运行 java -version 看版本号有没有，如有则安装成功。
```

**Eclipse**

**JetBrains IntelliJ IDEA**

类、方法上的注释

settings--Editor--Live Templates

```
**
* @Description //TODO
* @Param $param$
* @Return $return$
* @Author pixingxing  $date$
*/
```

### Python开发

1. JetBrains PyCharm
2. Anacoda

### 其他开发

- [Windows批处理](tools/Win批处理.md)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Postman](https://www.getpostman.com/)

### 软件破|解
1. [Navicat](https://www.navicat.com.cn/) Premium 15  [Mac版](https://www.52pojie.cn/thread-1101529-1-1.html)  [Windows版](https://www.cnblogs.com/hfxtest/p/12513210.html)
4. [Charles](https://www.charlesproxy.com)   [Windows版](https://www.zzzmode.com/mytools/charles/)
   Charles是一款Http代理服务器和Http监视器，当移动端在无线网连接中按要求设置好代理服务器，使所有对网络的请求都经过Charles客户端来转发时，Charles可以监控这个客户端各个程序所有连接互联网的Http通信。



## 技术技巧总汇

> 以下纯属个人见解，不代表正确与否，但也值得部分参考
>
> 做事很重要，但有时做人更重要。

### 强迫症变习惯

首先，作为一个计算机人，需要一个严谨、清晰的办事态度是非常重要的。具体体现在很多方面，从小的说起

​		文件目录管理：我们的电脑上存放很多不同的文件以及安装目录，如何管理好它们是有一定意义的。比如

- D:\DevApps\	目录下存放各个软件的安装路径
- D:\DevFiles\     目录下存放我们开发时用到的文件
- D:\MyFiles\      目录下存放我们自己的文件
- D:\Project\       目录下存放项目文件，把Eclipse和IDEA项目放这里

再比如浏览器的书签管理，微信好友标签管理等等。

有人会说这是强迫症，但这也是一种良好的习惯不是吗。



### 细心且耐心

当你写前端代码时，你会发现，需要慢慢调样式格式之类的问题，不但需要细心，还需要很大的耐心。

### 总结问题

遇到问题不可怕，可怕的是遇到相同的问题还是无法解决，这就是高中老师口中的太不应该了。

每当我们花了很多时间很多精力解决了问题时，记得再花点时间总结和回想一下，那会使你受益无穷。一个简单的场景：

*你要知道，你遇到的问题，别人也可能遇到*。你千辛万苦解决了这个问题，一个漂亮美女也遇到了这个问题现场问你怎么解决的，你说你知道这个问题，结果你忘记了怎么解决的。这样可能使你`大意失荆州`啊！错失了走向人生巅峰的机会。:joy:

**学会总结问题，思考问题。**很多问题就像是软件开发中的代码重用，我们只需要抽象出来重构一系列问题，下次遇到相同的问题，只需要调用我们笔记上或者脑海里的问题答案就好了。



## 开发问题总汇

### IDEA中maven添加dependency过慢的问题
我们在IDEA的安装目录下找到 /plugins/maven/lib/maven2/conf 或者maven3/conf目录，向其中的setting.xml文件中的<mirrors>标签下添加如下的仓库地址--这里以阿里云为例

```xml
<mirror>  
    <id>nexus-aliyun</id>  
    <mirrorOf>central</mirrorOf>    
    <name>Nexus aliyun</name>  
    <url>http://maven.aliyun.com/nexus/content/groups/public</url>
</mirror>
```

然后重新启动IDEA，之后就可以体会到飞一般地速度了（相比于之前）！

### Github 图片不显示的问题

打开路径C:\Windows\System32\drivers\etc下的hosts文件

(权限问题，先复制文件到其他路径，修改后再覆盖回来)

再去这个网站：https://www.ipaddress.com/
根据一下域名解析出 IP 地址，最后把`IP 域名`添加到 `hosts`文件中

```xml
# Github Start
199.232.68.133 avatars0.githubusercontent.com
199.232.68.133 avatars1.githubusercontent.com
199.232.68.133 avatars2.githubusercontent.com
199.232.68.133 avatars3.githubusercontent.com
199.232.68.133 raw.githubusercontent.com
199.232.68.133 raw.github.com
# Github End
```

### CMD中文乱码

有可能是因为 cmd 终端编码是gbk，而服务器编码格式为utf8，所以需要修改cmd终端编码格式为utf8

> 运行cmd >> 输入chcp，回车查看当前的编码>>输入chcp 65001，回车

直接修改注册表，win+R，输入regedit，进入注册表

> [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Command Processor]
>
> 新建一个字符串值，key-value如下：
> "autorun"="chcp 65001"，之后重新打开cmd即可。

