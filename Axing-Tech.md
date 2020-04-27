[TOC]

# 计算机软件安装大全

> 软件安装或破解教程均在链接【link】里（我是大自然的搬运工）
> 以下软件的安装均有效，如有问题，欢迎讨论，谢谢 :smile:
> 持续更新中～～～

---
### 基本软件
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
1. Eclipse
2. JetBrains IntelliJ IDEA
- 解决IDEA中maven添加dependency过慢的问题
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
### Python开发
1. JetBrains PyCharm
2. Anacoda
### 其他开发
1. [Visual Studio Code](https://code.visualstudio.com/)
3. [Navicat](https://www.navicat.com.cn/) Premium 15 Mac版本安装及破解 [link](https://www.52pojie.cn/thread-1101529-1-1.html)
4. [Postman](https://www.getpostman.com/)
Postman是一款强大网页调试与发送网页HTTP请求的工具。也有Chrome插件版一样好用。
5. [Charles官网](https://www.charlesproxy.com) [破解link](https://www.zzzmode.com/mytools/charles/)
Charles是一款Http代理服务器和Http监视器，当移动端在无线网连接中按要求设置好代理服务器，使所有对网络的请求都经过Charles客户端来转发时，Charles可以监控这个客户端各个程序所有连接互联网的Http通信。



---

---

# Java

javac HelloWorld.java
java HelloWorld



### Spring Dependencies

```xml
<dependency>
  <groupId>mysql</groupId>
  <artifactId>mysql-connector-java</artifactId>
  <version>8.0.17</version>
</dependency>  
<dependency>
  <groupId>org.projectlombok</groupId>
  <artifactId>lombok</artifactId>
  <version>1.18.12</version>
</dependency>
```



---

---

# Mysql

1. 连接数据库
mysql -uusername -ppassword;

2. 查看库和表
show databases;
use test;
show tables;

3. 创建库

  DROP DATABASE IF EXISTS test1;

  create database test1 charset utf8;

4. 删除库
    drop database test1;

5. 创建表
    create table stu(
    sid int,
    sname varchar(10)
    )engine myisam charset utf8;

6. 重命名表名
    rename table stu to newstu;

7. 插入表数据
    insert into newstu values
    (1,'zhangsan'),
    (2,'lisi'),
    (3,'wangwu');

8. 清空表数据
    truncate newstu;

9. delete和truncate不删除表结构，delete可回滚，产生碎片，truncate速度快，释放空间。

10. \c 跳出当前命令

11. set names gbk; 设置输入输出字符格式

12. create table class(
    id int primary key auto_increment,
    sname varchar(10) not null default '',
    gender char(1) not null default '',
    company varchar(20) not null default '',
    salary decimal(6,2) not null default 0.00,
    fanbu smallint not null default 0
    )engine myisam charset utf8

13. desc class; 查看表结构；

14. 插入
    insert into class 
    values
    (1,'张三','男','百度',8888.67,200);

    insert into class 
    (sname,gender,salary)
    values
    ('李四','男',6666.66);

15. 修改
    update class
    set salary=9999.99
    where id=3;

    alter修改表结构字段类型

    添加列
    alter table 表名 add 列名 列类型 列参数 
    after 某列【把新列加在某列后面
    first 最前面
    修改列类型
    alter table 表名 modify 列名 新类型 新参数
    修改列名
    alter table 表名 change 旧列名 新列名 新类型 新参数
    删除列
    alter table 表名 trop 列名;

16. 删除
    delete from class where salary>8000;

17. 列类型
    整型
    tinyint 1字节，-128-127，0-255(无符号)
    smallint 2字节 mediumint 3字节 int 4字节 bigint 8字节

int系列参数声明默认有符号， unsigned zerofill (M) M表示补0宽度，和zerofill配合使用。

小数型
float(D,M) decimal(D,M)

字符串型
char(M) varchar(M) text
blob 二进制类型，用来存储图像等二进制信息

日期时间型
date 1000-01-01~9999-12-31 
time 00:00:00
datetime YYYY-MM-DD HH:mm:ss
timestamp current_timestamp
year 1901-2155
~

18. create table member(
	id int unsigned auto_increment primary key,
	username char(20) not null default '',
	gender char(1) not null default '',
	weight tinyint unsigned not null default 0,
	brith date not null default '0000-00-00',
	salary decimal(8,2) not null default 0.00,
	lastlogin int unsigned not null default 0
	)engine myisam charset utf8;
把频繁使用的信息存放一张表，把其他不常用数据信息存另一张表

20. 查询 select
like   %匹配任意字符  __匹配任意单个字符
字符替换 模糊查询
select goods_id,goods_name, concat('小米',substring(goods_name,4))
from goods where goods_name like '诺基亚%';

group by
select sum(goods_number) from goods group by cat_id;

having

order by 列1 desc， 列2 asc, 列3 asc;
asc升序   desc降序

limit [offset],N 
limit 2,3 第3名到第5名

---

---

# Mybatis

### JDBC

```java
public static void main(String[] args){
  Connection conn = null;
  PreparedStatement ps = null;
  ResultSet rs = null;
  try{
    //加载数据库驱动
    Class.forName("com.mysql.jdbc.Driver");
    //通过驱动管理类获取数据库链接
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mybatis?characterEncoding=utf-8","root","passport");
    //定义sql语句，？表示占位符
    String  sql = "select * from user where username = ?";
    //获取预处理statement
    ps = conn.prepareStatement(sql);
    //设置参数
    ps.setString(1,"王五");
    //向数据库发出sql执行查询，查询出结果集
    rs = ps.executeQuery();
    //遍历查询结果集
    while(rs.next()){
      System.out.println(rs.getString("id")+" "+rs.getString("username"));
    }
  }catch (Exception e){
    e.printStackTrace();
  }finally{
    //释放资源
    if(rs != null){
      try{
        rs.close();
      }catch(SQLException e){
        e.printStackTrace();
      }
    }
    if(ps != null){
      try{
        ps.close();
      }catch(SQLException e){
        e.printStackTrace();
      }
    }
    if(conn != null){
      try{
        conn.close();
      }catch(SQLException e){
        e.printStackTrace();
      }
    }
  }
}
```

### Mybatis配置文件的约束

```xml
<!--Config的约束-->
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE configuration 
				PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<!--Mapper的约束-->
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper 
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
```

### Mybatis常用注解说明

```java
@Select：查询
@Insert：新增
@Update：更新
@Delete：删除
@Result：结果集封装
@Results：与Result一起使用，封装多个结果集
@ResultMap：引用Results定义的封装
@One：一对一结果集封装
@Many：一对多结果集封装
@SelectProvider：动态SQL映射
@CacheNamespace：注解二级缓存的使用
```



# windows DOS 命令

exit 退出
cls 清屏 (Mac 是 clear)
dir 当前目录
cd C:\Users\Administrator\Desktop
cd .. 回到上级目录
cd \ 回到根目录


















