# Spring AOP

**面向切面编程 AOP（Aspect Oriented Programming）**

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



**动态代理**其实就是Java中的一个方法，这个方法可以实现：动态创建一组指定的接口的实现对象（在运行时，创建实现了指定的一组接口的对象），例如：

```java
interface A {}
interface B {}
//obj对象的类型实现了A和B两个接口
Object obj = 方法(new Class[]{A.class, B.class})
```

【案例分析】

先写两个接口

```java
interface A {
    public void a();
}
interface B {
    public void b();
}
```

动态代理的代码

```java
public static Object newProxyInstance(ClassLoader loader, Class<?>[] interfaces, InvocationHandler h)
//上面这个就是动态代理类（Proxy）类中的创建代理对象的方法
	//ClassLoader方法需要动态生成一个类，这个类实现了A和B两个接口，然后创建这个类的对象。需要生成一个类，而且这个类也需要加载到方法区中，所以我们需要一个ClassLoader来加载该类
    //Class<?>[] interfaces：我们需要代理对象实现的数组
```

|                 | 通知     | 描述                                                         |
| --------------- | -------- | ------------------------------------------------------------ |
| JoinPoint       | 连接点   |                                                              |
| @Pointcut       | 切点     |                                                              |
| @Before         | 前置通知 | 在一个方法执行之前，执行通知。                               |
| @After          | 后置通知 | 在一个方法执行之后，不考虑其结果，执行通知。                 |
| @AfterReturning | 返回通知 | 在一个方法执行之后，只有在方法成功完成时，才能执行通知。     |
| @AfterThrowing  | 异常通知 | 在一个方法执行之后，只有在方法退出抛出异常时，才能执行通知。 |
| @Around         | 环绕通知 | 在建议方法调用之前和之后，执行通知。                         |