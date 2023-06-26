[TOC]

# Nginx

### Nginx介绍

Nginx是一款轻量级的Web服务器、**反向代理**服务器，而且支持**热部署**，由于它的**内存占用少**，启动极快，**高并发**能力强，能支持高达5w个并发连接数，在互联网项目中广泛应用。开源免费、高性能、高可靠、配置简单。

### 正向代理

就是客户端将自己的请求率先发给代理服务器，通过代理服务器将请求转发给服务器。我们常用的VPN就是一种代理服务器。

![img](https://pic2.zhimg.com/v2-d1da364c1b6c2f0024867c3f8ce49c59_r.jpg)

### 反向代理

反向代理与正向代理不同，正向代理是代理了客户端，而反向代理则是代理服务器端。

![img](https://pic1.zhimg.com/v2-55476d2362c5706329c5693326b303bc_r.jpg)

### Nginx工作原理

1.在nginx启动后，会有一个master进程和多个worker进程，master进程主要用来管理worker进程，包括：接受信号，将信号分发给worker进程，监听worker进程工作状态，当worker进程退出时(非正常)，启动新的worker进程。基本的网络事件会交给worker进程处理。多个worker进程之间是对等的，他们同等竞争来自客户端的请求，各进程互相之间是独立的 。一个请求，只可能在一个worker进程中处理，一个worker进程，不可能处理其它进程的请求。 worker进程的个数是可以设置的，一般我们会设置与机器cpu核数一致，这里面的原因与nginx的进程模型以及事件处理模型是分不开的 。

2.当master接收到重新加载的信号会怎么处理(./nginx -s reload)?，master会重新加载配置文件，然后启动新的进程，使用的新的worker进程来接受请求，并告诉老的worker进程他们可以退休了，老的worker进程将不会接受新的，老的worker进程处理完手中正在处理的请求就会退出。

3.worker进程是如何处理用户的请求呢？首先master会根据配置文件生成一个监听相应端口的socket，然后再faster出多个worker进程，这样每个worker就可以接受从socket过来的消息（其实这个时候应该是每一个worker都有一个socket，只是这些socket监听的地址是一样的）。当一个连接过来的时候，每一个worker都能接收到通知，但是只有一个worker能和这个连接建立关系，其他的worker都会连接失败，这就是所谓的惊群现在，为了解决这个问题，nginx提供一个共享锁accept_mutex，有了这个共享锁后，就会只有一个worker去接收这个连接。当一个worker进程在accept这个连接之后，就开始读取请求，解析请求，处理请求，产生数据后，再返回给客户端，最后才断开连接，这样一个完整的请求就是这样的了。

### Nginx安装

```shell
yum install nginx -y
```

### Nginx常用命令

```shell
cd /usr/local/nginx/sbin  # 到nginx安装目录下
./nginx            # 启动nginx, -c 指定配置文件
./nginx -s stop    # 关闭nginx，立即停止
./nginx -s quit    # 等待工作进程处理完成后安全退出
./nginx -s reload  # 重新加载配置文件，热重启
./nginx -s quit    # 等待工作进程处理完成后关闭
./nginx -v		   # 查看版本
./nginx -t         # 检查配置是否有问题
```

**systemctl 系统命令**

```shell
systemctl enable nginx  # 开机自动启动
systemctl disable nginx # 关闭开机自动启动
systemctl start nginx   # 启动Nginx
systemctl stop nginx    # 停止Nginx
systemctl restart nginx # 重启Nginx
systemctl reload nginx  # 重新加载Nginx
systemctl status nginx  # 查看 Nginx 运行状态
```

### Nginx配置文件

```nginx
# main段配置信息，全局设置
user nobody;   #指定运行用户，注释掉或者配置成nobody的话所有用户都可以运行
worker_processes auto;  #工作进程数，可指定数量
error_log logs/error.log warn;   #错误日志存放目录
pid       logs/nginx.pid;      #服务启动时的pid存放位置

# events段配置信息
events {
    worker_connections 10240;   # 每个工作进程允许最大连接数
}

# http段配置信息
http { 
    include             mime.types; # 文件扩展名与类型映射表
    default_type        application/octet-stream; # 默认文件类型
    
    # 设置日志格式
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" ' '$status $body_bytes_sent "$http_referer" ' '"$http_user_agent" "$http_x_forwarded_for"';
    access_log  logs/access.log  main; #Nginx访问日志存放位置
    
    send_timeout          60;    #响应客户端的超时时间
    client_body_timeout   60;    #客户端请求主体读取超时时间
    client_header_timeout 60;    #客户端请求头读取超时时间
    keepalive_timeout     60;    #客户端连接保持活动的超时时间，单位秒
    keepalive_requests    10000; # 限制用户通过某一连接向Nginx服务器发送请求的次数。默认是100
    sendfile  on  # 开启高效文件传输模式
    
    # upstream段配置信息，主要用于负载均衡，设置一系列的后端服务器
    upstream  test.com {   
        server    192.168.99.100:10080; 
        server    192.168.99.101:10080;  
	} 
    
    # server段配置信息，用于指定主机和端口
	server {  
        listen       80;         # 配置监听的端口
        server_name  localhost;  # 配置的域名

        # location段配置信息，用于匹配网页位置
		location / {  
            proxy_pass http://test.com;  
            proxy_redirect default;  
    	}  

        # 错误页面
        error_page   404  /404.html;  
        location = /404.html {  
            root   html;  
        }
        error_page   500 502 503 504  /50x.html;  
        location = /50x.html {  
            root   html;  
        }  
}


```


### 负载均衡策略
 **1、轮询** 

```nginx
#这种是默认的策略，把每个请求按顺序逐一分配到不同的server，如果server挂掉，能自动剔除

upstream  test.com {   
    server   192.168.99.100:42000; 
    server   192.168.99.100:42001;  
}
```
 **2、最少连接** 

```nginx
#把请求分配到连接数最少的server

upstream  test.com {   
    least_conn;
    server   192.168.99.100:42000; 
    server   192.168.99.100:42001;  
}
```
 **3、权重** 

```nginx
#使用weight来指定server访问比率，weight默认是1。

upstream  test.com {   
    server   192.168.99.100:42000 weight=1; 
    server   192.168.99.100:42001 weight=2;  
}
```

 **4、ip_hash** 

```nginx
#每个请求会按照访问ip的hash值分配，这样同一客户端连续的Web请求都会被分发到同一server进行处理，可以解决session的问题。

upstream  test.com {   
    ip_hash;
    server   192.168.99.100:42000; 
    server   192.168.99.100:42001;  
}
```
**5、fair** （第三方）

```nginx
#按照服务器端的响应时间来分配请求，响应时间短的优先分配。

upstream test.com {
    fair;
    server   192.168.99.100:42000; 
    server   192.168.99.100:42001;  
}
```

**6、url_hash**（第三方）

```nginx
#按访问url的hash结果来分配请求，使每个url定向到同一个后端服务器，需要配合缓存用。

upstream test.com {
    hash $request_uri;
    server   192.168.99.100:42000; 
    server   192.168.99.100:42001;  
}
```

### Nginx和Apache的区别

1. apache是同步多进程模型，一个连接对应一个进程；Nginx是异步的，多个连接(万级别)可以对应一个进程；
2. Nginx 配置简洁, Apache 复杂；Nginx 静态处理性能比 Apache 高 2倍以上 ;
3. Apache 对 PHP 支持比较简单；Nginx 需要配合其他后端用；Apache 的组件比 Nginx 多 ;
4. Nginx处理静态文件好，耗费内存少、并发性好；动态请求由apache去做，Nginx只适合静态和反向；
5. Nginx适合做前端服务器，负载性能很好；Nginx本身就是一个反向代理服务器 ，且支持负载均衡。

### HTTP常见错误码

```http
1xx：信息，请求收到，继续处理
2xx：成功，行为被成功地接受、理解和采纳
3xx：重定向，为了完成请求，必须进一步执行的动作
4xx：客户端错误，请求包含语法错误或者请求无法实现
5xx：服务器错误，服务器不能实现一种明显无效的请求
```

```http

2xx  成功  
200  正常；请求已完成。  
201  正常；紧接 POST 命令。  
202  正常；已接受用于处理，但处理尚未完成。  
203  正常；部分信息 — 返回的信息只是一部分。  
204  正常；无响应 — 已接收请求，但不存在要回送的信息。  

3xx  重定向  
301  已移动 — 请求的数据具有新的位置且更改是永久的。  
302  已找到 — 请求的数据临时具有不同 URI。  
303  请参阅其它 — 可在另一 URI 下找到对请求的响应，且应使用 GET 方法检索此响应。  
304  未修改 — 未按预期修改文档。  
305  使用代理 — 必须通过位置字段中提供的代理来访问请求的资源。  
306  未使用 — 不再使用；保留此代码以便将来使用。  

4xx  客户机中出现的错误  
400  错误请求 — 请求中有语法问题，或不能满足请求。  
401  未授权 — 未授权客户机访问数据。  
402  需要付款 — 表示计费系统已有效。  
403  禁止 — 即使有授权也不需要访问。  
404  找不到 — 服务器找不到给定的资源；文档不存在。  
407  代理认证请求 — 客户机首先必须使用代理认证自身。  
415  介质类型不受支持 — 服务器拒绝服务请求，因为不支持请求实体的格式。  

5xx  服务器中出现的错误  
500  内部错误 — 因为意外情况，服务器不能完成请求。  
501  未执行 — 服务器不支持请求所需要的功能。  
502  错误网关 — 服务器接收到来自上游服务器的无效响应。  
503  无法获得服务 — 由于临时过载或维护，服务器无法处理请求。
```

### 问题解答

一、**发送请求，占用了 woker 的几个连接数？**

答案是2个或者4个。

当浏览器请求是静态请求时，worker直接返回资源，所以是2个。

当浏览器请求是动态请求时，worker去反向代理找Tomcat处理，所以是4个。

二、**nginx 有一个 master，有四个 woker，每个 woker 支持最大的连接数 1024，支持的最大并发数是多少？**

当请求是静态请求时，则：

最大并发数=worker个数（4）* worker支持的最大连接数（1024）/ 所消耗的连接数（2）=2048

当请求是动态请求时，则：

最大并发数=worker个数（4）* worker支持的最大连接数（1024）/ 所消耗的连接数（4）=1024

### 参考文献

nginx实现请求的负载均衡 + keepalived实现nginx的高可用

https://www.cnblogs.com/youzhibing/p/7327342.html
