[TOC]

# Mybatis

MyBatis 是一款优秀的持久层框架，它支持定制化 SQL、存储过程以及高级映射， 避免了几乎所有的 JDBC 代码和手动设置参数以及获取结果集的繁杂。它可以使用简单的 XML 或注解来配置和映射原生信息，将接口和 Java对象映射成数据库中的记录。

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

# **Hibernate**

传统的持久层框架都是采用Java JDBC的连接方式进行数据库的访问和操作，需要人为的编写大量的SQL或者代码，同时还需要将获得的数据进行转换或封装后往外传，其实对于大项目而言这是一个非常烦琐的过程。

Hibernate框架是一个半自动化的持久层框架，可以减少大量的SQL、代码编写工作，省掉很大部分的工作量，在这个框架中，当我们需要相关操作时，不用再关注数据库表也不用再去一行行的查询数据库，只需要通过持久化一个类的方式就可以完成增删改查的功能，因为框架的内部已经实现了很多对数据库的操作方法，我们只需要调用即可，做的最多的工作都在持久化类上。