[TOC]

# 文件输入输出

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

