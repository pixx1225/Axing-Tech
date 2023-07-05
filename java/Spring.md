[TOC]

# Spring

Spring 是 Java EE 编程领域的一款轻量级的开源框架，Spring核心是`IOC`和`AOP`。

**优点**

1：方便解耦，简化开发。IOC容器处理依赖关系降低组件耦合性  

2：AOP（面向切面编程）的支持。 

3：声明式事物的支持。 

4：方便程序的测试

5：方便集成各种主流框架，降低API的使用难度。

## Spring配置方式

1. XML配置文件
2. 注解配置
3. Java Config配置

## IOC 控制反转（Inversion of Control）：

就是把对象的控制管理权交给Spring的IoC容器，由容器控制对象之间的依赖关系，好处在于将对象集中统一管理，并且降低耦合度。我们将由 IoC 容器管理的 Java 对象称为 Spring Bean，它与使用关键字 new 创建的 Java 对象没有任何区别。

```
1.开发人员通过 XML 配置文件、注解、Java 配置类等方式，对 Java 对象进行定义，例如在 XML 配置文件中使用 <bean> 标签、在 Java 类上使用 @Component 注解等。
2.Spring 启动时，IoC 容器会自动根据对象定义，将这些对象创建并管理起来。这些被 IoC 容器创建并管理的对象被称为 Spring Bean。
3.当我们想要使用某个 Bean 时，可以直接从 IoC 容器中获取（例如通过 ApplicationContext 的 getBean() 方法），而不需要手动通过代码（例如 new Obejct() 的方式）创建。
```

(依赖)控制权由应用代码本身转到了外部容器，由容器根据配置文件去创建实例并管理各个实例之间的依赖关系，控制权的转移，就是所谓反转，并且由容器动态的将某种依赖关系注入到组件之中。BeanFactory 是Spring IoC容器的具体实现与核心接口，提供了一个先进的配置机制，使得任何类型的对象的配置成为可能，用来包装和管理各种bean。最直观的表达就是，IOC让对象的创建不用去new了，可以由spring自动生产，这里用的就是java的反射机制，通过反射在运行时动态的去创建、调用对象。spring就是根据配置文件在运行时动态的去创建对象，并调用对象的方法的。

## DI 依赖注入（Denpendency Injection）：

指Spring创建对象的过程中，将对象依赖属性通过配置进行注入。依赖注入是控制反转的基础，在容器实例化对象的时候主动的将被调用者（或者说它的依赖对象）注入给调用对象。比如对象A需要操作数据库，以前我们总是要在A中自己编写代码来获得一个Connection对象，有了 spring我们就只需要告诉spring，A中需要一个Connection，至于这个Connection怎么构造，何时构造，A不需要知道。在系统运行时，spring会在适当的时候制造一个Connection，然后像打针一样，注射到A当中，这样就完成了对各个对象之间关系的控制。

> 控制反转是一种设计思想，依赖注入是实现方式。

## AOP 面向切面编程（Aspect Oriented Programming）：

通过动态代理的方式为程序添加统一功能，集中解决一些公共问题。AOP作为面向对象的一种补充，用于解剖封装好的对象内部，找出其中对多个对象产生影响的公共行为，并将其封装为一个可重用的模块，这个模块被命名为“切面”（Aspect），切面将那些与业务无关，却被业务模块共同调用的逻辑提取并封装起来，减少了系统中的重复代码，降低了模块间的耦合度，同时提高了系统的可维护性。可用于权限认证、日志、监控、事务处理。 AOP实现的关键在于AOP框架自动创建的AOP代理，AOP代理主要分为静态代理和动态代理。静态代理的代表为AspectJ；动态代理则以Spring AOP为代表。IoC让相互协作的组件保持松散的耦合，而AOP编程允许你把遍布于应用各层的功能分离出来形成可重用的功能组件。

> AOP底层是动态代理技术

1. 自定义注解

```java
@Target(ElementType.METHOD) //声明自定义的注解使用在方法上
@Retention(RetentionPolicy.RUNTIME) //注解在运行时生效
public @interface AuditAnno {
}
```

2. 定义切面

```java
@Aspect
@Component
public class AuditAspect {
    //审计信息实体类
    AuditInfo auditInfo = new AuditInfo();

    //定义切面执行位置
    @Pointcut("execution(public * com.axing.office.controller..*(..))")
    public void auditPointcut() {
    }
	
    //环绕通知
    @Around("auditPointcut() && @annotation(aa)")
    public Object auditAround(ProceedingJoinPoint pjp, AuditAnno aa) throws Throwable {
        System.out.println("@Around环绕通知===");
        Object[] args = pjp.getArgs();	//拦截目标方法传入参数
        List<Object> objects = Arrays.asList(args);
        //这里可以更改参数，再传回目标方法
        return pjp.proceed();
    }
    //前置通知：方法执行前调用
    @Before("auditPointcut() && @annotation(aa)")
    public void auditBefore(JoinPoint jp, AuditAnno aa) {
        System.out.println("@Before前置通知===");
        String methodName = jp.getSignature().getName());	//拦截目标方法名
    }

    //后置通知：无论无何都会调用，类似于：try/catch中的finally
    @After("auditPointcut() && @annotation(aa)")
    public void auditAfter(AuditAnno aa) {
        System.out.println("@After后置通知===");
    }
    
    //返回通知: 有返回值时调用
    @AfterRerurning(pointcut = "auditPointcut() && @annotation(aa)", returning = "rt")
    public void auditAfterRerurning(AuditAnno aa, Object rt){
        System.out.println("@AfterRerurning返回通知===");
        XXXMessage message = (XXXMessage)rt;	//拦截返回信息
        System.out.println("最终根据返回信息，存数据库操作==="
    }

    //异常通知：方法抛出异常时执行
    @AfterThrowing(pointcut = "auditPointcut() && @annotation(aa)", throwing = "ex")
    public void auditAfterThrowing(JoinPoint jp, AuditAnno ta, Throwing ex) {
        System.out.println("@AfterThrowing异常通知===");
        XXXException exception = (XXXException)ex;
        //有异常通知则不走返回通知了，记得补上返回通知的内容
    }
```

## Spring框架中的设计模式

工厂设计模式 : Spring使用工厂模式通过 BeanFactory、ApplicationContext 创建 bean 对象。

代理设计模式 : Spring AOP 功能的实现。

单例设计模式 : Spring 中的 Bean 默认都是单例的。

模板方法模式 : Spring 中 jdbcTemplate、hibernateTemplate 等以 Template 结尾的对数据库操作的类，它们就使用到了模板模式。

包装器设计模式 : 我们的项目需要连接多个数据库，而且不同的客户在每次访问中根据需要会去访问不同的数据库。这种模式让我们可以根据客户的需求能够动态切换不同的数据源。

观察者模式: Spring 事件驱动模型就是观察者模式很经典的一个应用。

适配器模式 :Spring AOP 的增强或通知(Advice)使用到了适配器模式、spring MVC 中也是用到了适配器模式适配Controller。

## Spring Bean：

### Bean生命周期：

普通 Java 对象的生命周期是：

- 实例化
- 该对象不再被使用时通过垃圾回收机制进行回收

而对于 Spring Bean 的生命周期来说：

- 实例化 Instantiation
- 属性赋值 Populate
- 初始化 Initialization
- 销毁 Destruction

```
ApplicationContext容器中,Bean的生命周期流程大致如下：
1.首先容器启动后，会对scope为singleton且非懒加载的bean进行实例化createBeanInstance()
2.按照Bean定义信息配置信息，注入所有的属性populateBean() 
3.如果Bean实现了某些接口，则会调用相应的方法，实现初始化initializeBean()
4.容器关闭后，如果Bean实现了DisposableBean接口，则会回调该接口的destroy()方法
```

### Bean作用域：

- singleton : 唯一 bean 实例，Spring 中的 bean 默认都是单例的。
- prototype : 每次请求都会创建一个新的 bean 实例。
- request : 每一次 HTTP 请求都会产生一个新的 bean，该 bean 仅在当前 HTTP request 内有效。
- session : 每一次 HTTP 请求都会产生一个新的 bean，该 bean 仅在当前 HTTP session 内有效。
- global-session： 全局 session 作用域

### Spring基于xml注入bean的几种方式：

（1）Set方法注入；
（2）构造器注入：①通过index设置参数的位置；②通过type设置参数类型；
（3）静态工厂注入；
（4）实例工厂；

## Spring循环依赖

### 1.什么是循环依赖？

循环依赖其实就是循环引用，也就是两个或则两个以上的bean互相持有对方，最终形成闭环。比如A依赖于B，B依赖于C，C又依赖于A。循环依赖是对象的相互依赖。
![img](https://img-blog.csdnimg.cn/img_convert/2e3caaffaf786aeb0d5cfe06dceb8b50.png)

### 2.怎么解决循环依赖

Spring 使用三级缓存来解决循环依赖的问题，三级缓存分别是：

- 一级缓存`singletonObjects`：**为“Spring 的单例属性”而生**，就是个单例池，用来存放已经初始化完成的单例 Bean；
- 二级缓存`earlySingletonObjects`：**为“解决 AOP”而生**，存放的是半成品的 AOP 的单例 Bean；
- 三级缓存`singletonFactories`：**为“打破循环”而生**，存放的是生成半成品单例 Bean 的工厂方法。到三级缓存工厂方法中找到代理对象放到二级缓存中。

### 3.出现循环依赖如何解决

**生成代理对象产生的循环依赖**

这类循环依赖问题解决方法很多，主要有：

1. 使用`@Lazy`注解，延迟加载
2. 使用`@DependsOn`注解，指定加载先后关系
3. 修改文件名称，改变循环依赖类的加载顺序

**使用@DependsOn产生的循环依赖**

这类循环依赖问题要找到`@DependsOn`注解循环依赖的地方，迫使它不循环依赖就可以解决问题。

**多例循环依赖**

这类循环依赖问题可以通过把bean改成单例的解决。

**构造器循环依赖**

这类循环依赖问题可以通过使用`@Lazy`注解解决。

参考文章：[源码深度解析，Spring 如何解决循环依赖？](https://mp.weixin.qq.com/s?__biz=MzU0OTE4MzYzMw==&mid=2247545567&idx=2&sn=8478f342befd6d2d84e3e11c635c4952&chksm=fbb1bb21ccc63237a4890e75a3b43a50b69ef88900fac7e784916fdff134cc94a058c192b63f&scene=27)

# SpringMVC

- M - Model 模型（完成业务逻辑：有javaBean构成，service+dao+entity）
- V - View  视图（做界面的展示  jsp，html……）
- C - Controller 控制器（接收请求—>调用模型—>根据结果派发页面）

## SpringMVC流程

1. 用户发送请求至前端控制器DispatcherServlet。
1. DispatcherServlet收到请求调用HandlerMapping处理器映射器。
1. 处理器映射器找到具体的处理器(可以根据xml配置、注解进行查找)，生成处理器对象及处理器拦截器(如果有则生成)一并返回给DispatcherServlet。
1. DispatcherServlet调用HandlerAdapter处理器适配器。
1. HandlerAdapter经过适配调用具体的处理器(Controller，也叫后端控制器)。
1. Controller执行完成返回ModelAndView。
1. HandlerAdapter将controller执行结果ModelAndView返回给DispatcherServlet。
1. DispatcherServlet将ModelAndView传给ViewReslover视图解析器。
1. ViewReslover解析后返回具体View。
1. DispatcherServlet根据View进行渲染视图（即将模型数据填充至视图中）。
1. DispatcherServlet响应用户。

**组件说明**

DispatcherServlet：作为前端控制器，整个流程控制的中心，控制其它组件执行，统一调度，降低组件
之间的耦合性，提高每个组件的扩展性。
HandlerMapping：通过扩展处理器映射器实现不同的映射方式，例如：配置文件方式，实现接口方
式，注解方式等。
HandlAdapter：通过扩展处理器适配器，支持更多类型的处理器。
ViewResolver：通过扩展视图解析器，支持更多类型的视图解析，

# SpringBoot

Spring Boot基本上是Spring框架的扩展，它消除了设置Spring应用程序所需的XML配置，为更快，更高效的开发生态系统铺平了道路。

以下是Spring Boot中的一些特点：

1.  创建独立的spring应用。
2.  嵌入Tomcat, Jetty 而且不需要部署他们。
3.  提供的“starters” poms来简化Maven配置spring-boot-starter-web
4.  尽可能自动配置spring应用。
5.  提供生产指标,健壮检查和外部化配置
6.  绝对没有代码生成和XML配置要求

## SpringBoot启动流程：



## SpringBoot核心注解

核心注解：@SpringBootApplication: 

1. @SpringBootConfiguration
2. @EnableAutoConfiguration 
3. @ComponentScan

### 运行Spring Boot有哪几种方式

1. 打包用命令或者放到容器中运行
2. 用 Maven/Gradle 插件运行
3. 直接执行 main 方法运行

## Dependencies

```xml
<!-- mybatis -->
<dependency>
  <groupId>org.mybatis</groupId>
  <artifactId>mybatis</artifactId>
  <version>3.5.4</version>
</dependency>
<!-- mysql -->
<dependency>
  <groupId>mysql</groupId>
  <artifactId>mysql-connector-java</artifactId>
  <version>8.0.17</version>
</dependency>  
<!-- lombok -->
<dependency>
  <groupId>org.projectlombok</groupId>
  <artifactId>lombok</artifactId>
  <version>1.18.12</version>
</dependency>
<!-- servlet依赖. -->
<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>javax.servlet-api</artifactId>
    <scope>provided</scope>
</dependency>
<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>jstl</artifactId>
</dependency> 
<!-- tomcat的支持.-->
<dependency>
    <groupId>org.apache.tomcat.embed</groupId>
    <artifactId>tomcat-embed-jasper</artifactId>
    <scope>provided</scope>
</dependency>
<!-- swagger2 -->
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger2</artifactId>
    <version>2.9.2</version>
</dependency>
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger-ui</artifactId>
    <version>2.9.2</version>
</dependency>
<!-- gson -->
<dependency>
    <groupId>com.google.code.gson</groupId>
    <artifactId>gson</artifactId>
</dependency>
<!-- 热部署 -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
    <optional>true</optional> <!-- 这个需要为 true 热部署才有效 -->
</dependency>
<!-- StringUtils -->
<dependency>
  <groupId>org.apache.commons</groupId>
  <artifactId>commons-lang3</artifactId>
  <version>3.4</version>
</dependency>
<!-- CollectionUtils -->
<dependency>
  <groupId>commons-collections</groupId>
  <artifactId>commons-collections</artifactId>
  <version>3.2</version>
</dependency>
```

# SpringCloud

