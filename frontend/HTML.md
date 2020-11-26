# HTML

### 基础

```html
<br />		#换行
<hr />		#水平线
<!-- This is a comment -->	#注释
target="_blank"		#新窗口打开链接
```

### 外部样式表

```html
<head>
	<link rel="stylesheet" type="text/css" 	href="mystyle.css">
</head>
```

### 内部样式表

```html
<head>
	<style type="text/css">
		body {background-color: red}
		p {margin-left: 20px}
	</style>
</head>
```

### 缩写并悬浮展示

```
<abbr title="World Health Organization">WHO</abbr>
<dfn title="World Health Organization">WHO</dfn>
```

### 编程代码

```html
<code>
<pre>
var person = {
    firstName:"Bill",
    lastName:"Gates",
    age:50,
    eyeColor:"blue"
}
</pre>
</code>
```

### 框架

```html
<frameset rows="50%,50%">
    <frame src="/example/html/frame_a.html">
	<frameset cols="25%,75%">
        <frame src="/example/html/frame_b.html">
        <frame src="/example/html/frame_c.html">
    </frameset>
</frameset>

noresize="noresize"
```

### 内联框架

```html
<iframe src="URL"></iframe>
```

### 背景

```html
body {
		width：100%；
		height: 100%;
		background-image: url(background.jpg);
		background-repeat: no-repeat;
		background-size: 100% 100%;
	}
```

