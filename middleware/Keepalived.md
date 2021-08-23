# keepalived

### 安装

官网[下载keepalived](http://www.keepalived.org/download.html)的对应版本

```shell
wget http://www.keepalived.org/software/keepalived-2.1.0.tar.gz
tar xvf keepalived-2.1.0.tar.gz
cd keepalived-2.1.0
./configure --prefix=/home/redis/dev/keepalived
make && make install

cp /usr/local/keepalived/etc/sysconfig/keepalived  /etc/sysconfig/keepalived
cp /usr/local/keepalived/sbin/keepalived /sbin/keepalived
cp /usr/local/keepalived/etc/init.d/keepalived  /etc/rc.d/init.d/keepalived
mkdir /etc/keepalived
cp /usr/local/keepalived/etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf
```

