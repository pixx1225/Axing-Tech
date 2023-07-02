[TOC]

# Java基础

- javac HelloWorld.java
- java HelloWorld
---

## Java集合

![img](https://upload-images.jianshu.io/upload_images/11222983-dafae9a5a3544ff8.png?imageMogr2/auto-orient/strip|imageView2/2/format/webp)

### List

List是有序的Collection。Java List一共三个实现类：分别是ArrayList、Vector和LinkedList。

#### ArrayList

底层的数据结构是基于动态数组。适合查找。默认容量为10。扩容按照1.5倍+1增长。

#### Vector

Vector与ArrayList一样，也是通过数组实现的，不同的是它支持线程的同步，即某一时刻只有一个线程能够写Vector，避免多线程同时写而引起的不一致性，但实现同步需要很高的花费，因此，访问它比访问ArrayList慢。

#### LinkedList

底层的数据结构是基于双向循环链表。适合增删。比ArrayList更占内存

### Set

用于存储无序元素，值不能重复。

HashSet，TreeSet，LinkHashSet

### HashMap  

底层是 数组+单链表+红黑树

键值对（key-value)  ，不同步，非线程安全，允许键值都为null，映射无序，快速失败

数组容量（capacity）：默认16，加载因子（loadfactor)：默认0.75，阀值就是12

扩容阈值（threshold) ：元素个数大于capacity*loadfactor， 扩容2n，

进行rehash是非常耗资源的(O(N))，jdk1.8 链表长度大于8时转换为**红黑树**(O(logN)）

```java
# HashMap遍历
Iterator<Map.Entry<String, Integer>> entryIterator = map.entrySet().iterator();
while (entryIterator.hasNext()) {
    Map.Entry<String, Integer> entryNext = entryIterator.next();
    System.out.println("key=" + entryNext.getKey() + " value=" + entryNext.getValue());
}
```

**HashMap为什么不是线程安全：**

HashMap 底层是一个 Entry 数组，当发生 hash 冲突的时候，HashMap 是采用链表的方式来解决的，在对应的数组位置存放链表的头结点。对链表而言，新加入的节点会从头结点加入。

1. HashMap 在put插入的时候

　　现在假如 A 线程和 B 线程同时进行插入操作，然后计算出了相同的哈希值对应了相同的数组位置，因为此时该位置还没数据，然后对同一个数组位置，两个线程会同时得到现在的头结点，然后 A 写入新的头结点之后，B 也写入新的头结点，那B的写入操作就会覆盖 A 的写入操作造成 A 的写入操作丢失。

2. HashMap 在扩容的时候

　　HashMap 有个扩容的操作，这个操作会新生成一个新的容量的数组，然后对原数组的所有键值对重新进行计算和写入新的数组，之后指向新生成的数组。当多个线程同时进来，检测到总数量超过门限值的时候就会同时调用 resize 操作，各自生成新的数组并 rehash 后赋给该 map 底层的数组，结果最终只有最后一个线程生成的新数组被赋给该 map 底层，其他线程的均会丢失。

3. HashMap 在删除数据的时候

　　删除这一块可能会出现两种线程安全问题，第一种是一个线程判断得到了指定的数组位置i并进入了循环，此时，另一个线程也在同样的位置已经删掉了i位置的那个数据了，然后第一个线程那边就没了。但是删除的话，没了倒问题不大。再看另一种情况，当多个线程同时操作同一个数组位置的时候，也都会先取得现在状态下该位置存储的头结点，然后各自去进行计算操作，之后再把结果写会到该数组位置去，其实写回的时候可能其他的线程已经就把这个位置给修改过了，就会覆盖其他线程的修改。

**哪些方法使HashMap线程安全：**

- 重新改写了HashMap
- Hashtable（synchronized所有线程竞争同一把锁，效率低）
- ConcurrentHashMap（使用锁分段技术，Java8中使用CAS算法）
- Synchronized Map（返回一个新的Map, synchronized同步关键字来保证对Map的操作是安全)

### ConcurrentHashMap 

线程安全，支持16个线程并发操作，

JDK1.7，分段锁技术，

- 分段锁`Segment`的设计，把一个大的Map拆分成N个小的HashTable
- Segment继承`ReentrantLock`,每个Segment都有一把锁，保证线程安全。

理论上 ConcurrentHashMap 支持 CurrencyLevel (Segment 数组数量，默认16)的线程并发。每当一个线程占用锁访问一个 Segment 时，不会影响到其他的 Segment。非阻塞，效率高。

JDK1.8，`CAS`+`synchronized`来保证并发安全。存放数据的 HashEntry 改为 Node， next 都用了 volatile 修饰，保证了可见性。

put操作

```
根据 key 计算出 hashcode 。
判断是否需要进行初始化。
f 即为当前 key 定位出的 Node，如果为空表示当前位置可以写入数据，利用 CAS 尝试写入，失败则自旋保证成功。
如果当前位置的 hashcode == MOVED == -1,则需要进行扩容。
如果都不满足，则利用 synchronized 锁写入数据。
如果数量大于 TREEIFY_THRESHOLD 则要转换为红黑树。
```

### HashTable

线程安全，key和value不允许null。HashTable中hash数组默认大小是11扩容2n+1。任何操作都会把整个表锁住，阻塞，效率低。

### TreeMap 

继承自SortedMap接口，非线程安全，基于红黑树实现，适用于顺序遍历键

### LinkHashMap

LinkedHashMap是HashMap的一个子类，保存了记录的插入顺序

## 封装，继承，多态

**封装**隐藏了类的内部实现机制，可以在不影响使用的情况下改变类的内部结构，同时也保护了数据。对外界而已它的内部细节是隐藏的，暴露给外界的只是它的访问方法。

**继承**是为了重用父类代码。同时继承也为实现多态做了铺垫。

**多态**就是指一个引用变量在不同的情况下的多种状态。多态是指通过指向父类的指针，来调用在不同子类中实现的方法。三要素：继承，重写，父类引用指向子类对象

- 如果b类继承自a类，在main方法中new出b的对象(不带参数)，那么他执行的顺序是：父类a的静态方法-->子类b的静态方法-->父类a的非静态方法-->父类a的无参构造-->子类b的非静态方法-->子类b的无参构造方法
- 在父类无参构造里面调用了父类的XX方法 且子类重写了父类的XX方法，那么不会调用父类的XX，优先调用子类的XX方法，但是仍然可以在子类的XX方法里面使用super调用父类的XX方法。

## 接口和抽象类的区别

**从设计层面来说，抽象是对类的抽象，是一种模板设计，可以实现代码重用，接口是行为的抽象，是一种行为的规范。**

**接口** （Interface修饰）所有的方法在接口中不能有实现（所有方法都是抽象的）。接口无法被实例化。一个类只能继承一个类，但是可以实现多个接口。一个类实现接口的话要实现接口中的所有方法。成员变量默认是public static final有初始值，成员方法默认是public abstract，

**抽象类**（abstract修饰）可包含抽象和非抽象的方法，含有抽象方法的类必是抽象类。抽象类不能实例化，抽象类中的抽象方法只有方法体，没有具体实现。如果子类没有实现抽象父类的所有抽象方法，那么子类也必须定义为抽象类。抽象方法可以是public，protected或者是private，变量是friendly的可以在子类中重新定义。

如果你拥有一些方法并且想让它们中的一些有默认实现，那么使用抽象类

如果你想实现多重继承，那么你必须使用接口

如果基本功能在不断改变，那么就需要使用抽象类

## 重写和重载的区别

**Override**(重写）父类与子类之间多态性的一种表现。对接口方法的实现中经常出现。方法名，参数，返回值，异常都一致，方法被定义为final不能被重写。

**Overload**(重载)  是一个类中多态性的一种表现。方法名必须相同，参数列表不同（类型，个数，顺序）

## final，finally，finalize的区别

**final** 被final修饰的类，就意味着不能再派生出新的子类，变量或方法声明为final，可以保证他们在使用的过程中不被修改，只能读取使用。被声明为final的变量必须在声明时给出变量的初始值，final声明的方法不能重写。

**finally** 是在异常处理时提供finally块来执行任何清除操作。不管有没有异常被抛出、捕获，finally块都会被执行。

**finalize** 是方法名，在垃圾收集器将对象从内存中清除出去之前做必要的清理工作。

## String、StringBuffer、StringBuilder的区别

在执行速度上：Stringbuilder->Stringbuffer->String

**String**：不可变，即字符串常量。操作少量的数据

**StringBuffer**：可变，效率低，线程安全，会在append等方法上加synchronized关键字，进行同步。多线程操作字符串缓冲区下操作大量数据

**StringBuilder**：可变，效率高，线程不安全。单线程操作字符串缓冲区下操作大量数据

+号拼接的原理是会在底层new一个StringBuilder，例如：str = str + “a”具体就是new StringBuilder().append(str).append("a"); 影响效率。

```java
Object类
  | --> String类
  | --> AbstractStringBuilder类
               | --> StringBuffer类
               | --> StringBuilder类
```



## ==和equals的区别

1）对于 **= =**，如果作用于基本数据类型的变量，则直接比较其存储的**值**是否相等；如果作用于引用类型的变量，则比较的是所指向的**对象的地址**。

2）对于**equals**方法，注意：equals方法不能作用于基本数据类型的变量；

如果没有对equals重写，则比较的是引用类型的变量所指向的**对象的地址**；

诸如String、Date等类进行了重写的话，比较的是所指向的对**象的内容**。

对于**字符串**，==比较两个对象的内存地址，equals比较字符串内容。

## 装箱和拆箱的区别

Java为每种基本数据类型都提供了对应的包装器类型，

装箱就是自动将基本数据类型转换为包装器类型；拆箱就是自动将包装器类型转换为基本数据类型。

## 对象序列化和反序列化

> - 对象序列化：将对象以二进制的形式保存在硬盘上；
> - 反序列化：将二进制的文件转化为对象读取；
> - 实现 serializable 接口可以实现对象序列化，其中没有需要实现的方法，implements Serializable 只是为了标注该对象是可被序列化的。

## **反射机制**

反射机制就是动态加载对象，并对对象进行剖析。允许程序在执行期借助于Reflection API取得任何类的內部信息，并能直接操作任意对象的内部属性及方法。这种动态获取信息以及动态调用对象方法的功能成为Java反射机制。

反射就是把java类中的各种成分映射成一个个的Java对象

## **动态代理**

动态代理是指代理类是在JVM运行时动态生成的。效率比静态代理要低，但提高了代码的简洁度和开发工作。

SpringAOP动态代理主要两种实现：JDK动态代理和CGlib动态代理，JDK动态代理是基于Java反射功能来实现的，而CGlib动态代理借助于ASM字节码生成工具来生成代理类。

## **Java创建对象的几种方式**

(1) 用new语句创建对象，这是最常见的创建对象的方法。

(2) 运用反射手段,调用java.lang.Class或者java.lang.reflect.Constructor类的newInstance()实例方法。

(3) 调用对象的clone()方法。

(4) 运用反序列化手段，调用java.io.ObjectInputStream对象的 readObject()方法。

