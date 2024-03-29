[TOC]

# 计算机网络

## 计算机网络体系结构

![计算机网络体系结构](../images/计算机网络体系结构.jpg)

## TCP三次握手

![TCP三次握手](../images/TCP三次握手.jpg)

## TCP 协议如何保证可靠传输

1. 应用数据被分割成 TCP 认为最适合发送的数据块。
2. TCP 给发送的每一个包进行编号，接收方对数据包进行排序，把有序数据传送给应用层。
3. **校验和：** TCP 将保持它首部和数据的检验和。这是一个端到端的检验和，目的是检测数据在传输过程中的任何变化。如果收到段的检验和有差错，TCP 将丢弃这个报文段和不确认收到此报文段。
4. TCP 的接收端会丢弃重复的数据。
5. **流量控制：** TCP 连接的每一方都有固定大小的缓冲空间，TCP的接收端只允许发送端发送接收端缓冲区能接纳的数据。当接收方来不及处理发送方的数据，能提示发送方降低发送的速率，防止包丢失。TCP 使用的流量控制协议是可变大小的滑动窗口协议。 （TCP 利用滑动窗口实现流量控制）
6. **拥塞控制：** 当网络拥塞时，减少数据的发送。
7. **ARQ协议：** 也是为了实现可靠传输的，它的基本原理就是每发完一个分组就停止发送，等待对方确认。在收到确认后再发下一个分组。
8. **超时重传：** 当 TCP 发出一个段后，它启动一个定时器，等待目的端确认收到这个报文段。如果不能及时收到一个确认，将重发这个报文段。



### 浏览器从接收到一个URL，到最后展示出页面，经历了哪些过程。

1.DNS解析 2.TCP连接 3.发送HTTP请求 4.服务器处理请求并返回HTTP报文 5.浏览器解析渲染页面6.连接结束



## HTTPS和HTTP的区别：

　　1、http是超文本传输协议，信息是明文传输，数据未加密，https则是具有安全性的**ssl加密**传输协议。

　　2、https协议需要到**CA申请证书**，一般免费证书较少，因而需要一定费用。

　　3、http和https使用的是完全不同的连接方式，用的端口也不一样，前者是**80**，后者是**443**。

　　4、http的连接很简单，是无状态的；HTTPS协议是由SSL+HTTP协议构建的可进行加密传输、身份认证的网络协议，比http协议安全，但更消耗资源。

Https的加密机制是一种共享密钥加密和公开密钥加密并用的混合加密机制。



## HTTP长连接和短连接的区别：

在HTTP/1.0中默认使用短连接。也就是说，客户端和服务器每进行一次HTTP操作，就建立一次连接，任务结束就中断连接。当客户端浏览器访问的某个网页中包含有其他的Web资源，每遇到这样一个Web资源，浏览器就会重新建立一个HTTP会话。

而从HTTP/1.1起，默认使用长连接，用以保持连接特性。使用长连接的HTTP协议，会在响应头加入这行代码：

```
Connection:keep-alive
```

在使用长连接的情况下，当一个网页打开完成后，客户端和服务器之间用于传输HTTP数据的TCP连接不会关闭，客户端再次访问这个服务器时，会继续使用这一条已经建立的连接。Keep-Alive不会永久保持连接，它有一个保持时间，可以在不同的服务器软件（如Apache）中设定这个时间。实现长连接需要客户端和服务端都支持长连接。

**HTTP协议的长连接和短连接，实质上是TCP协议的长连接和短连接。**



## TCP和UDP的区别：

**TCP**面向连接，提供可靠的服务。每一条TCP连接只能是点到点的。面向字节流。全双工的可靠信道。TCP通过三次握手建立连接确认、滑动窗口、超时重传、拥塞控制等机制实现可靠传输，数据传完，断开连接来节约资源。

缺点：慢，效率低，占用资源高，易被攻击

**UDP**是无连接的即发送数据之前不需要建立连接，尽最大努力交付，不保证可靠交付。面向报文。

UDP支持一对一，一对多，多对一和多对多的交互通信。UDP快，具有较好的实时性，工作效率比TCP高。适用于媒体通信/广播通信。

缺点：不可靠，不稳定，UDP没有TCP那些可靠的机制，在数据传递时，如果网络质量不好，就会很容易丢包。



## Get和Post的区别：

**GET**请求会向数据库发索取数据的请求，从而来获取信息，该请求就像数据库的**select**操作一样，只是用来**查询**一下数据，不会修改、增加数据，不会影响资源的内容。**参数通过URL传递**，有**长度限制**。**不安全**。请求会被浏览器主动缓存。

**POST**请求是向服务器端发送数据的，但是该请求会**改变数据**的种类等资源，就像数据库的**insert**操作一样，会创建新的内容。参数传输更**安全**。



## Session和Cookie的区别：

1. 存储位置不同。cookie数据存在客户浏览器上，session数据放在服务器上。
2. 安全性不同。cookie不是很安全，别人可以分析存放在本地的cookie并进行cookie欺骗，考虑到安全应当使用session。
3. 容量和个数限制。单个cookie保存的数据不能超过4K，浏览器限制一个站点最多保存20个cookie。session会在一定时间内保存在服务器上访问过多增加服务器压力。
4. 存储的多样性：session可以存储在Redis中、数据库中、应用程序中，而cookie只能存储在浏览器中。
5. 将登陆信息等重要信息存放为session，其他信息如果需要保留，可以放在cookie中



## URI和URL的区别：

- URI(Uniform Resource Identifier) 是统一资源标志符，可以唯一标识一个资源。
- URL(Uniform Resource Location) 是统一资源定位符，可以提供该资源的路径。它是一种具体的 URI，即 URL 可以用来标识一个资源，而且还指明了如何 locate 这个资源。

URI的作用像身份证号一样，URL的作用更像家庭住址一样。URL是一种具体的URI，它不仅唯一标识资源，而且还提供了定位该资源的信息。



## HTTP 状态码

服务器返回的**响应报文**中第一行为状态行，包含了状态码以及原因短语，用来告知客户端请求的结果。

| 状态码 |               类别               |            含义            |
| :----: | :------------------------------: | :------------------------: |
|  1XX   |  Informational（信息性状态码）   |     接收的请求正在处理     |
|  2XX   |      Success（成功状态码）       |      请求正常处理完毕      |
|  3XX   |   Redirection（重定向状态码）    | 需要进行附加操作以完成请求 |
|  4XX   | Client Error（客户端错误状态码） |     服务器无法处理请求     |
|  5XX   | Server Error（服务器错误状态码） |     服务器处理请求出错     |

```xml
400（错误请求）      服务器不理解请求的语法。
401（未授权）        请求要求身份验证。对于登录后请求的网页，服务器可能返回此响应。
403（禁止）         服务器拒绝请求。
404（未找到）        服务器找不到请求的网页。例如，对于服务器上不存在的网页经常会返回此代码。
500（服务器内部错误） 服务器遇到错误，无法完成请求。
501（未实现）        服务器不支持实现此请求所需的功能。
502（错误网关）      服务器作为网关或代理，从上游服务器收到无效响应。
503（服务不可用）     服务器目前无法使用（由于超载或停机维护）。
```



## 常用端口号

1.HTTP协议代理服务器常用端口号：80/8080/3128/8081/9098 

HTTP服务器默认端口号为80/tcp HTTPS服务器默认端口号为443/tcp 443/udp

2.SOCKS代理协议服务器常用端口号：1080

3.FTP（文件传输）协议代理服务器常用端口号：21

4.Telnet（远程登录）协议代理服务器常用端口号：23



## 对称加密与非对称加密

**对称加密**：加解密使用同一密钥，不安全。DES，IDEA，AES

**非对称加密**：公钥加密，私钥解密；公钥可以公开给别人进行加密，私钥永远在自己手里，非常安全。适用分布式系统数据加密，RSA，DSA

常用的对称加密算法有：DES、3DES、RC2、RC4、AES

常用的非对称加密算法有：RSA、DSA、ECC

使用单向散列函数的加密算法：MD5、SHA



## 参考阅读

《图解HTTP》