[TOC]

# Tomcat

### Tomcat简介

​	Tomcat是由Apache推出的一个开源、免费、轻量级的Web服务器，Tomcat是Apache 软件基金会的Jakarta 项目中的一个核心项目，由Apache、Sun 和其他一些公司及个人共同开发而成。由于有了Sun 的参与和支持，最新的Servlet 和JSP 规范总是能在Tomcat 中得到体现，Tomcat 5支持最新的Servlet 2.4 和JSP 2.0 规范。因为Tomcat 技术先进、性能稳定，而且免费，因而深受Java 爱好者的喜爱并得到了部分软件开发商的认可，成为比较流行的Web 应用服务器。

​	Tomcat运行时占用的系统资源小，扩展性好，支持负载平衡与邮件服务等开发应用系统常用的功能，因而深受java爱好者的喜爱，并得到了部分软件开发商的认可，和Apache一样，早已成为主流Web服务器的一种。

Tomcat官网：https://tomcat.apache.org/

### Web服务器

Web服务器是安装在服务端的一款软件，它对HTTP协议的操作进行了封装使得程序员不必直接对协议进行相关操作，让Web开发变得更加便捷。Web服务器的主要功能就是提供网上信息浏览服务，当我们将自己写的Web项目部署道Web服务器上，只要启动Web服务器，就能直接通过浏览器访问我们的Web项目了。目前比较有名的Web服务器有：Apache、Nginx、ISS。

### 目录结构

```
/bin：    存放windows或Linux平台上启动和关闭Tomcat的脚本文件
/conf：   存放Tomcat服务器的各种全局配置文件，其中最重要的是server.xml和web.xml
/lib：	 存放Tomcat服务器所需的各种JAR文件
/logs：   存放Tomcat执行时的日志文件
/webapps：Tomcat的主要Web发布目录，默认情况下把Web应用文件放于此目录
/WEB-INF：java web应用的安全目录
	/WEB-INF/classes:存放程序所需要的所有 Java class 文件
	/WEB-INF/lib：存放程序服务器所需的各种JAR文件
	/WEB-INF/web.xml：web应用的部署配置文件
work：存放JSP编译后产生的class文件
```



### Tomcat配置

- 修改默认端口号

打开 tomcat/conf/server.xml

```bash
<Connector port="8080" protocal="HTTP/1.1"
		   connectionTimeout="20000"
		   redirectPort="8443" URIEncoding="UTF-8" />
```

端口号的范围是：`0~65535`

HTTP协议默认端口号是`80`，HTTPS协议默认端口号是`443`

- 线程池配置

打开 tomcat/conf/server.xml

```bash
<Connector port="8080" acceptCount="100" 
		   maxConnections="200" 			 
		   minSpareThreads="10"
           maxThreads="200"/>
```

acceptCount:请求等到队列大小

maxConnections:Tomcat能处理的最大并发连接数

minSpareThreads:线程池最小线程数，默认为10

maxThreads:线程池最大线程数，默认为200

- GET方式URL乱码问题解决

打开 tomcat/conf/server.xml

查找下面这部分，在最后增加一段代码就可以了。

```bash
URIEncoding="UTF-8" useBodyEncodingForURI="true"
```

- 启动内存参数的配置

打开tomcat/bin/catalina.bat，如果是linux 就是 catalina.sh

在rem 的后面增加如下参数

```bash
set JAVA_OPTS="-server -Xms4096M -Xmx4096M -XX:NewSize=600M -XX:MaxNewSize=1024M -XX:PermSize=512M -XX:MaxPermSize=1024M -Xss2048k"
```

- 修改Tomcat的JDK目录

打开tomcat/bin/catalina.bat，如果是linux 就是 catalina.sh

在最后一个rem后面增加

```bash
set JAVA_HOME=C:\Program Files\Java\jdk1.8.0
```

