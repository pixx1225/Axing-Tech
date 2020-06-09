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