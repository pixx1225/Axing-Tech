[TOC]

# Java I/O

## I/O概览

Java的I/O大概可以分成以下几类：

1. 文件操作：FileInputStream, FileOutputStream, FileReader, FileWriter

2. 数组操作：

    字节数组：ByteArrayInputStream, ByteArrayOutputStream

    字符数组：CharArrayReader, CharArrayWriter

3. 管道操作：PipedInputStream, PipedOutputStream, PipedReader, PipedWriter

4. 缓冲操作：BufferedInputStream, BufferedOutputStream, BufferedReader, BufferedWriter

5. 基本数据类型：DataInputStream, DataOutputStream

6. 对象序列化操作：ObjectInputStream, ObjectOutputStream

7. 转换控制：InputSreamReader, OutputStreamWriter

8. 打印操作：PrintStream, PrintWriter

    

## 字节流与字符流

**从数据传输方式，可以将 IO 类分为**

- 字节流
- 字符流

![JavaIO分类](https://github.com/pixx1225/Axing-Tech/blob/master/images/JavaIO分类.png)

### 字节流与字符流的区别

1. 读写单位不同：字节流以字节（8bit）为单位，字符流以字符为单位，根据码表映射字符，一次可能读多个字节。

2. 处理对象不同：字节流能处理所有类型数据（二进制文件：图片、MP3、视频文件、Office文件），字符流只能处理字符类型数据，多用来处理文本文件。简而言之，字节是个计算机看的，字符才是给人看的。

3. 是否有缓冲区：字节流没有缓冲区，是直接输出的，而字符流是输出到缓冲区的。因此在输出时，字节流不调用 colse() 方法时，信息已经输出了，而字符流只有在调用 close() 方法关闭缓冲区时，信息才输出。要想字符流在未关闭时输出信息，则需要手动调用 flush() 方法。

### 读取键盘输入，打印到控制台，PrintWriter，BufferedReader, InputStreamReader

```java
public static void keyInAndPrintConsole() throws IOException {
    PrintWriter out = null;
    BufferedReader br = null;
    try {
        System.out.println("请输入:");
        out = new PrintWriter(System.out, true);
        br = new BufferedReader(new InputStreamReader(System.in));
        String line = null;
        while ((line = br.readLine()) != null) {
            if (line.equals("exit")) {
                System.exit(1);
            }
            out.println(line);
        }
    } catch (IOException e) {
        e.printStackTrace();
    } finally {
        out.close();
        br.close();
    }
}
```



### 字节流读写文件，InputStream，OutputStream

```java
//读写文件
public static void readAndWriteByteToFile() throws IOException {
    InputStream is =null;
    OutputStream os = null;
    try {
        is = new FileInputStream("D:/FileInputStreamTest.txt");
        os = new FileOutputStream("D:/FileOutputStreamTest.txt");
        byte[] buf = new byte[1024];
        int readLen = 0;
        while ((readLen = is.read(buf)) > 0) {
            os.write(buf, 0, readLen);
        }
        System.out.println("write success");
    } catch (Exception e) {
        e.printStackTrace();
    }finally{
        os.close();
        is.close();
    }
}
//读文件
public static void readByteTofile() throws IOException{
    File file = new File("D:\\a.txt");
    FileInputStream fis = new FileInputStream(file);
    byte[] bytes = new byte[1024];
    int readLen;
    while((readLen = fis.read(bytes)) != -1) {
        String s = new String(bytes, 0, readLen);
        System.out.println(s);
    }
    fis.close();
}
//写文件
public static void writeByteToFile() throws IOException{
    String string = "hello word!";
    File file = new File( "D:/test.txt");
    OutputStream os = new FileOutputStream(file);
    os.write(string.getBytes("UTF-8"));
    os.close();
}
```

### 字符流读写文件，FileReader，FileWriter

```java
public static void readAndWriteCharToFile() throws IOException{
    Reader reader = null;
    Writer writer =null;
    try {
        File readFile = new File("D:/FileInputStreamTest.txt");
        reader = new FileReader(readFile);
        File writeFile = new File("D:/FileOutputStreamTest.txt");
        writer = new FileWriter(writeFile);
        char[] byteArray = new char[(int) readFile.length()];
        int size = reader.read(byteArray);
        System.out.println("大小:" + size + "个字符;内容:" + new String(byteArray));
        writer.write(byteArray);
    } catch (Exception e) {
        e.printStackTrace();
    }finally{
        reader.close();
        writer.close();
    }
}
```

## File

### 文件的创建

```java
File file = new File("D:\\a.txt");
if(!file.exists()){
    file.createNewFile();
}
```

### 文件夹的创建

```java
File fileFolder = new File("D:\\New Folder");
if(!fileFolder.isDirectory()){
    fileFolder.mkdir(); 
}
```

### 列出文件夹内所有文件

```java
File fileFolder = new File("D:\\New Folder");
//如果文件夹存在，则列出其中所有文件名
if(fileFolder.isDirectory()){ 
    File[] files = fileFolder.listFiles();
    for (File file : files) {
        System.out.println(file.getName());
    }
}
```

## BufferedOutputStream

> 1. BufferedOutputStream 等带缓冲区的实现，
> 2. 可以避免频繁的磁盘读写，进而提高 IO 处理效率。
> 3. 这种设计利用了缓冲区，将批量数据进行一次操作，
> 4. 使用中一定要`flush`。

## RandomAccessFile

> 1. 随机文件操作
> 2. 一个独立的类，直接继承至Object.
> 3. 功能丰富，可以从文件的任意位置进行存取（输入输出）操作。



## ZipOutputStream

**文件压缩操作**

1.创建ZipOutPutStream流，利用BufferedOutputStream提个速.

2.新建zip方法,用来压缩文件,传参

3.zip方法利用putNextEntry来将目录点写入

4.递归目录数组，写入数据

5.关闭流

```java
try{
    Map<String, Object> map = gson.fromJson(json, Map.class);
    //参数预处理，格式化
    
    //如果只有一个文件，则直接下载
    if(1 == product.size()){
        StringBuilder sb = getSbByProd(params);
        String fileName = "单个文件";
        FileHelper.exportCSV(resp, sb, fileName);
    }else{
        //如果多个文件，则打包下载
        byte[] buffer = new byte[1024];
        BufferedOutputStream bos = new BufferedOutputStream(resp.getOutputStream());
        String zipFileName = "打包文件";
        resp.setContentType("application/x-msdownload");
        resp.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(zipFileName + ".zip", "UTF-8"));
        ZipOutputStream zos = new ZipOutputStream(bos);
        
        for(String prod : product){
            StringBuilder sb = getSbByProd(params);
            String singleFileName = prod + ".csv";
            zos.putNextEntry(new ZipEntry(singleFileName));
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            baos.write(sb.toString().getBytes("UTF-8"));
            InputStream in = new ByteArrayInputStream(baos.toByteArray());
            int len;
            while((len = in.read(buffer)) > 0){
                zos.write(buffer, 0, len);
            }
            in.close();
            zos.closeEntry();
        }
        zos.close();
        bos.close();
    }
} catch (IOException e){
    logger.error("导出文件异常："， e);
}

public void exportCSV(HttpServletResponse resp, StringBuilder sb, String filename){
    BufferedOutputStream bos = null;
    try{
        OutputStream os = resp.getOutputStream();
        bos = new BufferedOutputStream(os);
        resp.setContentType("application/csv;charset=UTF-8");
        resp.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(filename + ".csv", "UTF-8"));
        bos.write(sb.toString().getBytes("UTF-8"));
    } catch(IOException e){
        logger.error("生成CSV文件异常："， e);
    }finally{
        bos.close();
    }
}
```

