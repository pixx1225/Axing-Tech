[TOC]

# Shell

Shell 是一个用 C 语言编写的程序，它是用户使用 Linux 的桥梁。Shell 既是一种命令语言，又是一种程序设计语言。Shell 脚本（shell script），是一种为 shell 编写的脚本程序。

## **第一个shell脚本**

```shell
touch hello.sh    #创建命令脚本
vim hello.sh 			#键入脚本内容
 键入i 
 插入#!/bin/sh
     echo hello world;
 键入esc 
    :wq
chmod +x hello.sh	#修改脚本权限
./hello.sh				#执行脚本
```



### 注释

```shell
# 这是一行注释

多行注释
:<<EOF
注释内容...
注释内容...
注释内容...
EOF
```



### echo

-e 开启转义   \c 不换行

```shell
read name 
echo "$name It is a test"
#执行脚本
Pkaqiu                     #标准输入
Pkaqiu It is a test        #输出

path=$(pwd)
echo current path: $path
```

- 定向写入文件：echo "It is a test" > myfile

- 显示当前日期：echo \`date\`

### 变量

- 定义变量

```shell
password="P@ssw0rd"		#定义变量
echo $password				#使用变量
echo ${password}			#使用变量
```

- 标准输入变量：`read` var
- 只读变量：`readonly` var
- 删除变量：`unset` var
- 获取长度：${#string}
- 截取长度：${string:1:4}



### 数组

```shell
array_name=(value0 value1 value2 value3)
```

- 读取数组：${array_name[index]}

- 获取所有元素：${array_name[*]}



### 参数

脚本内获取参数的格式为：**$n**。**n** 代表一个数字，1 为执行脚本的第一个参数，2 为执行脚本的第二个参数，以此类推…… **$0** 为执行的文件名（包含文件路径）通过 **$#** 可获取参数总数。

```shell
./test.sh 111 222 333
执行的文件名$0：./test.sh
单纯的文件名$(basename $0)：test.sh
第一个参数为$1：111
第二个参数为$2：222
第三个参数为$3：333
```



### 运算符

1. **算数运算符**

一种是使用**expr**命令， 另外一种是通过方括号（**$[]**）来实现。

```shell
val=`expr 2 \* 2`
echo "两数之积为 : $val"

#输出num1 * num2=30
echo "num1 * num2=$[$num1 * $num2]"
```

使用`expr`时注意：

- 表达式和运算符之间要有空格，例如 2+2 是不对的，必须写成 2 + 2
- 完整的表达式要被 **\` \`** 包含
- 乘号 * 前边必须加反斜杠 \ 才能实现乘法运算

2. **关系运算符**

|   运算符   |      说明                                         |
| ---- | ----------------------------------------------------- |
| -eq  | =检测两个数是否相等，相等返回 true。                  |
| -ne  | !=检测两个数是否不相等，不相等返回 true。             |
| -gt  | >检测左边的数是否大于右边的，如果是，则返回 true。  |
| -lt  | <检测左边的数是否小于右边的，如果是，则返回 true。    |
| -ge  | >=检测左边的数是否大于等于右边的，如果是，则返回 true。 |
| -le  | <=检测左边的数是否小于等于右边的，如果是，则返回 true。 |

```shell
if [ $a -eq $b ]
then
   echo "a 等于 b"
else
   echo "a 不等于 b"
fi

#使用双括号(())允许用数学表达式
if ((num1 > num2))
#字符串比较, 需要转义（\>）(\<)
if test $str1 \> $str2; then...
if [[ $str1 < $str2 ]]; then...
```

3. **布尔运算符**

| 运算符 | 说明                                                |
| :----- | :-------------------------------------------------- |
| !      | 非运算，表达式为 true 则返回 false，否则返回 true。 |
| -o     | 或运算，有一个表达式为 true 则返回 true。           |
| -a     | 与运算，两个表达式都为 true 才返回 true。           |

4. **逻辑运算符**

| 运算符 | 说明       |
| :----- | :--------- |
| &&     | 逻辑的 AND |
| \|\|   | 逻辑的 OR  |

5. **字符串运算符**

| 运算符 | 说明                                         |
| :----- | :------------------------------------------- |
| =      | 检测两个字符串是否相等，相等返回 true。      |
| !=     | 检测两个字符串是否相等，不相等返回 true。    |
| -z     | 检测字符串长度是否为0，为0返回 true。        |
| -n     | 检测字符串长度是否不为 0，不为 0 返回 true。 |
| $      | 检测字符串是否为空，不为空返回 true。        |

### 语句语法

#### IF

```shell
# if-then语句
if command; then
	commands
fi
# if-elif-then语句
if command1; then
	command2 
elif 
	command3; then
	command4
fi
# case
case $num in
1)
    echo "num=1";;
2)
    echo "num=2";;
3)
    echo "num=3";;
4)
    echo "num=4";;
*)
    echo "defaul";;
esac	
```

#### FOR

```shell
for var in list 
do
	commands
done
# C 语言风格
for (( i = 0; i <= 10; i++ ))
do
	echo $i
done	
```

#### WHILE

```shell
while test command 
do
	other commands
done
```

#### UNTIL

```shell
until test commands
do
	other commands
done
```



### printf

- 默认 printf 不会像 echo 自动添加换行符，我们可以手动添加 \n。

```shell
printf  format-string  [arguments...]
```

- format-string: 为格式控制字符串
- arguments: 为参数列表

```shell
printf "%-10s %-8s %-4s\n" 姓名 性别 体重kg  
printf "%-10s %-8s %-4.2f\n" 郭靖 男 66.1234 
printf "%-10s %-8s %-4.2f\n" 杨过 男 48.6543 
printf "%-10s %-8s %-4.2f\n" 郭芙 女 47.9876 
#执行脚本
姓名     性别   体重kg
郭靖     男      66.12
杨过     男      48.65
郭芙     女      47.99
```









































