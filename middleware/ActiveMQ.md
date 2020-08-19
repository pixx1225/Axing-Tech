# ActiveMQ

官网：http://activemq.apache.org/

### 定义：

Activemq 是一种消息中间件，作用是系统之间进行通信，对系统之间的调用进行解耦， 实现系统间的异步通信。

大致原理：发送者把消息发送给消息服务器，消息服务器将消息存放在若干队列/主题中，在合适的时候，消息服务器会将消息转发给接受者。在这个过程中，发送和接受是异步的，也就是发送无需等待，而且发送者和接受者的生命周期也没有必然关系；在pub/sub模式下，也可以完成一对多的通信，即让一个消息有多个接受者。

JMS（Java Message Service)，面向消息中间件（MOM：Message Oriented Middleware）

```
Provider/MessageProvider：生产者
Consumer/MessageConsumer：消费者
PTP：Point To Point，点对点通信消息模型
Pub/Sub：Publish/Subscribe，发布订阅消息模型
Queue：队列，目标类型之一，和PTP结合
Topic：主题，目标类型之一，和Pub/Sub结合
ConnectionFactory：连接工厂，JMS用它创建连接
Connnection：JMS Client到JMS Provider的连接
Destination：消息目的地，由Session创建
Session：会话，由Connection创建，实质上就是发送、接受消息的一个线程，因此生产者、消费者都是Session创建的
```

### 通信方式：

- publish-subscribe(发布-订阅方式)
- p2p(点对点方式)



### 如何解决消息不丢失

需要配置持久订阅。 每个订阅端定义一个 id， <property name="`clientId`" 在订阅是向 activemq 注册。 发布消息和接收消息时需要配置发送模式为持久template.setDeliveryMode(DeliveryMode.PERSISTENT)。 此时如果客户端接收不到消息， 消息会持久化到服务端(就是硬盘上)， 直到客户端正常接收后为止。

### 如何解决消息不重复

一般来说我们可以在业务端加一张表记录已经处理过的消息id,判断消息是否执行成功,每次业务事物commit之后,告知服务端,已经处理过该消息,这样即使你消息重发了,也不会导致重复处理



















