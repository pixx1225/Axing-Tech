[TOC]

# Zookeeper

### Zookeeper简介

ZooKeeper是一个分布式的，开放源码的分布式应用程序协调服务，是Hadoop和Hbase的重要组件。它是一个为分布式应用提供一致性服务的软件，分布式应用程序可以基于它实现诸如数据发布/订阅、负载均衡、命名服务、分布式协调/通知、集群管理、Master 选举、分布式锁和分布式队列等功能。

Zookeeper 一个最常用的使用场景就是用于担任服务生产者和服务消费者的注册中心(提供发布订阅服务)，最好使用奇数台服务器构成 ZooKeeper 集群，只要半数以上节点存活，ZooKeeper  就能正常服务

### 会话（Session）

Session 指的是 ZooKeeper  服务器与客户端会话。在 ZooKeeper 中，一个客户端连接是指客户端和服务器之间的一个 TCP 长连接。客户端启动的时候，首先会与服务器建立一个 TCP 连接，从第一次连接建立开始，客户端会话的生命周期也开始了。通过这个连接，客户端能够通过心跳检测与服务器保持有效的会话，也能够向Zookeeper服务器发送请求并接受响应，同时还能够通过该连接接收来自服务器的Watch事件通知。 Session的`sessionTimeout`值用来设置一个客户端会话的超时时间。当由于服务器压力太大、网络故障或是客户端主动断开连接等各种原因导致客户端连接断开时，只要在`sessionTimeout`规定的时间内能够重新连接上集群中任意一台服务器，那么之前创建的会话仍然有效。

在为客户端创建会话之前，服务端首先会为每个客户端都分配一个sessionID。由于 sessionID 是 Zookeeper 会话的一个重要标识，许多与会话相关的运行机制都是基于这个 sessionID 的，因此，无论是哪台服务器为客户端分配的 sessionID，都务必保证全局唯一。

### ZooKeeper 的特点

- **顺序一致性：** 从同一客户端发起的事务请求，最终将会严格地按照顺序被应用到 ZooKeeper 中去。
- **原子性：** 所有事务请求的处理结果在整个集群中所有机器上的应用情况是一致的，也就是说，要么整个集群中所有的机器都成功应用了某一个事务，要么都没有应用。
- **单一系统映像 ：** 无论客户端连到哪一个 ZooKeeper 服务器上，其看到的服务端数据模型都是一致的。
- **可靠性：** 一旦一次更改请求被应用，更改的结果就会被持久化，直到被下一次更改覆盖。

### Zookeeper的数据模型

Zookeeper将所有数据存储在**内存中**，数据模型是一棵树（Znode Tree)，由斜杠（/）的进行分割的路径，就是一个Znode，例如/foo/path1，每一个Znode节点拥有唯一的路径，每个节点上都会保存自己的数据内容，同时还会保存一系列属性信息。

node可以分为**持久节点**和**临时节点**两类。所谓持久节点是指一旦这个ZNode被创建了，除非主动进行ZNode的移除操作，否则这个ZNode将一直保存在Zookeeper上。而临时节点就不一样了，它的生命周期和客户端会话绑定，一旦客户端会话失效，那么这个客户端创建的所有临时节点都会被移除。

 Znode包含了数据，子节点引用，访问权限等** 

![输入图片说明](https://images.gitee.com/uploads/images/2018/1024/114453_e3e16dc6_1478371.png "屏幕截图.png")

 **data：** Znode存储的数据信息。 

 **ACL：** 记录Znode的访问权限，即哪些人或哪些IP可以访问本节点。

 **stat：** 包含Znode的各种元数据，比如事务ID、版本号、时间戳、大小等等。

 **child：** 当前节点的子节点引用，类似于二叉树的左孩子右孩子。

这里需要注意一点，Zookeeper是为读多写少的场景所设计。Znode并不是用来存储大规模业务数据，而是用于存储少量的状态和配置信息，每个节点的数据最大不能超过1MB。



### Zookeeper的基本操作和事件通知

create
创建节点

delete
删除节点

exists
判断节点是否存在

getData
获得一个节点的数据

setData
设置一个节点的数据

getChildren
获取节点下的所有子节点

这其中，exists，getData，getChildren属于读操作。Zookeeper客户端在请求读操作的时候，可以选择是否设置Watch。

### Watch是什么意思呢？
我们可以理解成是注册在特定Znode上的触发器。当这个Znode发生改变，也就是调用了create，delete，setData方法的时候，将会触发Znode上注册的对应事件，请求Watch的客户端会接收到异步通知。

### Zookeeper的一致性
Zookeeper身为分布式系统的协调服务，如果自身挂掉了怎嘛办？为了防止单击挂掉的情况,Zookeeper维护了一个集群

![输入图片说明](https://images.gitee.com/uploads/images/2018/1024/115212_10cf070a_1478371.png "屏幕截图.png")

### Zookeeper Service集群是一主多从结构


在更新数据时，首先更新到主节点（这里的节点是指服务器，不是Znode），再同步到从节点。

在读取数据时，直接读取任意从节点。

为了保证主从节点的数据一致性，Zookeeper采用了ZAB协议，这种协议非常类似于一致性算法Paxos和Raft。

### ZAB是什么？
ZAB即Zookeeper Atomic Broadcast有效解决了Zookeeper 集群崩溃恢复，以及主从同步数据问题

### ZAB协议所定义的三种节点状态：
- Looking ：选举状态。
- Following ：Follower节点（从节点）所处的状态。
- Leading ：Leader节点（主节点）所处状态。

 **最大ZXID的概念：** 
- 最大ZXID也就是节点本地的最新事务编号，包含epoch和计数两部分。epoch是纪元的意思，相当于Raft算法选主时候的term。

 **假如Zookeeper当前的主节点挂掉了，集群会进行崩溃恢复。ZAB的崩溃恢复分成三个阶段：** 

1.Leader election

选举阶段，此时集群中的节点处于Looking状态。它们会各自向其他节点发起投票，投票当中包含自己的服务器ID和最新事务ID（ZXID）。

![输入图片说明](https://images.gitee.com/uploads/images/2018/1024/122915_5504d7ec_1478371.png "屏幕截图.png")

接下来，节点会用自身的ZXID和从其他节点接收到的ZXID做比较，如果发现别人家的ZXID比自己大，也就是数据比自己新，那么就重新发起投票，投票给目前已知最大的ZXID所属节点。

![输入图片说明](https://images.gitee.com/uploads/images/2018/1024/123008_19858577_1478371.png "屏幕截图.png")

每次投票后，服务器都会统计投票数量，判断是否有某个节点得到半数以上的投票。如果存在这样的节点，该节点将会成为准Leader，状态变为Leading。其他节点的状态变为Following。

![输入图片说明](https://images.gitee.com/uploads/images/2018/1024/123038_6f4adc8d_1478371.png "屏幕截图.png")

2.Discovery

发现阶段，用于在从节点中发现最新的ZXID和事务日志。或许有人会问：既然Leader被选为主节点，已经是集群里数据最新的了，为什么还要从节点中寻找最新事务呢？

这是为了防止某些意外情况，比如因网络原因在上一阶段产生多个Leader的情况。

所以这一阶段，Leader集思广益，接收所有Follower发来各自的最新epoch值。Leader从中选出最大的epoch，基于此值加1，生成新的epoch分发给各个Follower。

各个Follower收到全新的epoch后，返回ACK给Leader，带上各自最大的ZXID和历史事务日志。Leader选出最大的ZXID，并更新自身历史日志。

3.Synchronization

同步阶段，把Leader刚才收集得到的最新历史事务日志，同步给集群中所有的Follower。只有当半数Follower同步成功，这个准Leader才能成为正式的Leader。

自此，故障恢复正式完成。

### ZAB是怎嘛实现数据写入的（依靠Broadcast阶段）？

什么是Broadcast呢？简单来说，就是Zookeeper常规情况下更新数据的时候，由Leader广播到所有的Follower。其过程如下：

1.客户端发出写入数据请求给任意Follower。

2.Follower把写入数据请求转发给Leader。

3.Leader采用二阶段提交方式，先发送Propose广播给Follower。

4.Follower接到Propose消息，写入日志成功后，返回ACK消息给Leader。

5.Leader接到半数以上ACK消息，返回成功给客户端，并且广播Commit请求给Follower。

Zab协议既不是强一致性，也不是弱一致性，而是处于两者之间的单调一致性。它依靠事务ID和版本号，保证了数据的更新和读取是有序的。

### Zookeeper的应用
1.分布式锁

这是雅虎研究员设计Zookeeper的初衷。利用Zookeeper的临时顺序节点，可以轻松实现分布式锁。


2.服务注册和发现

利用Znode和Watcher，可以实现分布式服务的注册和发现。最著名的应用就是阿里的分布式RPC框架Dubbo。

3.共享配置和状态信息

Redis的分布式解决方案Codis，就利用了Zookeeper来存放数据路由表和 codis-proxy 节点的元信息。同时 codis-config 发起的命令都会通过 ZooKeeper 同步到各个存活的 codis-proxy。

此外，Kafka、HBase、Hadoop，也都依靠Zookeeper同步节点信息，实现高可用。


#### 参考
- https://mp.weixin.qq.com/s/Gs4rrF8wwRzF6EvyrF_o4A