[TOC]

# Java I/O

## I/O概览

Java的I/O大概可以分成以下几类：

1. 文件操作：FileInputStream, FileOutputStream, FileReader, FileWriter

2. 数组操作：

   	- 字节数组：ByteArrayInputStream, ByteArrayOutputStream
   	- 字符数组：CharArrayReader, CharArrayWriter

3. 管道操作：PipedInputStream, PipedOutputStream, PipedReader, PipedWriter

4. 缓冲操作：BufferedInputStream, BufferedOutputStream, BufferedReader, BufferedWriter

5. 基本数据类型：DataInputStream, DataOutputStream

6. 对象序列化操作：ObjectInputStream, ObjectOutputStream

7. 转换控制：InputSreamReader, OutputStreamWriter

8. 打印操作：PrintStream, PrintWriter

    

**从数据传输方式，可以将 IO 类分为**

- 字节流
- 字符流

字节流读取单个字节，字符流读取单个字符。字节流用来处理二进制文件（图片、MP3、视频文件、Office文件），字符流用来处理文本文件。简而言之，字节是个计算机看的，字符才是给人看的。

![JavaIO分类](https://github.com/pixx1225/Axing-Tech/blob/master/images/JavaIO分类.png)



### 字节流写文件

```java
public static void writeByteToFile() throws IOException{
    String string = new String( "hello word!");
    File file = new File( "d:/test.txt");
    OutputStream os = new FileOutputStream(file);
    os.write(string.getBytes);
    os.close();
}
```



### ZipOutputStream

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

