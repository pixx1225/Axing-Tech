[TOC]

# Redis

参考书籍：《Redis设计与实现》

key-value非关系数据库，内存数据库，单线程模型。

## 基本数据类型

**字符串**`String`、**哈希**`Hash`、**列表**`List`、**集合**`Set`、**有序集合**`SortedSet`。

## 持久化

两种持久化方式：`RDB`和`AOF`。RedisDataBase, AppendOnlyFile

* RDB持久化方式定时将数据快照写入磁盘。这种方式并不是非常可靠，因为可能丢失数据，但非常快速。 
* AOF持久化方式更加可靠，将服务端收到的每个写操作都写入磁盘。在服务器重启时，这些写操作被重新执行来重新构建数据集

## 数据结构

简单动态字符串（sds, simple dynamic string）、字典（hashtable）、整数集合（intset）、双向链表（linkedlist）、跳跃表（skiplist）、压缩列表（ziplist）

Redis并没有直接使用这些数据结构来实现键值对数据库，而是基于这些数据结构创建了一个**对象系统**，每个键值对的键和值都是一个对象，这个系统包含五种数据类型的对象，每种类型的对象至少有两种或以上的编码方式。

除此之外，Redis的对象系统还实现了**基于引用计数技术的内存回收机制**，当程序不再使用某个对象的时候，这个对象所占用的内存就会被释放；另外，Redis还**通过引用计数技术实现了对象共享机制**，让多个数据库键共享同一个值对象来节约内存。最后，**对象带有访问时间记录信息用于计算数据库键的空转时长**，在服务器启用了maxmemory功能情况下，空转时长较大的那些键可能优先被服务器删除。

Redis中的每个对象都由一个redisObject结构表示

```c
typedef struct redisObject {
	//类型
	unsigned type:4;
	//编码
	unsigned encoding:4;
	//指向底层数据结构的指针
	void *ptr;
    //引用计数
    int refcount;
    //记录最后一次被命令程序访问的时间-空转时长
    unsigned lru:22;
}robj;
```

Redis只对包含整数值的字符串对象进行共享，不共享包含字符串值的字符串对象。

Redis会共享值为0到9999的字符串对象。

## String（字符串）类型

* string类型是最基本的数据类型，字符串对象的编码可以是int，raw，embstr。
* - 获取字符串长度的复杂度为O（1）
  - API是安全的，不会造成缓冲区溢出，修改字符串长度N次最多需要执行N次内存重分配
  - string是**二进制安全的**，可以保存文本数据或者二进制数据
  - 兼容部分C函数
  - 一个键最大能存储512MB。

- 在Redis内部，String类型通过`int`、`sds`（simple dynamic string）作为结构存储,`int`用来存放整型数据，`sds`存放字节/字符串和浮点型数据。
- redis3.2分支引入了五种`sdshdr`类型，目的是为了满足不同长度字符串可以使用不同大小的`Header`，从而节省内存，每次在创建一个sds时根据sds的实际长度判断应该选择什么类型的sdshdr，不同类型的sdshdr占用的内存空间不同。

```
数据结构
struct sdshdr {
 //记录buf数组中已֯用字节的数量
 //等于sds所保存字符串的长度
 int len;		例： 0
 //记录buf数组中未使用字节的数量
 int free;		例： 5
 //字节数组，用于保存字符串
 char buf[]; 	例： 'R' 'e' 'd' 'i' 's' '\0'
};

set name pxx			#设置
get name				#获取
setnx					#只有在 key 不存在时设置 key 的值。
setex color 10 red		#设置有效期
setrange name 6 qq.com	#字符替换从第六个开始
getrange name 0 4 		#获取0-4之间的字符
mset key1 v1 key2 v2	#批量设置
mget key1 key2 key3		#批量获取
getset name 123			#获取旧值设置新值
append name .net		#给指定的字符串增加，返回长度
strlen name 			#取指定字符串的长度, 返回长度
incr key1	#增加1，返回新值	incrby key1 5   #增加5
decr key1   #减少1，返回新值	decrby key1 -3  #减少3
```

## List（列表）类型

Redis 列表是简单的字符串列表，按照插入顺序排序。你可以添加一个元素到列表的头部（左边）或者尾部（右边）。列表对象的编码可以是ziplist，linkedlist。

```
lpush list1 "hello"		#从头部压入元素  	rpush从尾部压入元素
lpop list1				#从头部删除元素，返回删除元素	rpop从尾部删除元素
lindex list1 0			#返回key的list中index位置的元素
llen					#返回key对应list的长度
lrange list1 "word" 	#取值
linsert list1 before "word" "hello" 	#在特定元素前或后添加元素
lrem list 3 "hello"		#删除n个和value相同的元素n=0全部删粗n<0从尾部删除
ltrim list1 1 -1 	#保留指定key的范围内的数据,下表从0开始 -1代表一直到结束
```

## Hash（哈希）类型

Redis hash是一个string类型的field和value的映射表，hash特别适合用于存储对象。哈希对象的编码可以是ziplist，hashtable。

```
hset user:001 name pxx
hget user:001 name
hsetnx user:002 name lamp (返回1,失败 0)
# 设置hash field 为指定值 如果key不存在创建
hmset user:003 name 333 age 20 sex 1 #批量设置值 hmget批量获取value
hincrby  user:003 age 5 #指定自增
hexists user:003 age	#测试值是否存在
hlen user:003 			#返回hash的数量
hdel user:003 age 		#删除
hkeys  user:003 ()		#返回hash表所有key，hvals返回所有value
hgetall user:003 		#返回所有的key和value
```

## Set（集合）类型

Redis的Set是string类型的无序集合。集合是通过哈希表实现的，所以添加，删除，查找的复杂度都是O(1)。集合对象的编码可以是intset，hashtable。

```
sadd myset key hello	#添加元素
scard myset				#获取集合元素个数
srem myset [member] 	#移除集合中一个或多个成员
sdiff myset1 myset2		#差集，存储sdiff detis myset1 myset2
sinter myset1 myset2	#交集，存储sinterstore detis myset1 myset2
sunion myset1 myset2	#并集，存储sunionstore detis myset1 myset2
sismember myset "hello" #判断元素是否是myset集合中的成员
smembers myset			#返回集合中所有的成员
smove myset detis hello #将元素移动到detis中
spop myset				#移除并返回集合中的一个随机元素
srandmember myset 2		#返回集合中一个或多个随机数
```



## Sorted Set（有序集合）类型

Redis通过分值(score)进行排序从小到大，有序集合的成员是唯一的，但分值(score)却可以重复。有序集合的编码可以是ziplist，skiplist。

<details>
    <summary>为什么有序集合需要同时使用跳跃表和字典来实现？
    </summary>
    在理论上，有序集合可以单独使用字典或者跳跃表的其中一种数据结构来实现，但无论单独使用字典还是跳跃表，在性能上对比起同时使用字典和跳跃表都会有所降低。举个例子，知果我们只使用字典来实现有序集合，那么虽然以O（1）复杂度查找成员的分值这一特性会被保留，但是，因为字典以无序的方式来保存集合元素，所以每次在执行范围型操作，比知 ZRANK、ZRANGE等命令时，程序都需要对字典保存的所有元素进行排序，完成这种排序需要至少O（NlogN）时间复杂度，以及顺外的 O( N ）内存空间（因为要创建一个数组来保存排序后的元素）。另一方面，如果我们只使用跳跃表来实现有序集合，那么跳跃表执行范围型操作的所有优点都会被保留，但因为没有了字典，所以根据成员查找分值这一操作的复杂度将从O（ 1 ）上升为 O( logN）。因为以上原因，为了让有序集合的查找和范围型操作都尽可能快地执行，Redis选择了同时使用字典和跳跃表两种数据结构来实现有序集合。
</details>
```
zadd myzset "hello"			#添加
zcard myzset				#获取个数
zcount myzset 1 4			#返回指定区间分值的元素个数
zrange myzset 1 2 WITHSCORE #获取分值
zscore
```



## 使用Redis有哪些好处？

- (1) 速度快，因为数据存在内存中，类似于HashMap，HashMap的优势就是查找和操作的时间复杂度都是O(1)
- (2) 支持丰富数据类型，支持string，list，set，sorted set，hash
- (3) 支持事务，操作都是原子性，所谓的原子性就是对数据的更改要么全部执行，要么全部不执行
- (4) 丰富的特性：可用于缓存，消息，按key设置过期时间，过期后将会自动删除

## 支持事务

## Redis持久化

RDB(Redis DataBase) 和AOF(Append Only File)

**RDB** 默认持久化方案，在指定时间间隔内，指定次数写操作。将内存数据作快照文件写入磁盘中，即在指定目录下生成一个dump.rdb文件，Redis重启会通过加载rdb文件恢复数据。

优点：

1 适合大规模的数据恢复。

2 如果业务对数据完整性和一致性要求不高，RDB是很好的选择。

缺点：

1 数据的完整性和一致性不高，因为RDB可能在最后一次备份时宕机了。

2 备份时占用内存，因为Redis 在备份时会独立创建一个子进程，将数据写入到一个临时文件（此时内存中的数据是原来的两倍哦），最后再将临时文件替换之前的备份文件。

所以Redis 的持久化和数据的恢复要选择在夜深人静的时候执行是比较合理的。

**AOF** 默认不开启，弥补RDB。采用日志的形式来记录每个写操作，并追加到文件中。Redis重启会根据日志文件内容将写指令从前到后执行一次以完成数据的恢复工作。

优点：数据的完整性和一致性更高

缺点：因为AOF记录的内容多，文件会越来越大，数据恢复也会越来越慢。

**总结**

1. Redis 默认开启RDB持久化方式，在指定的时间间隔内，执行指定次数的写操作，则将内存中的数据写入到磁盘中。
2. RDB 持久化适合大规模的数据恢复但它的数据一致性和完整性较差。
3. Redis 需要手动开启AOF持久化方式，默认是每秒将写操作日志追加到AOF文件中。
4. AOF 的数据完整性比RDB高，但记录内容多了，会影响数据恢复的效率。
5. Redis 针对 AOF文件大的问题，提供重写的瘦身机制。
6. 若只打算用Redis 做缓存，可以关闭持久化。
7. 若打算使用Redis 的持久化。建议RDB和AOF都开启。其实RDB更适合做数据的备份，留一后手。AOF出问题了，还有RDB