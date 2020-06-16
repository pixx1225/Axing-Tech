[TOC]

# 设计模式

## 设计模式的概述

**设计模式**是一套被反复使用的、多数人知晓的、经过分类编目的、代码设计经验的总结。它描述了在软件设计过程中的一些不断重复发生的问题，以及该问题的解决方案。

**目的**是为了提高代码的可重用性、代码的可读性和代码的可靠性。

**设计模式的本质**是面向对象设计原则的实际运用，是对类的封装性、继承性和多态性以及类的关联关系和组合关系的充分理解

## 设计模式的类型

1. 创建型模式（Creational Patterns）用于描述“怎样创建对象”，它的主要特点是“将对象的创建与使用分离”
2. 结构型模式（Structural Patterns）用于描述如何将类或对象按某种布局组成更大的结构
3. 行为型模式（Behavioral Patterns）用于描述类或对象之间怎样相互协作共同完成单个对象都无法单独完成的任务，以及怎样分配职责。

| 创建型模式                                                   | 结构型模式                                                   | 行为型模式                                                   |
| ------------------------------------------------------------ | :----------------------------------------------------------- | :----------------------------------------------------------- |
| 单例模式<br>原型模式<br>工厂模式<br>抽象工厂模式<br>建造者模式 | 适配器模式<br>桥接模式<br>过滤器模式<br>组合模式<br>装饰器模式<br>外观模式<br>享元模式<br>代理模式 | 责任链模式<br>命令模式<br>解释器模式<br>迭代器模式 <br>中介者模式 <br>备忘录模式 <br>观察者模式 <br>状态模式<br>空对象模式 <br>策略模式 <br>模板模式 <br>访问者模式 |

## 设计模式的六大原则

**1、开闭原则（Open Close Principle）**

开闭原则的意思是：**对扩展开放，对修改关闭**。在程序需要进行拓展的时候，不能去修改原有的代码，实现一个热插拔的效果。简言之，是为了使程序的扩展性好，易于维护和升级。想要达到这样的效果，我们需要使用接口和抽象类。

**2、里氏替换原则（Liskov Substitution Principle）**

里氏替换原则是面向对象设计的基本原则之一。 里氏替换原则中说，任何基类可以出现的地方，子类一定可以出现。LSP 是继承复用的基石，只有当派生类可以替换掉基类，且软件单位的功能不受到影响时，基类才能真正被复用，而派生类也能够在基类的基础上增加新的行为。里氏替换原则是对开闭原则的补充。实现开闭原则的关键步骤就是抽象化，而基类与子类的继承关系就是抽象化的具体实现，所以里氏替换原则是对**实现抽象化的具体步骤的规范**。

**3、依赖倒转原则（Dependence Inversion Principle）**

这个原则是开闭原则的基础，具体内容：针对接口编程，依赖于抽象而不依赖于具体。

**4、接口隔离原则（Interface Segregation Principle）**

这个原则的意思是：使用多个隔离的接口，比使用单个接口要好。它还有另外一个意思是：降低类之间的耦合度。由此可见，其实设计模式就是从大型软件架构出发、便于升级和维护的软件设计思想，它强调降低依赖，降低耦合。

**5、迪米特法则，又称最少知道原则（Demeter Principle）**

最少知道原则是指：一个实体应当尽量少地与其他实体之间发生相互作用，使得系统功能模块相对独立。

**6、合成复用原则（Composite Reuse Principle）**

合成复用原则是指：尽量使用合成/聚合的方式，而不是使用继承。

## 1单例模式

### 单例模式的定义与特点：

一个类负责创建自己的对象，同时确保只有单个对象被创建。这个类提供了一种直接访问其唯一的对象的方式，不需要实例化该类的对象。即一个类只有一个实例，且该类能自行创建这个实例

**特点：**

- 1、单例类只能有一个实例对象。
- 2、单例类必须自己创建自己的唯一实例。
- 3、单例类对外提供一个访问该单例的全局访问点

### 单例模式的结构

![运行时数据区](https://github.com/pixx1225/Axing-Tech/blob/master/images/Singleton.gif)

### 单例模式的实现

- **懒汉式**

该模式的特点是类加载时不生成单例，只有当第一次调用 getlnstance 方法时才去创建这个单例，避免内存浪费。

```java
public class LazySingleton{
    private static volatile LazySingleton instance = null;  //保证 instance 在所有线程中同步
    private LazySingleton(){}    //private 避免类在外部被实例化
    public static synchronized LazySingleton getInstance(){
        //getInstance 方法前加同步
        if(instance==null){
            instance=new LazySingleton();
        }
        return instance;
    }
}
```

优点：多线程安全，关键字 volatile 和 synchronized。第一次调用才初始化，避免内存浪费

缺点：必须加锁才能保证单例，但加锁会影响效率，每次访问时都要同步，会影响性能，且消耗更多的资源。多线程getInstance() 使用不频繁，99% 情况下不需要同步。

- **饿汉式**

该模式的特点是类一旦加载就创建一个单例，保证在调用 getInstance 方法之前单例已经存在了。它基于类加载机制避免了多线程的同步问题。

```java
public class HungrySingleton{
    private static final HungrySingleton instance = new HungrySingleton();
    private HungrySingleton(){}
    public static HungrySingleton getInstance(){
        return instance;
    }
}
```

优点：在类创建的同时就创建好一个静态的对象供系统使用，以后不再改变，所以是线程安全的，不用加锁，执行效率会提高。

缺点：类加载时就初始化，浪费内存。

- **双重校验锁（DCL，即 double-checked locking）**

```java
public class Singleton {  
    private static volatile Singleton singleton;  
    private Singleton (){}  
    public static Singleton getSingleton() {  
        if (singleton == null) {  
            synchronized (Singleton.class) {  
                if (singleton == null) {  
                    singleton = new Singleton();  
                }  
            }  
        }  
        return singleton;  
    }  
}
```

### 单例模式的应用实例

If: 国家给每个程序员只分配唯一一个的老婆，你的老婆有且仅有一个人。

```java
public class SingletonLazy{
    public static void main(String[] args){
        President zt1=President.getInstance();
        zt1.getName();    //输出老婆的名字
        President zt2=President.getInstance();
        zt2.getName();    //输出老婆的名字
        if(zt1==zt2){
           System.out.println("他们是同一人！");
        }else{
           System.out.println("他们不是同一人！");
        }
    }
}
class President{
    private static volatile President instance=null;    //保证instance在所有线程中同步
    //private避免类在外部被实例化
    private President(){
        System.out.println("分配一个老婆！");
    }
    public static synchronized President getInstance(){
        //在getInstance方法上加同步
        if(instance==null){
           instance=new President();
        }
        else{
           System.out.println("已经有一个老婆，不能分配新老婆！");
        }
        return instance;
    }
    public void getName(){
        System.out.println("你的老婆是：新垣结衣。");
    }  
}

输出：
    分配一个老婆！
    你的老婆是：新垣结衣。
    已经有一个老婆，不能分配新老婆！
    你的老婆是：新垣结衣。
    他们是同一人！
```

## 2原型模式

### 原型模式的定义与特点：







http://c.biancheng.net/view/1338.html