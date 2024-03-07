[TOC]

# 1、第一个shell脚本

```shell
[dream@172 tmp]$ vim test.sh 
[dream@172 tmp]$ cat test.sh 
#!/usr/bin/bash

echo -e "hello, world!"
[dream@172 tmp]$ chmod 755 test.sh 		// 更改权限
[dream@172 tmp]$ ./test.sh 						// 执行脚本
hello, world!
```

- `#!/usr/bin/bash`：标称以下的脚本使用的是bash语法，建议加上

- `echo`：输出命令

  ```shell
  echo [选项] <输出内容>
  
  # -e：表示支持反斜杠控制的字符转义（如"\n"）
  # -n：取消输出后行末的换行符
  ```

- `./test.sh`：表示脚本文件的执行路径，因为未对环境变量进行配置，所以需要使用绝对路径或相对路径执行
                          脚本

- 注意：不能直接在Linux下执行Windows的脚本，因为格式不匹配，Linux下换行符为\$，而Windows下换行符
             为^M\$，使用以下两个命令可以互相转换Linux和Windows的脚本

  - `dos2unix`：将Windows脚本转换为Linux脚本
  - `unix2dos`：将Linux脚本转换为Windows脚本

# 2、bash中的变量

## （1）变量设置规则

-  变量名称可以由字母、数字和下划线组成，但是不能以数字开头

- 在Bash中，变量的默认类型都是字符串型，如果要进行数值运算，则必修指定变量类型为数值型

- 变量用等号连接值，等号左右两侧不能有空格

- 变量的值如果有空格，需要使用单引号或双引号包括

- 在变量的值中，可以使用转义符

- 如果需要增加变量的值，可以进行变量值的叠加，变量需要用双引号包含`"\$变量名"`或用`​\${变量名}`包含

  ```shell
  [dream@172 tmp]$ ttt=123
  [dream@172 tmp]$ echo $ttt
  123
  [dream@172 tmp]$ ttt="$ttt"456
  [dream@172 tmp]$ echo $ttt
  123456
  [dream@172 tmp]$ ttt=${ttt}789
  [dream@172 tmp]$ echo $ttt
  123456789
  ```

- 如果是把命令的结果作为变量值赋予变量，则需要使用反引号` `` `或`$()`包含命令

  ```shell
  [dream@172 tmp]$ my_time=`date`
  [dream@172 tmp]$ echo $my_time 
  2020年 02月 24日 星期一 22:20:30 CST
  [dream@172 tmp]$ my_time=$(date)
  [dream@172 tmp]$ echo $my_time 
  2020年 02月 24日 星期一 22:21:02 CST
  ```

  - 注意，这是把命令的结果赋值给变量，不是把一个变量的值赋给另一个变量

- 环境变量名建议大写，便于区分

## （2）变量分类

- 用户自定义变量
- 环境变量:这种变量中主要保存的是和系统操作环境相关的数据		         
  - 和系统相关的环境变量名称不可更改，但是用户可以设定环境变量的值，也可以新添加环境变量
- 位置参数变量:这种变量主要是用来向脚本当中传递参数或数据的，变量名不能自定义，变量作用是固定的
- 预定义变量:是Bash中已经定义好的变量，变量名不能自定义，变量作用也是固定的
- 变量的作用范围：配置文件>环境变量>自定义变量

## （3）变量详解

### <1> 本地变量（用户自定义变量）

- 变量定义：例如`name='for you'`的含义就是将字符串'for you'赋给变量name

- 变量叠加：已讲

- 变量调用：例如`echo $name`就是调用变量name

- 变量查看：set命令可以查看系统中所有变量

  ```shell
  set [选项]
  ```

  - `-u`：在调用未声明变量时报错（默认无提示）
  - `-x`：在命令执行前会先把命令输出一次

- 删除变量：例如`unset name`就是输出变量name

### <2> 环境变量

- 环境变量：用户自定义变量只在当前的Shell中生效（本地变量），而环境变量会在当前Shell和这个Shell的所 
                     有子Shell当中生效。如果把环境变量写入相应的配置文件，那么这个环境变量就会在所有的Shell
                     中生效

- 环境变量有一部分固定（名称不可变，可以设置值），有一部分我们可以手动添加

- 设置环境变量：

  - `export 变量名=变量值`或者`export 变量名`：把环境变量声明为全局变量，对所有子Shell都生效

    - 在当前Shell中使用`bash`或`csh`，则进入子Shell
    - 使用pstree命令，可以查看进程树
    - 本地变量只能在当前Shell查看，而环境变量可以在父Shell和子Shell中查看

  - `env`:查看环境变量		

    ```shell
    [dream@172 tmp]$ env    # 查看所有环境变量
    ...
    SHELL=/bin/bash
    ...
    PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/dream/.local/bin:/home/d...
    ```

  - `unset 变量`：删除变量

- 重要的系统环境变量

  - `PATH`：系统查找命令的路径（以:分割）

    ```shell
    [dream@172 tmp]$ echo $PATH
    /usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/dream/.local/bin:/home/dream/bin
    ```

    - 系统在执行我们的命令是是到环境变量下的路径去寻找 			

    - 我们可以将自己写的脚本复制到环境变量下，则可以不写绝对路径来执行该脚本		 

    -  使用变量叠加的命令把自己写的脚本的路径加入环境变量

      ```shell
      [dream@172 sh]$ pwd
      /tmp/sh
      [dream@172 sh]$ ls
      test.sh
      [dream@172 sh]$ PATH="$PATH":/tmp/sh		# 将/tmp/sh临时添加到环境变量PATH中
      [dream@172 sh]$ echo $PATH 
      /usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/dream/.local/bin:/home/dream/bin:/tmp/sh
      [dream@172 sh]$ cd /
      [dream@172 /]$ test.sh				# 直接使用脚本文件名执行，不用加路径
      2020年 02月 24日 星期一 22:51:46 CST
      ```

      - 这种方法是临时生效

  - `PS1`：定义系统提示符的变量（该变量用env看不到，需要用set命令）

    - `\d`:显示日期，格式为“星期 月 日” 

    - `\h`:显示简写主机名。如默认主机名“localhost” 

    - `\t`:显示24小时制时间，格式为“HH:MM:SS” 

    - `\T`:显示12小时制时间，格式为“HH:MM:SS” 

    - `\A`:显示24小时制时间，格式为“HH:MM” 

    - `\u`:显示当前用户名 

    - `\w`:显示当前所在目录的完整名称 

    - `\W`:显示当前所在目录的最后一个目录 

    - `#`:执行的第几个命令

    - `$`:提示符，如果是root用户会显示提示符为“#”，如果是普通用户会显示提示符为“\$”

      ```shell
      [dream@172 tmp]$ PS1='[\u@\w@\d ]\$'	
      # 可以看到命令的提示符改变了
      [dream@/tmp@一 2月 24 ]$		
      ```

  - `LANG语系变量`：LANG变量定义了Linux系统的主语系环境

    ```shell
    [dream@172 /]$ echo $LANG 		# 查看该变量默认值
    zh_CN.UTF-8
    [dream@172 /]$ locale -a 			# 查看Linux系统支持多少种语系
    aa_DJ
    aa_DJ.iso88591
    aa_DJ.utf8
    ...
    [dream@172 /]$ locale -a | wc -l   # 统计以下总共有多少种
    791
    [dream@172 /]$ locale					# 查看当前系统使用的语系
    LANG=zh_CN.UTF-8							# 定义系统主语系的变量
    LC_CTYPE="zh_CN.UTF-8"
    ...
    LC_IDENTIFICATION="zh_CN.UTF-8"
    LC_ALL=												# 定义整体语系的变量
    ```

    - LANG变量定义的语系只对当前系统生效，如果系统重启，则会从默认语系配置文件`/etc/locale.conf`中读取值，然后赋给LANG

      ```shell
      [dream@172 /]$ cat /etc/locale.conf 
      LANG=zh_CN.UTF-8
      ```

    - 在Linux的纯字符界面中若要显示中文，则需要安装中文插件，如`zhcon`























