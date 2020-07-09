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
| 单例模式<br>原型模式<br>工厂模式<br>抽象工厂模式<br>建造者模式 | 代理模式<br>适配器模式<br>装饰器模式<br>桥接模式<br>过滤器模式<br>组合模式<br>外观模式<br>享元模式 | 责任链模式<br>命令模式<br>解释器模式<br>迭代器模式 <br>中介者模式 <br>备忘录模式 <br>观察者模式 <br>状态模式<br>空对象模式 <br>策略模式 <br>模板模式 <br>访问者模式 |

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

![](https://github.com/pixx1225/Axing-Tech/blob/master/images/Singleton.gif)

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

【例】If: 国家给每个程序员只分配唯一一个的老婆，你的老婆有且仅有一个人。

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

用一个已经创建的实例作为原型，通过复制该原型对象来创建一个和原型相同或相似的新对象。原型实例指定了要创建的对象的种类。用这种方式创建对象非常高效，根本无须知道对象创建的细节。

**适用场景：**

- 对象之间相同或相似，即只是个别的几个属性不同的时候。
- 对象的创建过程比较麻烦，但复制比较简单的时候。

### 原型模式的结构

![](https://github.com/pixx1225/Axing-Tech/blob/master/images/Prototype.gif)

### 原型模式的实现

原型模式的克隆分为浅克隆和深克隆（实现 Serializable 读取二进制流），Java 中的 Object 类提供了浅克隆的 clone() 方法，具体原型类只要实现 Cloneable 接口就可实现对象的浅克隆，这里的 Cloneable 接口就是抽象原型类。其代码如下：

```java
//具体原型类
class PrototypeClass implements Cloneable{
	@Override
    public PrototypeClass clone() throws CloneNotSupportedException{
        return (PrototypeClass)super.clone();
    }
}
//原型模式的测试类
public class PrototypeTest{
    public static void main(String[] args) throws CloneNotSupportedException{
        PrototypeClass obj1 = new PrototypeClass();
        PrototypeClass obj2 = (PrototypeClass)obj1.clone();
        System.out.println("obj1==obj2?" + (obj1 == obj2));
    }
}

输出：
	obj1==obj2?false
```

### 原型模式的应用实例

【例】用原型模式模拟“孙悟空”复制自己

将孙悟空SunWuKong类定义成面板 JPanel 的子类，里面包含了标签，用于保存孙悟空的图像。另外，重写了 Cloneable 接口的 clone() 方法，用于复制新的孙悟空。访问类可以通过调用孙悟空的 clone() 方法复制多个孙悟空，并在框架窗体 JFrame 中显示。[孙悟空图像](https://github.com/pixx1225/Axing-Tech/blob/master/images/Wukong.jpg)

```java
import java.awt.*;
import javax.swing.*;

class SunWukong extends JPanel implements Cloneable {

    public SunWukong() {
        JLabel l1 = new JLabel(new ImageIcon("src/Wukong.jpg"));
        this.add(l1);
    }

    public Object clone() {
        SunWukong sw = null;
        try {
            sw = (SunWukong) super.clone();
        } catch (CloneNotSupportedException e) {
            System.out.println("拷贝悟空失败!");
        }
        return sw;
    }
}

public class Prototype {
    public static void main(String[] args) {
        JFrame jf = new JFrame("原型模式测试");
        jf.setLayout(new GridLayout(1, 2));
        Container contentPane = jf.getContentPane();

        SunWukong obj1 = new SunWukong();
        contentPane.add(obj1);
        SunWukong obj2 = (SunWukong) obj1.clone();
        contentPane.add(obj2);
        
        jf.pack();
        jf.setVisible(true);
        jf.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    }
}
```

## 3工厂模式

### 工厂模式的定义与特点：

**定义：**

定义一个创建产品对象的工厂接口，将产品对象的实际创建工作推迟到具体子工厂类当中。这满足创建型模式中所要求的“创建与使用相分离”的特点。

**优点：**

- 用户只需要知道具体工厂的名称就可得到所要的产品，无须知道产品的具体创建过程；
- 在系统增加新的产品时只需要添加具体产品类和对应的具体工厂类，无须对原工厂进行任何修改，满足开闭原则；

**缺点：**

- 每增加一个产品就要增加一个具体产品类和一个对应的具体工厂类，这增加了系统的复杂度。

**适用场景：**

- 客户只知道创建产品的工厂名，而不知道具体的产品名。如 华为手机工厂、小米手机工厂等。
- 创建对象的任务由多个具体子工厂中的某一个完成，而抽象工厂只提供创建产品的接口。
- 客户不关心创建产品的细节，只关心产品的品牌。

### 工厂模式的结构

1. 抽象工厂（AbstractFactory）：提供了创建产品的接口，调用者通过它访问具体工厂的工厂方法 newProduct() 来创建产品。
2. 具体工厂（ConcreteFactory）：主要是实现抽象工厂中的抽象方法，完成具体产品的创建。
3. 抽象产品（Product）：定义了产品的规范，描述了产品的主要特性和功能。
4. 具体产品（ConcreteProduct）：实现了抽象产品角色所定义的接口，由具体工厂来创建，它同具体工厂之间一一对应。

![](https://github.com/pixx1225/Axing-Tech/blob/master/images/Factory.gif)

### 工厂模式的实现

简单工厂模式：一个抽象的接口，多个抽象接口的实现类，一个工厂类，用来实例化抽象的接口

```java
// 抽象产品类
interface Car {
    public void run();
    public void stop();
}
// 具体产品实现类
class Benz implements Car {
    public void run() {
        System.out.println("Benz开始启动了。。。。。");
    }
    public void stop() {
        System.out.println("Benz停车了。。。。。");
    }
}

class Ford implements Car {
    public void run() {
        System.out.println("Ford开始启动了。。。");
    }
    public void stop() {
        System.out.println("Ford停车了。。。。");
    }
}

// 工厂类
class Factory {
    public static Car getCarInstance(String type) {
        Car c = null;
        if ("Benz".equals(type)) {
            c = new Benz();
        }
        if ("Ford".equals(type)) {
            c = new Ford();
        }
        return c;
    }
}

public class FactoryClass {
    public static void main(String[] args) {
        Car c = Factory.getCarInstance("Benz");
        if (c != null) {
            c.run();
            c.stop();
        } else {
            System.out.println("造不了这种汽车。。。");
        }
    }
}
```

工厂方法模式：有四个角色，抽象工厂模式，具体工厂模式，抽象产品模式，具体产品模式。

不再是由一个工厂类去实例化具体的产品，而是由抽象工厂的子类去实例化产品

```java
//抽象产品：提供了产品的接口
interface Product {
    public void produce();
}

//具体产品1：实现抽象产品中的抽象方法
class ConcreteProduct1 implements Product {
    public void produce() {
        System.out.println("生产具体产品1...");
    }
}
//具体产品2：实现抽象产品中的抽象方法
class ConcreteProduct2 implements Product {
    public void produce() {
        System.out.println("生产具体产品2...");
    }
}

//抽象工厂：提供了厂品的生成方法
interface AbstractFactory {
    public Product newProduct();
}

//具体工厂1：实现了厂品的生成方法
class ConcreteFactory1 implements AbstractFactory {
    public Product newProduct() {
        System.out.println("具体工厂1生成-->具体产品1...");
        return new ConcreteProduct1();
    }
}
//具体工厂2：实现了厂品的生成方法
class ConcreteFactory2 implements AbstractFactory {
    public Product newProduct() {
        System.out.println("具体工厂2生成-->具体产品2...");
        return new ConcreteProduct2();
    }
}

// 测试类
public class FactoryMethod {
    public static void main(String[] args) {
        AbstractFactory af = new ConcreteFactory1();
        Product prod = af.newProduct();
        prod.produce();
    }
}
输出：
    具体工厂1生成-->具体产品1...
	生产具体产品1...
```



### 工厂模式的应用实例

【例】有很多种类的畜牧场，如养猴场用于养猴，养牛场用于养牛。对养猴场和养牛场等具体工厂类，只要定义一个生成动物的方法 newAnimal() 即可。由于要显示猴类和牛类等具体产品类的图像，所以它们的构造函数中用到了 JPanel、JLabd 和 ImageIcon 等组件，并定义一个 show() 方法来显示它们。

```java
import java.awt.*;
import javax.swing.*;

public class PCFactory {
    public static void main(String[] args) {
        AnimalFarm af = new MonkeyFarm();
        Animal a = af.newAnimal();
        a.show();
    }
}

//抽象产品：动物类
interface Animal {
    public void show();
}

//具体产品：猴类
class Monkey implements Animal {
    JScrollPane sp;
    JFrame jf = new JFrame("工厂方法模式测试");

    public Monkey() {
        Container contentPane = jf.getContentPane();
        JPanel p1 = new JPanel();
        p1.setLayout(new GridLayout(1, 1));
        p1.setBorder(BorderFactory.createTitledBorder("动物：猴"));
        sp = new JScrollPane(p1);
        contentPane.add(sp, BorderLayout.CENTER);
        JLabel l1 = new JLabel(new ImageIcon("src/Wukong.jpg"));
        p1.add(l1);
        jf.pack();
        jf.setVisible(false);
        jf.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    }

    public void show() {
        jf.setVisible(true);
    }
}

//具体产品：牛类
class Cattle implements Animal {
    JScrollPane sp;
    JFrame jf = new JFrame("工厂方法模式测试");

    public Cattle() {
        Container contentPane = jf.getContentPane();
        JPanel p1 = new JPanel();
        p1.setLayout(new GridLayout(1, 1));
        p1.setBorder(BorderFactory.createTitledBorder("动物：牛"));
        sp = new JScrollPane(p1);
        contentPane.add(sp, BorderLayout.CENTER);
        JLabel l1 = new JLabel(new ImageIcon("src/A_Cattle.jpg"));
        p1.add(l1);
        jf.pack();
        jf.setVisible(false);
        jf.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE); 
    }

    public void show() {
        jf.setVisible(true);
    }
}

//抽象工厂：畜牧场
interface AnimalFarm {
    public Animal newAnimal();
}

//具体工厂：养猴场
class MonkeyFarm implements AnimalFarm {
    public Animal newAnimal() {
        System.out.println("新猴出生！");
        return new Monkey();
    }
}

//具体工厂：养牛场
class CattleFarm implements AnimalFarm {
    public Animal newAnimal() {
        System.out.println("新牛出生！");
        return new Cattle();
    }
}
```

## 4抽象工厂模式

### 抽象工厂模式的定义与特点

前面介绍的工厂方法模式中考虑的是一类产品的生产，如畜牧场只养动物、电视机厂只生产电视机、计算机软件学院只培养计算机软件专业的学生等。工厂方法模式只考虑生产同等级的产品，但是在现实生活中许多工厂是综合型的工厂，能生产多等级（种类） 的产品，如农场里既养动物又种植物，电器厂既生产电视机又生产洗衣机或空调，大学既有软件专业又有生物专业等。

**定义：** 

是一种为访问类提供一个创建一组相关或相互依赖对象的接口，且访问类无须指定所要产品的具体类就能得到同族的不同等级的产品的模式结构。

抽象工厂模式是工厂方法模式的升级版本，工厂方法模式只生产一个等级的产品，而抽象工厂模式可生产多个等级的产品。

使用抽象工厂模式一般要满足以下条件。

- 系统中有多个产品族，每个具体工厂创建同一族但属于不同等级结构的产品。
- 系统一次只可能消费其中某一族产品，即同族的产品一起使用。

**优点：**

- 可以在类的内部对产品族中相关联的多等级产品共同管理，而不必专门引入多个新的类来进行管理。
- 当增加一个新的产品族时不需要修改原代码，满足开闭原则。

**缺点：** 

- 当产品族中需要增加一个新的产品时，所有的工厂类都需要进行修改。

### 抽象工厂模式的结构

抽象工厂模式同工厂方法模式一样，也是由抽象工厂、具体工厂、抽象产品和具体产品等 4 个要素构成，但抽象工厂中方法个数不同，抽象产品的个数也不同。

![](https://github.com/pixx1225/Axing-Tech/blob/master/images/AbstractFactory.gif)

### 抽象工厂模式的实现

1. 抽象工厂：提供了产品的生成方法。

```java
interface AbstractFactory
{
    public Product1 newProduct1();
    public Product2 newProduct2();
}
```

2. 具体工厂：实现了产品的生成方法。

```java
class ConcreteFactory1 implements AbstractFactory
{
    public Product1 newProduct1()
    {
        System.out.println("具体工厂 1 生成-->具体产品 11...");
        return new ConcreteProduct11();
    }
    public Product2 newProduct2()
    {
        System.out.println("具体工厂 1 生成-->具体产品 21...");
        return new ConcreteProduct21();
    }
}
class ConcreteFactory2 implements AbstractFactory
{
    public Product1 newProduct1()
    {
        System.out.println("具体工厂 2 生成-->具体产品 12...");
        return new ConcreteProduct12();
    }
    public Product2 newProduct2()
    {
        System.out.println("具体工厂 2 生成-->具体产品 22...");
        return new ConcreteProduct22();
    }
}
```

### 抽象工厂模式的应用实例

【例】用抽象工厂模式设计农场类。

农场中除了有畜牧场养动物，还可以培养植物，如养马、养牛、种菜、种水果等。本例用抽象工厂模式来设计两个农场，一个是韶关农场用于养牛和种菜，一个是上饶农场用于养马和种水果，可以在以上两个农场中定义一个生成动物的方法 newAnimal() 和一个培养植物的方法 newPlant()。显示 [牛](https://github.com/pixx1225/Axing-Tech/blob/master/images/A_Cattle.jpg)，[蔬菜](https://github.com/pixx1225/Axing-Tech/blob/master/images/P_Vegetables.jpg) 的图片。

```java
import javax.swing.*;
import java.awt.*;

public class AbstractFactoryClass {
    public static void main(String[] args) {
        Farm f = new SGfarm();
        Animal a = f.newAnimal();
        Plant p = f.newPlant();
        a.show();
        p.show();
    }
}

//抽象产品：动物类
interface Animal {
    public void show();
}

//具体产品：马类
class Horse implements Animal {
    JScrollPane sp;
    JFrame jf = new JFrame("抽象工厂模式测试");

    public Horse() {
        Container contentPane = jf.getContentPane();
        JPanel p1 = new JPanel();
        p1.setLayout(new GridLayout(1, 1));
        p1.setBorder(BorderFactory.createTitledBorder("动物：马"));
        sp = new JScrollPane(p1);
        contentPane.add(sp, BorderLayout.CENTER);
        JLabel l1 = new JLabel(new ImageIcon("src/A_Horse.jpg"));
        p1.add(l1);
        jf.pack();
        jf.setVisible(false);
        jf.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);//用户点击窗口关闭
    }

    public void show() {
        jf.setVisible(true);
    }
}

//具体产品：牛类
class Cattle implements Animal {
    JScrollPane sp;
    JFrame jf = new JFrame("抽象工厂模式测试");

    public Cattle() {
        Container contentPane = jf.getContentPane();
        JPanel p1 = new JPanel();
        p1.setLayout(new GridLayout(1, 1));
        p1.setBorder(BorderFactory.createTitledBorder("动物：牛"));
        sp = new JScrollPane(p1);
        contentPane.add(sp, BorderLayout.CENTER);
        JLabel l1 = new JLabel(new ImageIcon("src/A_Cattle.jpg"));
        p1.add(l1);
        jf.pack();
        jf.setVisible(false);
        jf.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);//用户点击窗口关闭
    }

    public void show() {
        jf.setVisible(true);
    }
}

//抽象产品：植物类
interface Plant {
    public void show();
}

//具体产品：水果类
class Fruitage implements Plant {
    JScrollPane sp;
    JFrame jf = new JFrame("抽象工厂模式测试");

    public Fruitage() {
        Container contentPane = jf.getContentPane();
        JPanel p1 = new JPanel();
        p1.setLayout(new GridLayout(1, 1));
        p1.setBorder(BorderFactory.createTitledBorder("植物：水果"));
        sp = new JScrollPane(p1);
        contentPane.add(sp, BorderLayout.CENTER);
        JLabel l1 = new JLabel(new ImageIcon("src/P_Fruitage.jpg"));
        p1.add(l1);
        jf.pack();
        jf.setVisible(false);
        jf.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);//用户点击窗口关闭
    }

    public void show() {
        jf.setVisible(true);
    }
}

//具体产品：蔬菜类
class Vegetables implements Plant {
    JScrollPane sp;
    JFrame jf = new JFrame("抽象工厂模式测试");

    public Vegetables() {
        Container contentPane = jf.getContentPane();
        JPanel p1 = new JPanel();
        p1.setLayout(new GridLayout(1, 1));
        p1.setBorder(BorderFactory.createTitledBorder("植物：蔬菜"));
        sp = new JScrollPane(p1);
        contentPane.add(sp, BorderLayout.CENTER);
        JLabel l1 = new JLabel(new ImageIcon("src/P_Vegetables.jpg"));
        p1.add(l1);
        jf.pack();
        jf.setVisible(false);
        jf.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);//用户点击窗口关闭
    }

    public void show() {
        jf.setVisible(true);
    }
}

//抽象工厂：农场类
interface Farm {
    public Animal newAnimal();

    public Plant newPlant();
}

//具体工厂：韶关农场类
class SGfarm implements Farm {
    public Animal newAnimal() {
        System.out.println("新牛出生！");
        return new Cattle();
    }

    public Plant newPlant() {
        System.out.println("蔬菜长成！");
        return new Vegetables();
    }
}

//具体工厂：上饶农场类
class SRfarm implements Farm {
    public Animal newAnimal() {
        System.out.println("新马出生！");
        return new Horse();
    }

    public Plant newPlant() {
        System.out.println("水果长成！");
        return new Fruitage();
    }
}
```

## 5建造者模式

### 建造者模式的定义与特点：

在软件开发过程中有时需要创建一个复杂的对象，这个复杂对象通常由多个子部件按一定的步骤组合而成。例如，计算机是由 OPU、主板、内存、硬盘、显卡、机箱、显示器、键盘、鼠标等部件组装而成的。生活中这样的例子很多，如游戏中的不同角色，其性别、个性、能力、脸型、体型、服装、发型等特性都有所差异；还有汽车中的方向盘、发动机、车架、轮胎等部件也多种多样；每封电子邮件的发件人、收件人、主题、内容、附件等内容也各不相同。以上所有这些产品都是由多个部件构成的，各个部件可以灵活选择，但其创建步骤都大同小异。

**定义：** 

指将一个复杂对象的构造与它的表示分离，使同样的构建过程可以创建不同的表示，它是将一个复杂的对象分解为多个简单的对象，然后一步一步构建而成。它将变与不变相分离，即产品的组成部分是不变的，但每一部分是可以灵活选择的。

**优点：**

1. 各个具体的建造者相互独立，有利于系统的扩展。
2. 客户端不必知道产品内部组成的细节，便于控制细节风险。

**缺点：**

1. 产品的组成部分必须相同，这限制了其使用范围。

2. 如果产品的内部变化复杂，该模式会增加很多的建造者类。


建造者模式和工厂模式的关注点不同：建造者模式注重零部件的组装过程，而工厂方法模式更注重零部件的创建过程，但两者可以结合使用。

### 建造者模式的结构

建造者（Builder）模式由产品、抽象建造者、具体建造者、指挥者等 4 个要素构成

1. 产品角色（Product）：它是包含多个组成部件的复杂对象，由具体建造者来创建其各个滅部件。
2. 抽象建造者（Builder）：它是一个包含创建产品各个子部件的抽象方法的接口，通常还包含一个返回复杂产品的方法 getResult()。
3. 具体建造者(Concrete Builder）：实现 Builder 接口，完成复杂产品的各个部件的具体创建方法。
4. 指挥者（Director）：它调用建造者对象中的部件构造与装配方法完成复杂对象的创建，在指挥者中不涉及具体产品的信息。

![](https://github.com/pixx1225/Axing-Tech/blob/master/images/Builder.gif)

### 建造者模式的实现

1. 产品角色：包含多个组成部件的复杂对象。

```java
class Product{
    private String partA;
    private String partB;
    private String partC;
    public void setPartA(String partA){
        this.partA=partA;
    }
    public void setPartB(String partB){
        this.partB=partB;
    }
    public void setPartC(String partC){
        this.partC=partC;
    }
    public void show(){
        //显示产品的特性
    }
}
```

2. 抽象建造者：包含创建产品各个子部件的抽象方法。

```java
abstract class Builder{
    //创建产品对象
    protected Product product=new Product();
    public abstract void buildPartA();
    public abstract void buildPartB();
    public abstract void buildPartC();
    //返回产品对象
    public Product getResult(){
        return product;
    }
}
```

3. 具体建造者：实现了抽象建造者接口。

```java
public class ConcreteBuilder extends Builder{
    public void buildPartA(){
        product.setPartA("建造 PartA");
    }
    public void buildPartB(){
        product.setPartA("建造 PartB");
    }
    public void buildPartC(){
        product.setPartA("建造 PartC");
    }
}
```

4. 指挥者：调用建造者中的方法完成复杂对象的创建。

```java
class Director{
    private Builder builder;
    public Director(Builder builder){
        this.builder=builder;
    }
    //产品构建与组装方法
    public Product construct(){
        builder.buildPartA();
        builder.buildPartB();
        builder.buildPartC();
        return builder.getResult();
    }
}
```

5. 客户类

```java
public class Client{
    public static void main(String[] args){
        Builder builder=new ConcreteBuilder();
        Director director=new Director(builder);
        Product product=director.construct();
        product.show();
    }
}
```

### 建造者模式的应用实例

```java
//产品：客厅
class Parlour {
    private String wall;    //墙
    private String TV;      //电视
    private String sofa;    //沙发

    public void setWall(String wall) {
        this.wall = wall;
    }

    public void setTV(String TV) {
        this.TV = TV;
    }

    public void setSofa(String sofa) {
        this.sofa = sofa;
    }

    public void show() {
        String parlour = wall + "，" + TV + "，" + sofa;
        System.out.println("客厅装修有：" + parlour);
    }
}

//抽象建造者：装修工人
abstract class Decorator {
    //创建产品对象
    protected Parlour product = new Parlour();

    public abstract void buildWall();

    public abstract void buildTV();

    public abstract void buildSofa();

    //返回产品对象
    public Parlour getResult() {
        return product;
    }
}

//具体建造者：具体装修工人1
class ConcreteDecorator1 extends Decorator {
    public void buildWall() {
        product.setWall("山水画墙");
    }

    public void buildTV() {
        product.setTV("小米电视");
    }

    public void buildSofa() {
        product.setSofa("织布沙发");
    }
}

//具体建造者：具体装修工人2
class ConcreteDecorator2 extends Decorator {
    public void buildWall() {
        product.setWall("动漫画墙");
    }

    public void buildTV() {
        product.setTV("海信电视");
    }

    public void buildSofa() {
        product.setSofa("皮制沙发");
    }
}

//指挥者：项目经理
class ProjectManager {
    private Decorator builder;

    public ProjectManager(Decorator builder) {
        this.builder = builder;
    }

    //产品构建与组装方法
    public Parlour decorate() {
        builder.buildWall();
        builder.buildTV();
        builder.buildSofa();
        return builder.getResult();
    }
}

public class BuilderClass {
    public static void main(String[] args) {
        Decorator d = new ConcreteDecorator1();
        ProjectManager m = new ProjectManager(d);
        Parlour p = m.decorate();
        p.show();
    }
}

输出：
    客厅装修有：山水画墙，小米电视，织布沙发
```

## 6代理模式

### 代理模式的定义与特点：

在有些情况下，一个客户不能或者不想直接访问另一个对象，这时需要找一个中介帮忙完成某项任务，这个中介就是代理对象。例如，租房需要找个中介。在软件设计中，例如，要访问的远程对象比较大（如视频或大图像等），其下载要花很多时间。还有因为安全原因需要屏蔽客户端直接访问真实对象，如某单位的内部数据库等。

**定义：**

由于某些原因需要给某对象提供一个代理以控制对该对象的访问。这时，访问对象不适合或者不能直接引用目标对象，代理对象作为访问对象和目标对象之间的中介。

**优点：**

- 代理模式在客户端与目标对象之间起到一个中介作用和保护目标对象的作用；
- 代理对象可以扩展目标对象的功能；
- 代理模式能将客户端与目标对象分离，在一定程度上降低了系统的耦合度；

**缺点：**

- 在客户端和目标对象之间增加一个代理对象，会造成请求处理速度变慢；

- 增加了系统的复杂度；

### 代理模式的结构

1. 抽象主题（Subject）类：通过接口或抽象类声明真实主题和代理对象实现的业务方法。
2. 真实主题（Real Subject）类：实现了抽象主题中的具体业务，是代理对象所代表的真实对象，是最终要引用的对象。
3. 代理（Proxy）类：提供了与真实主题相同的接口，其内部含有对真实主题的引用，它可以访问、控制或扩展真实主题的功能。

![](https://github.com/pixx1225/Axing-Tech/blob/master/images/Proxy.gif)

### 代理模式的实现

```java
//抽象主题
interface Subject {
    void Request();
}

//真实主题
class RealSubject implements Subject {
    public void Request() {
        System.out.println("访问真实主题方法...");
    }
}

//代理
class Proxy implements Subject {
    private RealSubject realSubject;

    public void Request() {
        if (realSubject == null) {
            realSubject = new RealSubject();
        }
        preRequest();
        realSubject.Request();
        postRequest();
    }

    public void preRequest() {
        System.out.println("访问真实主题之前的预处理。");
    }

    public void postRequest() {
        System.out.println("访问真实主题之后的后续处理。");
    }
}

public class ProxyClass {
    public static void main(String[] args) {
        Proxy proxy = new Proxy();
        proxy.Request();
    }
}

输出：
    访问真实主题之前的预处理。
    访问真实主题方法...
    访问真实主题之后的后续处理。
```

### 代理模式的应用实例

见以上代码

## 7适配器模式

### 适配器模式的定义与特点：



### 适配器模式的结构

![](https://github.com/pixx1225/Axing-Tech/blob/master/images/Prototype.gif)

### 适配器模式的实现

### 适配器模式的应用实例



## 13原型模式

### 原型模式的定义与特点：

### 原型模式的结构

![](https://github.com/pixx1225/Axing-Tech/blob/master/images/Prototype.gif)

### 原型模式的实现

### 原型模式的应用实例



http://c.biancheng.net/view/1338.html

https://www.runoob.com/design-pattern/design-pattern-tutorial.html