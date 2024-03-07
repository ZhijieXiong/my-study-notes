[TOC]

# 一、html中的各种链接

## 1、网站链接

- ***使用`<a>`标签来链接一个网站，如下***

```html
<a href="https://www.baidu.com">百度</a>

效果如下
```

​	<a href="https://www.baidu.com">百度</a>

- ***`<a>`标签加上target属性可以指定在哪里打开，如_blank表示在新窗口打开，如下***

```html
<a href="https://www.baidu.com" target="_blank">百度</a>
```



## 2、图片链接

- ***使用`<img>`标签完成图片的链接，如下***

```html
<img src="./img/kuli.jpg" alt="库里">

效果如下（其中src为图片的地址，alt为图片无法显示时的替代文本）
```

<img src="./img/kuli.jpg" alt="库里">

- ***`<img>`标签也可以链接到网页，如下***

```html
<img src="http://static.runoob.com/images/runoob-logo.png" alt="菜鸟教程">

效果如下
```

<img src="http://static.runoob.com/images/runoob-logo.png" alt="菜鸟教程">

- ***`<img>`标签还可以设置图片的其它一些属性，比如高度（height）和宽度（width）***

```html
<img src="./img/kuli.jpg" alt="菜鸟教程" height="80" width="100">

效果如下
```

<img src="./img/kuli.jpg" alt="菜鸟教程" height="80" width="100">



## 3、文件内的跳转（锚）

`*<a>`标签还可以实现文件内的跳转，如下*

```html
<a id="des">锚点</a>
<a href="#des">跳转到锚点</a>
```

***注意：***在md中使用`<a>`标签时，似乎要用`name`属性来标记锚点



# 二、md中的各种链接

## 1、网站链接

- ***直接使用`<>`括起来***

```markdown
<https://www.baidu.com>
```

- ***使用文本替代链接（title是鼠标移动到链接上显示的文本）***

```markdown
[百度](https://www.baidu.com "title")

效果如下
```

​	[百度](https://www.baidu.com "title")

- ***高级链接：使用变量代替链接，在文档末尾附上链接***

```markdown
这是百度的链接：[百度][001]
这是新浪的链接：[新浪][002]

[001]:https://www.baidu.com
[002]:https://www.sina.com

效果如下
```

这是百度的链接：[百度][001]
这是新浪的链接：[新浪][002]

[001]:https://www.baidu.com
[002]:https://www.sina.com



## 2、图片链接

- ***基本格式为`![图片替代文本（当图片无法正常显示时出现）](图片链接)`，例子如下***

```markdown
![菜鸟教程图片](http://static.runoob.com/images/runoob-logo.png)

效果如下
```

![菜鸟教程图片](http://static.runoob.com/images/runoob-logo.png)

- ***本地图片链接格式一样，使用绝对路径或者相对路径，例子如下***

```markdown
![库里](./img/kuli.jpg)

效果如下
```

![库里](../img/kuli.jpg)

- ***也可以像网站链接那样使用变量代替链接，在文档末尾附上链接***



## 3、文件之间的跳转

***类似本地的图片链接，只是无`!`，如下***

```
[本地的另一个文件](文件绝对路径或者相对路径)
```



## 4、md中使用html标签的链接

***md中的链接都比较简单，更复杂的链接（比如说设置大小，指定跳转位置）可以使用html中的标签，如`<a>`标签和`<img>`标签***









资料来源（Ctrl+点击 或者 command+点击打开网址）：

- [菜鸟教程](https://www.runoob.com/html/html-links.html)
- [菜鸟教程](https://www.runoob.com/markdown/md-link.html)