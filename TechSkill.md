[TOC]

# TechSkill

## 软件总汇

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

- [Visual Studio Code](https://code.visualstudio.com/)
- [Postman](https://www.getpostman.com/)

## 软件破|解
1. [Navicat](https://www.navicat.com.cn/) Premium 15  [Mac版](https://www.52pojie.cn/thread-1101529-1-1.html)  [Windows版](https://www.cnblogs.com/hfxtest/p/12513210.html)
4. [Charles](https://www.charlesproxy.com)   [Windows版](https://www.zzzmode.com/mytools/charles/)
   Charles是一款Http代理服务器和Http监视器，当移动端在无线网连接中按要求设置好代理服务器，使所有对网络的请求都经过Charles客户端来转发时，Charles可以监控这个客户端各个程序所有连接互联网的Http通信。

## IDEA中maven添加dependency过慢的问题
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

## Github 图片不显示的问题

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

## CMD中文乱码

有可能是因为 cmd 终端编码是gbk，而服务器编码格式为utf8，所以需要修改cmd终端编码格式为utf8

> 运行cmd >> 输入chcp，回车查看当前的编码>>输入chcp 65001，回车

直接修改注册表，win+R，输入regedit，进入注册表

> [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Command Processor]
>
> 新建一个字符串值，key-value如下：
> "autorun"="chcp 65001"，之后重新打开cmd即可。

