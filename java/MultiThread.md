[TOC]

# 多线程

## 基本概念
### 进程和线程的区别：
- 进程是系统进行资源分配和调度的基本单位
- 线程是程序执行的最小单位
- 一个程序至少有一个进程，一个进程至少有一个线程
- 每个进程有独立的代码和数据空间，进程切换开销大
- 同类线程共享代码和数据空间，有独立运行栈和程序计数器，切换开销小
- 进程间不会相互影响；一个线程挂掉会导致整个进程挂掉。

### 死锁的四个必要条件：
1. 互斥条件 2. 请求和保持条件 3. 不剥夺条件 4. 循环等待条件

### [进程间通信方式（IPC）](https://www.cnblogs.com/LUO77/p/5816326.html)：
1. 管道pipe 半双工
2. 命名管道FIFO
3. 消息队列message queue
4. 信号量semophore PV操作
5. 共享内存shared memory
6. 套接字socket
7. 信号sinal

### 线程间通信方式：
wait()、notify()和notifyAll()。调用wait()方法可以使调用该方法的线程释放共享资源的锁，然后从运行态退出，进入等待队列，直到被再次唤醒。而调用notify()方法可以唤醒等待队列中第一个等待同一共享资源的线程，并使该线程退出等待队列，进入可运行态。调用notifyAll()方法可以使所有正在等待队列中等待同一共享资源的线程从等待状态退出，进入可运行状态，此时，优先级最高的那个线程最先执行。

### 创建线程的三种方式：
1. 继承Thread类
2. 实现Runable接口(推荐)
3. 使用Executor框架创建线程池
4. 通过Callable接口并实现call()方法，该call()方法将作为线程执行体，并且有返回值

### 线程同步的方式：
1. 同步方法，使用synchronized关键字修饰方法
2. 同步代码块，使用synchronized关键字修饰代码块
3. 使用特殊域变量volatile实现线程同步
4. 使用重入锁实现线程同步，ReentrantLock创建实例，lock()获得锁，unlock()释放锁
5. 使用局部变量实现线程同步，ThreadLocal() : 创建一个线程本地变量
6. 使用阻塞队列实现线程同步，BlockingQueue<E>定义了阻塞队列的常用方法，add(),offer(),put()
7. 使用原子变量实现线程同步

### 守护线程和非守护线程

只要当前JVM实例中尚存在任何一个非守护线程没有结束，守护线程就全部工作；只有当最后一个非守护线程结束时，守护线程随着JVM一同结束工作。

**守护线程最典型的应用就是 GC (垃圾回收器)**

**守护线程和用户线程**的区别在于：守护线程依赖于创建它的线程，而用户线程则不依赖。举个简单的例子：如果在main线程中创建了一个守护线程，当main方法运行完毕之后，守护线程也会随着消亡。而用户线程则不会，用户线程会一直运行直到其运行完毕。在JVM中，像垃圾收集器线程就是守护线程。

# 线程安全

## 原子性、可见性、有序性

**java内存模型（JMM）**

- Java虚拟机规范试图定义一种Java内存模型（JMM）,来屏蔽掉各种硬件和操作系统的内存访问差异，让Java程序在各种平台上都能达到一致的内存访问效果。
- 简单来说，由于CPU执行指令的速度是很快的，但是内存访问的速度就慢了很多，相差的不是一个数量级，所以搞处理器的那群大佬们又在CPU里加了好几层高速缓存。
- 在Java内存模型里，对上述的优化又进行了一波抽象。JMM规定所有变量都是存在主存中的，类似于上面提到的普通内存，每个线程又包含自己的工作内存，方便理解就可以看成CPU上的寄存器或者高速缓存。所以线程的操作都是以工作内存为主，它们只能访问自己的工作内存，且工作前后都要把值在同步回主内存。

![](https://github.com/pixx1225/Axing-Tech/blob/master/images/内存模型流程图.png)

在线程执行时，首先会从主存中read变量值，再load到工作内存中的副本中，然后再传给处理器执行，执行完毕后再给工作内存中的副本赋值，随后工作内存再把值传回给主存，主存中的值才更新。【例】 i = i + 1;

假设i初值为0，当只有一个线程执行它时，结果肯定得到1，当两个线程执行时，会得到结果2吗？这倒不一定了。可能存在这种情况：

```java
线程1： load i from 主存  // i = 0
       i + 1            // i = 1
线程1： load i from 主存  // 因为线程1还没有将i写回主存，所以i还是=0
       i + 1            // i = 1
线程1： save i to 主存
线程2： save i to 主存
```

如果两个线程按照上面的执行流程，那么i最后的值还是1。如果最后的写回生效的慢，你再读取i的值，都可能是0，这就是缓存不一致问题。

## Synchronize

- 同步普通方法，锁的是当前对象。
- 同步静态方法，锁的是当前 `Class` 对象。
- 同步块，锁的是 `{}` 中的对象。

### 实现原理：

`JVM` 是通过进入、退出对象监视器( `Monitor` )来实现对方法、同步块的同步的。其本质就是对一个对象监视器( `Monitor` )进行获取，而这个获取过程具有排他性从而达到了同一时刻只能一个线程访问的目的。

![Monitor流程图](https://github.com/pixx1225/Axing-Tech/blob/master/images/Monitor流程图.jpeg)

## Volatile

###  特性：

- 1 . 保证了不同线程对该变量操作的**内存可见性**;
- 2 . 禁止指令**重排序**

如果一个变量声明成是volatile的，那么当读变量时，总是能读到它的最新值，这里最新值是指不管其它哪个线程对该变量做了写操作，都会立刻被更新到主存里，我们也能从主存里读到这个刚写入的值。也就是说volatile关键字可以保证可见性以及有序性。**不保证原子性**

- 当写一个volatile变量时，JMM会把该线程对应的本地内存中的共享变量刷新到主内存
- 当读一个volatile变量时，JMM会把该线程对应的本地内存置为无效，线程接下来将从主内存中读取共享变量。

### 实现机制：

如果把加入volatile关键字的代码和未加入volatile关键字的代码都生成汇编代码，会发现加入volatile关键字的代码会多出一个lock前缀指令。

 **lock前缀指令实际相当于一个内存屏障，内存屏障提供了以下功能：** 

- 1   重排序时不能把后面的指令重排序到内存屏障之前的位置
- 2 . 使得本CPU的Cache写入内存
- 3 . 写入动作也会引起别的CPU或者别的内核无效化其Cache，相当于让新写入的值对别的线程可见。



CAS (compare and swap) 比较并交换，就是将内存值与预期值进行比较，如果相等才将新值替换到内存中，并返回true表示操作成功；如果不相等，则直接返回false表示操作失败。

## ThreadLocal 

提供了线程本地的实例。它与普通变量的区别在于，每个使用该变量的线程都会初始化一个完全独立的实例副本。ThreadLocal 变量通常被private static修饰。当一个线程结束时，它所使用的所有 ThreadLocal 相对的实例副本都可被回收。总的来说，ThreadLocal 适用于每个线程需要自己独立的实例且该实例需要在多个方法中被使用，也即变量在线程间隔离而在方法或类间共享的场景。

## 线程池

### 原理：
1. 线程池判断核心线程池里的线程是否都在执行任务。如果不是，则创建一个新的工作线程来执行任务。如果核心线程池里的线程都在执行任务，则执行第二步。 
2. 线程池判断工作队列是否已经满。如果工作队列没有满，则将新提交的任务存储在这个工作队列里进行等待。如果工作队列满了，则执行第三步。
3. 线程池判断线程池的线程是否都处于工作状态。如果没有，则创建一个新的工作线程来执行任务。如果已经满了，则交给饱和策略来处理这个任务。

### 优点：
1. 降低资源消耗 
可以重复利用已创建的线程降低线程创建和销毁造成的消耗。 
2. 提高响应速度 
当任务到达时，任务可以不需要等到线程创建就能立即执行。 
3. 提高线程的可管理性 
线程是稀缺资源，如果无限制地创建，不仅会消耗系统资源，还会降低系统的稳定性，使用线程池可以进行统一分配、调优和监控
线程分为守护线程和非守护线程（即用户线程）。守护线程最典型的应用就是 GC (垃圾回收器)

### 4种常用线程池：
1. Executors.newCacheThreadPool()可缓存线程池：先查看池中有没有以前建立的线程，如果有，就直接使用。如果没有，就建一个新的线程加入池中，缓存型池子通常用于执行一些生存期很短的异步型任务。
2. Executors.newFixedThreadPool(int n)：创建一个可重用固定个数的线程池，以共享的无界队列方式来运行这些线程。
3.  Executors.newScheduledThreadPool(int n)：创建一个定长线程池，支持定时及周期性任务执行
4.  Executors.newSingleThreadExecutor()：创建一个单线程化的线程池，它只会用唯一的工作线程来执行任务，保证所有任务按照指定顺序(FIFO, LIFO, 优先级)执行。

### 线程池的使用

```java
    private static final int CORE_POOL_SIZE = 5;
    private static final int MAX_POOL_SIZE = 10;
    private static final int QUEUE_CAPACITY = 100;
    private static final Long KEEP_ALIVE_TIME = 1L;

    public static void main(String[] args) {

        //使用阿里巴巴推荐的创建线程池的方式
        //通过ThreadPoolExecutor构造函数自定义参数创建
        ThreadPoolExecutor executor = new ThreadPoolExecutor(
                CORE_POOL_SIZE,
                MAX_POOL_SIZE,
                KEEP_ALIVE_TIME,
                TimeUnit.SECONDS,
                new ArrayBlockingQueue<>(QUEUE_CAPACITY),
                new ThreadPoolExecutor.CallerRunsPolicy());

        for (int i = 0; i < 10; i++) {
            executor.execute(() -> {
                try {
                    Thread.sleep(2000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                System.out.println("CurrentThread name:" + Thread.currentThread().getName() + "date：" + Instant.now());
            });
        }
        //终止线程池
        executor.shutdown();
        try {
            executor.awaitTermination(5, TimeUnit.SECONDS);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("Finished all threads");
    }
```

**1. 使用 `ThreadPoolExecutor `的构造函数声明线程池**

​	线程池必须手动通过 ThreadPoolExecutor的构造函数来声明，避免使用Executors类的 newFixedThreadPool 和 newCachedThreadPool ，因为可能会有 OOM 的风险。说白了就是：使用有界队列，控制线程创建数量。

**2.监测线程池运行状态**

`printThreadPoolStatus()`会每隔一秒打印出线程池的线程数、活跃线程数、完成的任务数、以及队列中的任务数。

```java
/**
     * 打印线程池的状态
     * @param threadPool 线程池对象
     */
public static void printThreadPoolStatus(ThreadPoolExecutor threadPool) {
        ScheduledExecutorService scheduledExecutorService = new ScheduledThreadPoolExecutor(1, createThreadFactory("print-thread-pool-status", false));
        scheduledExecutorService.scheduleAtFixedRate(() -> {
            log.info("=========================");
            log.info("ThreadPool Size: [{}]", threadPool.getPoolSize());
            log.info("Active Threads: {}", threadPool.getActiveCount());
            log.info("Number of Tasks : {}", threadPool.getCompletedTaskCount());
            log.info("Number of Tasks in Queue: {}", threadPool.getQueue().size());
            log.info("=========================");
        }, 0, 1, TimeUnit.SECONDS);
    }
```

**3.建议不同类别的业务用不同的线程池**

**4.别忘记给线程池命名**

初始化线程池的时候需要显示命名（设置线程池名称前缀），有利于定位问题。

默认情况下创建的线程名字类似 pool-1-thread-n 这样的，没有业务含义，不利于我们定位问题。

给线程池里的线程命名通常有下面两种方式：

1.利用 guava 的 `ThreadFactoryBuilder` 

```java
ThreadFactory threadFactory = new ThreadFactoryBuilder()
                        .setNameFormat(threadNamePrefix + "-%d")
                        .setDaemon(true).build();
ExecutorService threadPool = new ThreadPoolExecutor(corePoolSize, maximumPoolSize, keepAliveTime, TimeUnit.MINUTES, workQueue, threadFactory);
```

2.自己实现`ThreadFactor`

```java
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.atomic.AtomicInteger;
/**
 * 线程工厂，它设置线程名称，有利于我们定位问题。
 */
public final class NamingThreadFactory implements ThreadFactory {

    private final AtomicInteger threadNum = new AtomicInteger();
    private final ThreadFactory delegate;
    private final String name;

    /**
     * 创建一个带名字的线程池生产工厂
     */
    public NamingThreadFactory(ThreadFactory delegate, String name) {
        this.delegate = delegate;
        this.name = name; // TODO consider uniquifying this
    }

    @Override 
    public Thread newThread(Runnable r) {
        Thread t = delegate.newThread(r);
        t.setName(name + " [#" + threadNum.incrementAndGet() + "]");
        return t;
    }

}
```

**5.正确配置线程池参数**

美团的`ResizableCapacityLinkedBlockIngQueue`

# JDK并发容器

JDK 提供的这些容器大部分在 `java.util.concurrent` 包中。

- **ConcurrentHashMap:** 线程安全的 HashMap
- **CopyOnWriteArrayList:** 线程安全的 List，在读多写少的场合性能非常好，远远好于 Vector.
- **ConcurrentLinkedQueue:** 高效的并发队列，使用链表实现。可以看做一个线程安全的 LinkedList，这是一个非阻塞队列。
- **BlockingQueue:** 这是一个接口，JDK 内部通过链表、数组等方式实现了这个接口。表示阻塞队列，非常适合用于作为数据共享的通道。
- **ConcurrentSkipListMap:** 跳表的实现。这是一个 Map，使用跳表的数据结构进行快速查找。

## ConcurrentHashMap

我们知道 HashMap 不是线程安全的，在并发场景下如果要保证一种可行的方式是使用 `Collections.synchronizedMap()` 方法来包装我们的 HashMap。但这是通过使用一个全局的锁来同步不同线程间的并发访问，因此会带来不可忽视的性能问题。由于 `HashMap` 是一个线程不安全的容器，主要体现在容量大于`总量*负载因子`发生扩容时会出现环形链表从而导致死循环。因此需要支持线程安全的并发容器 `ConcurrentHashMap` 。和 `HashMap` 一样，ConcurrentHashMap仍然是数组加链表组成。由 `Segment` 数组、`HashEntry` 数组组成，

`ConcurrentHashMap` 采用了分段锁技术，其中 `Segment` 继承于 `ReentrantLock`。不会像 `HashTable` 那样不管是 `put` 还是 `get` 操作都需要做同步处理，理论上 ConcurrentHashMap 支持 `CurrencyLevel` (Segment 数组数量)的线程并发。每当一个线程占用锁访问一个 `Segment` 时，不会影响到其他的 `Segment`。

**get方法**  整个过程都不需要加锁，只需要将 `Key` 通过 `Hash` 之后定位到具体的 `Segment` ，再通过一次 `Hash` 定位到具体的元素上。由于 `HashEntry` 中的 `value` 属性是用 `volatile` 关键词修饰的，保证了内存可见性，所以每次获取时都是最新值。

**put 方法**  首先也是通过 Key 的 Hash 定位到具体的 Segment，在 put 之前会进行一次扩容校验。这里比 HashMap 要好的一点是：HashMap 是插入元素之后再看是否需要扩容，有可能扩容之后后续就没有插入就浪费了本次扩容(扩容非常消耗性能)。而 ConcurrentHashMap 不一样，它是先将数据插入之前检查是否需要扩容，之后再做插入。 HashEntry 中的 value 是用 `volatile` 关键词修饰的，但是并不能保证并发的原子性，所以 put 操作时仍然需要加锁处理。

**size方法**  每个 `Segment` 都有一个 `volatile` 修饰的全局变量 `count` ,求整个 `ConcurrentHashMap` 的 `size` 时很明显就是将所有的 `count` 累加即可。但是 `volatile` 修饰的变量却不能保证多线程的原子性，所有直接累加很容易出现并发问题。

但如果每次调用 `size` 方法将其余的修改操作加锁效率也很低。所以做法是先尝试两次将 `count` 累加，如果容器的 `count` 发生了变化再加锁来统计 `size`。

至于 `ConcurrentHashMap` 是如何知道在统计时大小发生了变化呢，每个 `Segment` 都有一个 `modCount` 变量，每当进行一次 `put remove` 等操作，`modCount` 将会 +1。只要 `modCount` 发生了变化就认为容器的大小也在发生变化。

- [ConcurrentHashMap 和 Hashtable 的区别](https://github.com/Snailclimb/JavaGuide/blob/master/docs/java/collection/Java集合框架常见面试题.md#concurrenthashmap-和-hashtable-的区别)
- [ConcurrentHashMap 线程安全的具体实现方式/底层具体实现](https://github.com/Snailclimb/JavaGuide/blob/master/docs/java/collection/Java集合框架常见面试题.md#concurrenthashmap线程安全的具体实现方式底层具体实现)

## CopyOnWriteArrayList

## ConcurrentLinkedQueue

Java 提供的线程安全的 Queue 可以分为**阻塞队列**和**非阻塞队列**，其中阻塞队列的典型例子是 BlockingQueue，非阻塞队列的典型例子是 ConcurrentLinkedQueue，在实际应用中要根据实际需要选用阻塞队列或者非阻塞队列。 **阻塞队列可以通过加锁来实现，非阻塞队列可以通过 CAS 操作实现。**

从名字可以看出，`ConcurrentLinkedQueue`这个队列使用链表作为其数据结构．ConcurrentLinkedQueue 应该算是在高并发环境中性能最好的队列了。它之所有能有很好的性能，是因为其内部复杂的实现。

 ConcurrentLinkedQueue 主要使用 CAS 非阻塞算法来实现线程安全。

ConcurrentLinkedQueue 适合在对性能要求相对较高，同时对队列的读写存在多个线程同时进行的场景，即如果对队列加锁的成本较高则适合使用无锁的 ConcurrentLinkedQueue 来替代。

## BlockingQueue

阻塞队列（BlockingQueue）被广泛使用在“生产者-消费者”问题中，其原因是 BlockingQueue 提供了可阻塞的插入和移除的方法。当队列容器已满，生产者线程会被阻塞，直到队列未满；当队列容器为空时，消费者线程会被阻塞，直至队列非空时为止。

BlockingQueue 是一个接口，继承自 Queue，所以其实现类也可以作为 Queue 的实现来使用，而 Queue 又继承自 Collection 接口。

**ArrayBlockingQueue、LinkedBlockingQueue、PriorityBlockingQueue，这三个 BlockingQueue 的实现类。**

- **ArrayBlockingQueue**

**ArrayBlockingQueue** 是 BlockingQueue 接口的有界队列实现类，底层采用**数组**来实现。ArrayBlockingQueue 一旦创建，容量不能改变。其并发控制采用可重入锁来控制，不管是插入操作还是读取操作，都需要获取到锁才能进行操作。当队列容量满时，尝试将元素放入队列将导致操作阻塞;尝试从一个空队列中取一个元素也会同样阻塞。

ArrayBlockingQueue 默认情况下不能保证线程访问队列的公平性，所谓公平性是指严格按照线程等待的绝对时间顺序，即最先等待的线程能够最先访问到 ArrayBlockingQueue。而非公平性则是指访问 ArrayBlockingQueue 的顺序不是遵守严格的时间顺序，有可能存在，当 ArrayBlockingQueue 可以被访问时，长时间阻塞的线程依然无法访问到 ArrayBlockingQueue。如果保证公平性，通常会降低吞吐量。如果需要获得公平性的 ArrayBlockingQueue，可采用如下代码：

```
private static ArrayBlockingQueue<Integer> blockingQueue = new ArrayBlockingQueue<Integer>(10,true);
```

- **LinkedBlockingQueue**

**LinkedBlockingQueue** 底层基于**单向链表**实现的阻塞队列，可以当做无界队列也可以当做有界队列来使用，同样满足 FIFO 的特性，与 ArrayBlockingQueue 相比起来具有更高的吞吐量，为了防止 LinkedBlockingQueue 容量迅速增，损耗大量内存。通常在创建 LinkedBlockingQueue 对象时，会指定其大小，如果未指定，容量等于 Integer.MAX_VALUE。

- **PriorityBlockingQueue**

**PriorityBlockingQueue** 是一个支持优先级的无界阻塞队列。默认情况下元素采用自然顺序进行排序，也可以通过自定义类实现 `compareTo()` 方法来指定元素排序规则，或者初始化时通过构造器参数 `Comparator` 来指定排序规则。

PriorityBlockingQueue 并发控制采用的是 **ReentrantLock**，队列为无界队列（ArrayBlockingQueue 是有界队列，LinkedBlockingQueue 也可以通过在构造函数中传入 capacity 指定队列最大的容量，但是 PriorityBlockingQueue 只能指定初始的队列大小，后面插入元素的时候，**如果空间不够的话会自动扩容**）。

简单地说，它就是 PriorityQueue 的线程安全版本。不可以插入 null 值，同时，插入队列的对象必须是可比较大小的（comparable），否则报 ClassCastException 异常。它的插入操作 put 方法不会 block，因为它是无界队列（take 方法在队列为空的时候会阻塞）。

[《解读 Java 并发队列 BlockingQueue》](https://javadoop.com/post/java-concurrent-queue)



## ConcurrentSkipListMap

对于一个单链表，即使链表是有序的，如果我们想要在其中查找某个数据，也只能从头到尾遍历链表，这样效率自然就会很低，跳表就不一样了。跳表是一种可以用来快速查找的数据结构，有点类似于平衡树。它们都可以对元素进行快速的查找。但一个重要的区别是：对平衡树的插入和删除往往很可能导致平衡树进行一次全局的调整。而对跳表的插入和删除只需要对整个数据结构的局部进行操作即可。这样带来的好处是：在高并发的情况下，你会需要一个全局锁来保证整个平衡树的线程安全。而对于跳表，你只需要部分锁即可。这样，在高并发环境下，你就可以拥有更好的性能。而就查询的性能而言，跳表的时间复杂度也是 **O(logn)** 所以在并发数据结构中，JDK 使用跳表来实现一个 Map。

跳表的本质是同时维护了多个链表，并且链表是分层的，最低层的链表维护了跳表内所有的元素，每上面一层链表都是下面一层的子集。跳表内的所有链表的元素都是排序的。查找时，可以从顶级链表开始找。一旦发现被查找的元素大于当前链表中的取值，就会转入下一层链表继续找。这也就是说在查找过程中，搜索是跳跃式的。

**跳表是一种利用空间换时间的算法。**

使用跳表实现 Map 和使用哈希算法实现 Map 的另外一个不同之处是：哈希并不会保存元素的顺序，而跳表内所有的元素都是排序的。因此在对跳表进行遍历时，你会得到一个有序的结果。所以，如果你的应用需要有序性，那么跳表就是你不二的选择。JDK 中实现这一数据结构的类是 ConcurrentSkipListMap。

# AQS

AbstractQueuedSynchronizer,简称AQS。AQS是一个用来构建锁和同步器的框架。ReentrangLock、Semaphore用到这个共同的基类

**AQS的基本实现原理**

AQS使用一个int成员变量来表示同步状态，通过内置的FIFO队列来完成获取资源线程的排队工作。

```
  private volatile int state;//共享变量，使用volatile修饰保证线程可见性
```

状态信息通过procted类型的getState，setState，compareAndSetState进行操作









# CAS

- CAS（Compare and Swap），即比较并替换，实现并发算法时常用到的一种技术，Doug lea大神在java同步器中大量使用了CAS技术，鬼斧神工的实现了多线程执行的安全性。
- CAS的思想很简单：三个参数，一个当前内存值V、旧的预期值A、即将更新的值B，当且仅当预期值A和内存值V相同时，将内存值修改为B并返回true，否则什么都不做，并返回false。













