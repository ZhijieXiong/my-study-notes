[TOC]

# 1、页面结构

```html
<!DOCTYPE html>				<!--文档类型定义-->
<html>
  <head>							<!--标题-->
    <title>网页标题</title>
  </head>
  
  <body>							<!--主体-->
  </body>
</html>
```

# 2、块元素

- 段落：`<p></p>`
- 标题：`<h1></h1>`~`<h6></h6>`

- 水平线：`<hr/>`

# 3、行内元素

- 图像：`<img src="url" alt="不显示图片时的文字" height="" >`
- 链接：`<a href="url">链接显示的文字</a>`
- 换行：`<br/>`

- 强调：`<em>倾斜</em>`    `<strong>加粗</strong>`

# 4、列表

## （1）无序列表

```html
<ul>
  <li>第1层</li>
    <ul>
      <li>第2.1层</li>
      <li>第2.2层</li>
    </ul>
  <li>第3层</li>
</ul>
```

<ul>
  <li>第1层</li>
  	<ul>
      <li>第2.1层</li>
      <li>第2.2层</li>
    </ul>
  <li>第3层</li>
</ul>

## （2）有序列表

```html
<ol>
  <li>第1层</li>
    <ul>
      <li>第2.1层</li>
      <li>第2.2层</li>
    </ul>
  <li>第3层</li>
</ol>
```

<ol>
  <li>第1层</li>
  	<ol>
      <li>第2.1层</li>
      <li>第2.2层</li>
    </ol>
  <li>第3层</li>
</ol>

## （3）定义列表

```html
<dl>
  <dt>术语词1</dt> <dd>术语1解释</dd>
  <dt>术语词2</dt> <dd>术语2解释</dd>
</dl>
```

<dl>
  <dt>术语词1</dt> <dd>术语1解释</dd>
  <dt>术语词2</dt> <dd>术语2解释</dd>
</dl>

# 5、表格

- 表格基本使用

```html
<table>
  <caption><strong>表标题</strong></caption>
  <tr> <th>第一列标题</th> <th>第二列标题</th> </tr>
  <tr> <td>1行1列</td> <td>1行2列</td> </tr>
  <tr> <td>2行1列</td> <td>2行2列</td> </tr>
</table>
```

<table>
  <caption><strong>表标题</strong></caption>
  <tr> <th>第一列标题</th> <th>第二列标题</th> </tr>
  <tr> <td>1行1列</td> <td>1行2列</td> </tr>
  <tr> <td>2行1列</td> <td>2行2列</td> </tr>
</table>

- 表格单元格合并：使用colspan和rowspan

```html
<table>
  <caption><strong>单元格合并</strong></caption>
  <tr> <th>第一列标题</th> <th>第二列标题</th> <th>第三列标题</th> </tr>
  <tr> <td colspan="2">1行1、2列</td> <td>1行3列</td> </tr>
  <tr> <td>2行1列</td> <td rowspan="2">2、3行2列</td> <td>2行3列</td> </tr>
  <tr> <td>3行1列</td> <td>3行3列</td> </tr>
</table>
```

<table>
  <caption><strong>单元格合并</strong></caption>
  <tr> <th>第一列标题</th> <th>第二列标题</th> <th>第三列标题</th> </tr>
  <tr> <td colspan="2">1行1、2列</td> <td>1行3列</td> </tr>
  <tr> <td>2行1列</td> <td rowspan="2">2、3行2列</td> <td>2行3列</td> </tr>
  <tr> <td>3行1列</td> <td>3行3列</td> </tr>
</table>

# 6、引用

## （1）块引用和行内引用

```html
<p>这是一个段落
<blockquote>
  块引用
</blockquote>  
<q>行内引用</q>
</p>
```

<p>这是一个段落
<blockquote>
  块引用
</blockquote>  
<q>行内引用</q>
</p>

## （2）字符引用

使用`&实体名`或者`&#实体数字`可以引用字符

```html
左右尖括号：&lt;&gt;
&的引用：&amp;
引号的引用：&quot;
```

左右尖括号：&lt;&gt;
&的引用：&amp;
引号的引用：&quot;

# 7、代码引用

```html
<code>这是代码段</code>
```

<code>这是代码段</code>

# 8、预格式化文本

```html
<pre>
	在这个标签里的内容空格会保留
	像这样    空格会保留
</pre>
```

<pre>
	在这个标签里的内容空格会保留
	像这样    空格会保留
</pre>

# 9、音频

```html
<audio src="./audio/1.mp3">您的浏览器不支持音频</audio>
```

`<audio>`的属性：

| 属性     | 描述                                     |
| -------- | ---------------------------------------- |
| autoplay | 出现该属性，音频就绪后马上播放           |
| controls | 出现该属性，向用户显示控件（如播放控件） |
| loop     | 出现该属性，音频循环播放                 |
| muted    | 规定音频输出应该被静音                   |
| src      | 音频的url                                |

# 10、视频

```html
<video src="./video/2.mkv">您的浏览器不支持视频</video>
```

`<video>`的属性：

- autoplay、contrals、loop、muted、src同`<audio>`

| 属性    | 描述                                                         |
| ------- | ------------------------------------------------------------ |
| height  | 设置视频播放器的高度                                         |
| width   | 设置视频播放器的宽度                                         |
| poster  | 规定视频下载时显示的图像，或者在用户点击播放按钮前显示的图像。 |
| preload | 视频在页面加载时进行加载，并预备播放。 如果使用 "autoplay"，则忽略该属性。 |

# 11、页面划分标签

<table>
  <tr><td colspan="2" align="center">&lt;Head&gt;</td></tr>
  <tr><td colspan="2" align="center">&lt;nav&gt;</td></tr>
  <tr>
  	<td align="center">&lt;article&gt;</td>
    <td rowspan="2" align="center">&lt;asid&gt;</td>
  </tr>
  <tr><td align="center">&lt;section&gt;</td></tr>
  <tr><td colspan="2" align="center">&lt;footer&gt;</td></tr>
</table>



资料来源：

[中国mooc：Web编程](https://www.icourse163.org/learn/XJTU-1003679001?tid=1206704206#/learn/content?type=detail&id=1211700429)