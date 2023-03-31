[TOC]

# Mysql

MySQL 是一种关系型数据库，是开源免费的。默认端口号是**3306**。

### 存储引擎

查看MySQL提供的所有存储引擎

```sql
mysql> show engines;
```

### 一条sql语句在mysql中如何执行的

* MySQL 主要分为 Server 层和引擎层，Server 层主要包括连接器、查询缓存、分析器、优化器、执行器，同时还有一个日志模块（binlog），这个日志模块所有执行引擎都可以共用,redolog 只有 InnoDB 有。
* 引擎层是插件式的，目前主要包括，MyISAM,InnoDB,Memory 等。
* 查询语句的执行流程如下：权限校验（如果命中缓存）---》查询缓存---》分析器---》优化器---》权限校验---》执行器---》引擎
* 更新语句执行流程如下：分析器----》权限校验----》执行器---》引擎---redo log(prepare 状态---》binlog---》redo log(commit状态)



推荐阅读：

[MySQL索引原理及慢查询优化](https://tech.meituan.com/2014/06/30/mysql-index.html)