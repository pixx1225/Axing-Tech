[TOC]

# Markdown

推荐markdown编辑器 **Typora**

- 切换编辑类型 		（Ctrl+/）
- 变成正文		        （Ctrl+0）

目录`[TOC]`

``` 
# 一级标题   		(Ctrl+1)

## 二级标题   		(Ctrl+2)

### 三级标题    	(Ctrl+6)

下面是一条分割线
---或者***   一条分割线
```

# 一级标题

## 二级标题

### 三级标题

下面是一条分割线

---

`**加粗**`

`*斜体*`

`<u>下划线</u>`

全角空格 `&emsp;`

:smile: `:smile:` 	 还有其他各种emoji [表情图标](https://www.webfx.com/tools/emoji-cheat-sheet/) 

---

```markdown
> 这是个引用
```

> 这是个引用

```markdown
* 第一
* 第二
* 第三

- [ ] 任务一
- [x] 任务二
```

*   第一
*   第二
*   第三

- [ ] 任务一
- [x] 任务二

```markdown
[链接](http://www.baidu.com)
```

[链接](http://example.net/)
$$
\mathbf{V}_1 \times \mathbf{V}_2 =  \begin{vmatrix}
\mathbf{i} & \mathbf{j} & \mathbf{k} \\
\frac{\partial X}{\partial u} &  \frac{\partial Y}{\partial u} & 0 \\
\frac{\partial X}{\partial v} &  \frac{\partial Y}{\partial v} & 0 \\
\end{vmatrix}
$$

| Left-Aligned  | Center Aligned  | Right Aligned |
| :------------ | :-------------: | ------------: |
| col 3 is      | some wordy text |         $1600 |
| col 2 is      |    centered     |           $12 |
| zebra stripes |    are neat     |            $1 |

```markdown
| Left-Aligned  | Center Aligned  | Right Aligned |
| :------------ |:---------------:| -----:|
| col 3 is      | some wordy text | $1600 |
| col 2 is      | centered        |   $12 |
| zebra stripes | are neat        |    $1 |
```

## Markdown内容收缩展开

```java
<details>
    <summary>展开</summary>
    展开的内容
</details>
```

<details>
<summary>展开</summary>
    这里写展开的内容。这样使得文章直观效果更好
</details>



**脚注**

对文章的内存进行标注[^ 脚注]

[^ 脚注]: 哈哈，这是一个注脚，备注内容