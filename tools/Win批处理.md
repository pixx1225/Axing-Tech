# Windows批处理

批处理文件(Batch File，简称BAT文件)是一种在DOS下最常用的可执行文件。它具有灵活的操纵性，可适应各种复杂的计算机操作。所谓的批处理，就是按规定的顺序自动执行若干个指定的DOS命令或程序。即是把原来一个一个执行的命令汇总起来，成批的执行，而程序文件可以移植到其它电脑中运行，因此可以大大节省命令反复输入的繁琐。同时批处理文件还有一些编程的特点，可以通过扩展参数来灵活的控制程序的执行，所以在日常工作中非常实用。

```bat
@echo off
title Git-push2github
color 0a
setlocal EnableDelayedExpansion
set date=%DATE:~3,13%

for /f "tokens=1-3 delims=/" %%a in ("%date%") do (
	set format_date=%%a
	if not "%%b"=="" (
    	set format_date=!format_date!%%b
 	)
	if not "%%c"=="" (
	    set format_date=!format_date!%%c
	)
)
C:
cd \Users\Pi_Xi\Documents\MyFiles\Axing-Tech
git add .
echo git add结束，按任意键继续...
pause>nul
git commit -m "Axing!format_date!"
echo git commit结束，按任意键继续...
pause>nul
git push
pause
```



- **@echo off**

批处理文件的第一行，不会将文件里面的内容打印出来，如果没有这句话，会先去将文件里面的内容打印在屏幕上。

- **echo please input:**

打印显示 please input:

- **echo Hello world!>D:\a.txt**

\> 表示将输出结果打印到某处。内容覆盖。而>>内容追加。

如果一条命令后面跟上 >nul ，比如 pause>nul 表示将 pause 这条命令的输出显示到空设备里， nul 表示为空。用了 pause>nul 这条命令后，"按任意键继续..."的提示就不再出现了。

```bat
@echo off
title Test-bat
echo Hello world!>D:\a.txt
set /p var=请输入一个变量：
echo %var%
echo %var%>>D:\a.txt
echo 自定义提示消息...
pause>nul
```

- **title redis-server**

设置批处理窗口名字

- **set ENV_HOME="D:\DevApps\Redis"**
- **set /p input=请输入一个参数：**

设置变量赋值。

set 后面加上 /a 的参数，可以给变量赋予一个数值型的值，例如 set /a var=48 表示将数字48赋给变量var。

set 后面加上 /p 的参数，可以将变量设成用户输入的一行输入。读取输入行之前，显示指定的 提示文字（可为空）。

- **使用`%input%`来引用变量。**

对变量中的字符串在特定位置上的删减将用到这样的格式：`%var:~m% `和 `%var:~m,n% `。m 和 n 为整数参数。数字 m 为正数表示取变量 var 中从左侧数第 m 个字符(单字节字符)以后的内容；m 为负数则表示取变量 var 从右侧数第 -m 个字符以及其右侧的所有的字符，这就是第一条命令所产生的新字符串。如果数字 n 为正数，表示在上述新字符串中，从其左侧取 n 个字符的内容；若 n 为负数，则从其左侧取字符直到还剩下 -n 个字符为止的内容。

```bat
echo %var%　　　　 1234567890　显示所有　　　　　　　　　　　　　　　　　
echo %var:~4%　　 567890　　　 从第4个字符以后开始显示　　　　　　　　　
echo %var:~4,3%　 567　　　　  从第4个字符以后开始显示，并只显示前3个　　
echo %var:~-4%　　7890　　　　 从倒数第4个字符开始显示　　　　　　　　　
echo %var:~-4,3%　789　　　　  从倒数第4个字符开始显示，并只显示前3个　　
echo %var:~4,-2%　5678　　　　 从第4个字符以后开始显示，显示到还剩2个为止
echo %var:~0,3%　 123　　　　  从头开始显示，并只显示前3个字符　　　　　
echo %var:~0,-3%　1234567　　 从头开始显示，显示到还剩3个字符为止
pause
```

- **pause 暂停**

暂停，在文件运行的中间让其暂停一下，看一下我们的输出，控制台显示：“请按任意键以继续...”

- **call D:\temp.bat**

调用另外一个批处理文件

- **goto :FirstLable**

goto 跟上标签就能直接让程序从该标签处开始继续执行随后的命令，不论标签的位置是在该 goto 命令的前面还是后面。标签必须以单个冒号 : 开头，但不区分大小写。有个特殊的标签 :EOF 或 :eof 能将控制转移到当前批脚本文件的结尾处，它是不需要事先定义的。

```
@echo off
goto :FirstLable

:SecondLable
echo 然后显示这句
pause
goto :EOF

:FirstLable
echo 首先显示这句
pause
goto :SecondLable
```

- **start**

start "这就是所谓的标题" cmd 用来打开一个新的命令提示符；start "随便写个标题" http://www.baidu.com 便打开百度的首页；而 start "开玩了" E:\game\starcraft\starcraft.exe 却是开始星际争霸

- **rem 和 ::** 注释

- **if 条件**

```bat
@echo off
set var=Tom
if %var%==Tom echo It works-Tom
if %var%==Jerry echo We will never see this
set var2="Tom Hanks"
if %var2%=="Tom Hanks" echo It works-Tom Hanks
pause

@echo off
if "%TIME:~0,2%" lss "12" (
echo 现在是上午
) else (
echo 现在是下午
)
pause
```

- **for 循环**

for %%i in (\*.\*) do @echo %%i 。这就是 for 的一般使用格式。

```bat
@echo off
setlocal EnableDelayedExpansion
set /a num=1
for %%i in (D:\test\*.txt) do (
    ren "%%i" !num!.txt
    set /a num+=1
)
```

setlocal EnableDelayedExpansion 可以让 for 或 if 后面的执行语句中变量的值随其变化而不断更新(所以后面使用了 !num! 而不是 %num%)。整个批处理的处理过程就是对 D:\test\*.txt 中的所有文本文件进行批量改名，文件名从 1.txt 开始依次为 2.txt 、3.txt ……。

- 无参：遍历当前路径的文件夹下的文件，但也可在(匹配符)中指定路径；
- /d：遍历当前路径的文件夹下的文件夹，但也可在(匹配符)中指定路径；
- /r [路径]：深度遍历指定路径下的所有文件，子目录中的文件也会被遍历到，如果没指定路径，默认当前路径；
- /l ：当使用参数 /l 时，需结合(匹配符)一起使用，此时 () 括号内部的用法规则为：(start, step, end)，此时的 for 命令作用等同于 java 语言中的 for 语句；
- /f ：用于解析文件中的内容；

for 后面跟参数 /l ，常用来对一系列有规律的数字进行循环。比如：for /l %i in (5,3,16) do echo %i ，可以让数值型的变量 i 依次成为：5、8、11、14 。正如 in 里所描述的规律 (5,3,16) 一样，从 5 开始，每次增加 3 ，直到 16为止。同样，我们还可以试一下 for /l %i in (19,-4,3) do echo %i ，这次 i 是递减的规律。很明显，结果将依次显示为：19、15、11、7、3 。

for 后面跟参数 /f ，常用来解析文本，读取字符串。/f 后面跟选项，所指定的范围 in 里是一个文件里的文字。我们首先以一个文件里的文字作为循环对象，循环时，每一行将被循环一次。

```bat
@echo off
for /f "skip=2 delims=，" %%i in (a.txt) do (
	echo %%i
)
pause

skip=2 表示跳过前两行
delims=, 表示不再以空格区分每个词，而是以,作为间隔，只取每行的,前面内容
tokens=2,4-6 表示提取每行的第2个、以及第4到6个单词，有delims则以分割部分来取列
eol=N 表示当此行的首字母为 N 时，就忽略该行
usebackq 表示双引号里的东西是文件名而不是字符串
```

遍历一个文件夹下的文件名

```bat
@echo off
echo please input version:
set /p input_version
for /f "delims=" %%i in ('dir /ad/b "D:/Project/TS"') do (
	echo %%i version is %input_version%
	D:
	cd /Project/TS/%%i
	git checkout master %input_version%
	git pull
	mvn clean
	mvn install
	cd ..
	pause
)
:: dir /ad 只显示文件夹列表：
```

- **dir 文件**

/A          显示具有指定属性的文件。
属性       D  目录                   R  只读文件
               H  隐藏文件            A  准备存档的文件
               S  系统文件             I  无内容索引文件
               L  解析点                 -  表示“否”的前缀

/B          使用空格式(没有标题信息或摘要)

/O          用分类顺序列出文件。
排列顺序     N  按名称(字母顺序)      S  按大小(从小到大)
                    E  按扩展名(字母顺序)   D  按日期/时间(从先到后)
                    G  组目录优先                 -  反转顺序的前缀

- **color 颜色**

```bat
color 0a
```

**其他命令：**

dir 　　　列文件名
cd　　　　改变当前目录
ren 　　　改变文件名
copy　　　拷贝文件
del 　　　删除文件
md　　　　建立子目录
rd　　　　删除目录
deltree　 删除目录树
format　　格式化磁盘
edit　　　文本编辑
type　　　显示文件内容
mem 　　　查看内存状况
help　　　显示帮助提示
cls 　　　清屏
move　　　移动文件，改目录名
more　　　分屏显示
xcopy 　　拷贝目录和文件