[TOC]

# 计算机网络

## 计算机网络体系结构

![计算机网络体系结构](https://github.com/pixx1225/Axing-Tech/blob/master/images/计算机网络体系结构.jpg)

## TCP三次握手

![TCP三次握手](https://github.com/pixx1225/Axing-Tech/blob/master/images/TCP三次握手.jpg)



**浏览器从接收到一个URL，到最后展示出页面，经历了哪些过程。**

1.DNS解析 2.TCP连接 3.发送HTTP请求 4.服务器处理请求并返回HTTP报文 5.浏览器解析渲染页面

## HTTPS和HTTP的区别：

　　1、http是超文本传输协议，信息是明文传输，数据未加密，https则是具有安全性的**ssl加密**传输协议。

　　2、https协议需要到**CA申请证书**，一般免费证书较少，因而需要一定费用。

　　3、http和https使用的是完全不同的连接方式，用的端口也不一样，前者是**80**，后者是**443**。

　　4、http的连接很简单，是无状态的；HTTPS协议是由SSL+HTTP协议构建的可进行加密传输、身份认证的网络协议，比http协议安全，但更消耗资源。

Https的加密机制是一种共享密钥加密和公开密钥加密并用的混合加密机制。

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