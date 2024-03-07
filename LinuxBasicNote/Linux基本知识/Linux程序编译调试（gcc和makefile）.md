# 一、gcc基本使用

## 1、gcc编译过程

源文件—>预处理—>汇编—>编译—>链接—>可执行文件

## 2、gcc编译c文件

- 命令：gcc [选项] <文件名>


- 选项：
  - -o	指定输出的文件名，默认生成可执行文件名为a.out
  - -E	预处理阶段：对包含的头文件（#include）和宏定义（#define、#ifdef等）进行处理,生成.i文件，不加-o选项，默认输出为标准输出（屏幕）
  - -S	汇编阶段：检查代码规范性、语法错误等，在检查无误后把代码翻译成汇编语言，生成.s文件，不加-o选项，默认生成sourcename.s文件
  - -c	编译阶段：将汇编文件翻译成机器码，生成.o文件，不加-o默认生成sourcename.o文件
  - -D	宏定义选项，如`-DPI=3.14`表示`#define PI 3.14` 
  - -l	添加头文件搜索路径，可用此选项指定搜索路径
  - -w	禁止所有警告信息（warning）
  - -wall	打开所有警告选项，输出警告信息
- 例子

```sh wsh w
dream:1_线性表（顺序存储） dream$ gcc -E -o item.i item.c 
dream:1_线性表（顺序存储） dream$ ls
item.c	item.i
dream:1_线性表（顺序存储） dream$ gcc -S -o item.s item.i
dream:1_线性表（顺序存储） dream$ ls
item.c	item.i	item.s
dream:1_线性表（顺序存储） dream$ gcc -c -o item.o item.s
dream:1_线性表（顺序存储） dream$ ls
item.c	item.i	item.o	item.s
dream:1_线性表（顺序存储） dream$ gcc -o item.exe item.o
dream:1_线性表（顺序存储） dream$ ls
item.c		item.exe	item.i		item.o		item.s
dream:1_线性表（顺序存储） dream$ ./item.exe 
申请内存成功！
表为空！
插入成功！
插入成功！
插入成功！
插入成功！
插入位置大于表现有长度，其余位置初始化为0!
表的内容是：10 999 1000 1000 0 10000 
```

也可以直接一步生成可执行文件，即直接使用gcc命令，不加选项，则包含了以上四个过程，如下

```shell
dream:1_线性表（顺序存储） dream$ gcc -o main.exe main.c
dream:1_线性表（顺序存储） dream$ ls
main.c		main.exe
dream:1_线性表（顺序存储） dream$ ./main.exe 
申请内存成功！
表为空！
插入成功！
插入成功！
插入成功！
插入成功！
插入位置大于表现有长度，其余位置初始化为0!
表的内容是：10 999 1000 1000 0 10000 
```

​	

# 二、makefile基本使用

## 1、makefile介绍

**（1）make命令用来编译源文件和链接目标文件**

- 编译：将源代码编译成目标文件（即机器码，后缀名为.o或.obj）
- 链接：使用目标文件链接应用程序生成可执行文件

**（2）Makefile文件则是用来告诉make命令怎么去编译和链接程序**

> 一个工程中的源文件不计数，其按***类型、功能、模块***分别放在若干个目录中，makefile定义了一系列的规则来指定，哪些文件需要先编译，哪些文件需要后编译，哪些文件需要重新编译，甚至于进行更复杂的功能操作，因为makefile就像一个Shell脚本一样，其中也可以执行操作系统的命令。makefile带来的好处就是——“自动化编译”，一旦写好，只需要一个make命令，整个工程完全自动编译，极大的提高了软件开发的效率。



## 2、Makefile规则

**（1）Makefile的编译规则**

- 如果这个工程没有编译过，那么我们的所有C文件都要编译并被链接。
- 如果这个工程的某几个C文件被修改，那么我们只编译被修改的C文件，并链接目标程序。
- 如果这个工程的头文件被改变了，那么我们需要编译引用了这几个头文件的C文件，并链接目标程序。

**（2）Makefile的语法**

```makefile
target(目标):Dependent object（依赖对象）
	command（shell命令）
```

- target：可以是目标文件（.o），也可以是可执行文件（.exe），还可以是label（这个没有去深入了解）
- Dependent object：目标依赖的对象，就是生成目标所需要的文件或者其它目标
- command：任意的shell命令，注意command前面有一个制表符

**（3）Makefile的语法解释**

生成`target`需要`Dependent object`，如果`Dependent object`不存在或者`Dependent object`更改过，那么就会执行`command`以生成所需要的目标或文件

## 3、示例

**（1）不使用make和Makefile，手动编译程序**

现在以一个示例来说明make和Makefile，在一个test目录下，有2个头文件和3个.c文件，如果不使用make来编译，手动编译的过程如下：

```shell
dream:test dream$ ls
main.c	tool1.c	tool1.h	tool2.c	tool2.h
dream:test dream$ gcc -w -c main.c
dream:test dream$ gcc -w -c tool1.c
dream:test dream$ gcc -w -c tool2.c
dream:test dream$ gcc -o main main.o tool1.o tool2.o
dream:test dream$ ls
main	main.c	main.o	tool1.c	tool1.h	tool1.o	tool2.c	tool2.h	tool2.o
dream:test dream$ ./main
This is write1
This is write2!!!!
```

**（2）使用make编译程序**

文件夹的内容同上，Makefile的内容如下：

```makefile
main: main.o tool1.o tool2.o
	gcc -o main.exe main.o tool1.o tool2.o
main.o: main.c tool1.h tool2.h
	gcc -w -c main.c
tool1.o: tool1.c tool1.h
	gcc -w -c tool1.c
tool2.o: tool2.c tool2.h
	gcc -w -c tool2.c
clean:
	rm -rf *.o *.exe
```

编写好Makefile后，使用make命令看一下效果

```shell
dream:makefile的示例 dream$ ls
Makefile	tool1.c		tool2.c
main.c		tool1.h		tool2.h
dream:makefile的示例 dream$ make										# 写好Makefile后，直接使用make命令编译
gcc -w -c main.c
gcc -w -c tool1.c
gcc -w -c tool2.c
gcc -o main.exe main.o tool1.o tool2.o
dream:makefile的示例 dream$ ls
Makefile	main.exe	tool1.c		tool1.o		tool2.h
main.c		main.o		tool1.h		tool2.c		tool2.o
dream:makefile的示例 dream$ ./main.exe 
This is write1
This is write2!!!!
dream:makefile的示例 dream$ make clean							# 使用make clean一键删除.o和.exe文件
rm -rf *.o *.exe
dream:makefile的示例 dream$ ls
Makefile	tool1.c		tool2.c
main.c		tool1.h		tool2.h
```



# 三、Makefile进阶使用



参考资料：

- [博客：gcc查看c语言编译过程](https://blog.csdn.net/qq_40860986/article/details/100184203)
- [mooc-电子科技大学-Linux操作系统编程](https://www.icourse163.org/learn/UESTC-1003040002?tid=1206878228#/learn/announce)
- [博客：Makefile教程](https://blog.csdn.net/weixin_38391755/article/details/80380786)
- [微信公众号：Makefile编写](https://mp.weixin.qq.com/s/e1fTVfq6NM_0a1eLfFceCg)