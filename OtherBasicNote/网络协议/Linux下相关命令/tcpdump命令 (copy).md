

[TOC]

# 1、tcpdump介绍

- tcpdump是Linux下的抓取网络数据包的命令，可以根据根据使用者的定义对网络上的数据包进行截获
- 通常，直接启动tcpdump将监视第一个网络接口上所有流过的数据包
- 命令`tcpdump -i <nid_name>`可以指定网络接口设备
- 使用快捷键`Ctrl+F`或者`Command+F`可以进行关键字搜索

# 2、tcpdump命令语法解释

- `tcpdump`可以打印那些和我们设定的布尔表达式匹配的数据包里的内容，数据包的来源可以是网络接口（也就是监听某个接口），也可以是文件（如wireshark抓取的数据包文件），该命令还可以将数据包存入指定文件中，以便后续处理（比如使用wireshark处理）
- 使用`man tcpdump`可以查看该命令的用法，下面来解释这个命令的语法

```shell
tcpdump [ -AbdDefhHIJKlLnNOpqStuUvxX]  # 这一部分是可加的选项
							 [ -B buffer_size ]  # 设定抓取的缓存大小（以KB为单位）
               [ -c count ]  # 设定抓取的数据包的个数，如果不使用该选项，则不会自动退出（可以使用		
               							 # Ctrl+c退出，或者杀死进程）
               [ -C file_size ]  # 设定数据包的大小，超过设定的大小的数据包不打印（以10^6字节为单位）
               [ -G rotate_seconds ] 
               [ -F file ]  # 用指定文件里的内容作为表达式，使用此选项后，命令行上所给出的表达式被忽略           
               [ -i interface ]  # 指定用于抓包的网络接口
               									 # -i pktap,if1,if2表示同时抓取if1和if2的数据包
               									 # 使用-i any或-i all或-i pktap,all表示抓取所有网络接口的数据包内容
               									 # 不加该参数时，使用伪接口抓取（不包括环回网卡和隧道接口）
               [ -j tstamp_type ]  # 指定时间戳的格式
               [ -m module ] 
               [ -M secret ]
               [ --number ] 
               [ -Q|-P in|out|inout ]
               [ -r file ]  # 读取指定文件里的数据包内容 
               [ -V file ]  # 和-r作用一样，但是可以读取多个文件
               [ -s snaplen ] 
               [ -T type ] 
               [ -w file ]  # 将数据包写入指定文件里
               [ -W filecount ]
               [ -E spi@ipaddr algo:secret,...  ]  # 与加密有关
               [ -y datalinktype ] 
               [ -z postrotate-command ] 
               [ -Z user ]
               [ --time-stamp-precision=tstamp_precision ]
               [ --immediate-mode ] 
               [ --version ]
               [ expression ]
```

## （1）选项解释

- `-A`    抓取所有数据包，方便抓取网页
- `-b`    在BGP（外部网关协议，一种路由算法）的数据包中使用ASDOT符号来打印AS（自治系统）的号码
- `-d`    以可读的形式打印数据包的内容
  - `-dd`     以c语言的形式打印数据包的内容
  - `-ddd`    以十进制的形式打印数据包的内容
- `-D`    等于`--list-interfaces`，即列出操作系统上的网络接口，并指明哪个接口用于抓包
- `-e`    打印链路层的头部内容
- `-f`    用数字（即IP地址）显示外网的网络地址
- `-h`    打印`--help`
- `-H`    尝试检测802.11s草稿网格头（我也不懂什么意思，802.11是无线局域网通用的标准）
- `-I`    指定为监控模式（仅对802.11WiFi网络接口及部分操作系统生效），使用该选项后，被监控的接口
                       不可用，将阻止其它主机的访问和主机名的解析
- `-J`    列出网络接口可用的时间戳格式，还可以指定时间的精确度（微秒级和纳秒级）
- `-K`    
- `-l`
- `-L`
- `-n`
- `-N`
- `-O`
- `-p`
- `-q`
- `-S`
- `-t`
- `-u`
- `-U`
- `-v`
- `-x`
- `-X`    将数据包的内容用16进制显示出来

## （2）表达式解释

- `expression`由基本表达式（也可以用关键词指明）和关系表达式组成

### <1>关系表达式

- 关系表达式和编程中的关系表达式类似，是一种逻辑匹配
  - `or`    表示“或”
  - `and`    表示“且”
  - `not`    表示“非”
  - `=`    表示“等于”
  - `!=`    表示“不等于”
  - `&&`    表示“逻辑与”，同`and`
  - `||`    表示“逻辑或”，同`or`
  - `!`    表示“逻辑非”，同`not`

### <2>基本表达式

- 基本表达式由type（类型）、dir（方向）、proto（协议）三部分组成

- `type`    包括host、net、port、portrange，不指定类型时默认匹配所有IP地址

  - `host`    指定主机，可以用主机名，也可以用IP地址

    ```shell
    tcpdump host 192.168.1.10 or host 192.168.1.7
    # 这个表示同时抓取两个IP地址的数据包
    
    tcpdump "ip[16]==192 and ip[17]==168 and ip[18]==1 and (ip[19]>9 and ip[19]<101)"
    # 这个表示抓取目的ip地址范围为192.168.1.10～192.168.1.100的数据包
    # ip[16]==192表示ip数据报首部第16个字节（即目的IP地址的第一个字节）为192
    
    tcpdump "icmp[0]==0 or icmp[0]==8"
    # 表示抓取icmp报文且icmp数据报首部第一个字节为0或8的数据包（即回送/请求类型icmp报文）
    ```

  - `net`    指定网络，可以有以下几种形式

    ```shell
    tcpdump net 192.168.1
    # 指定网络号（发送或接收）为192.168.1，也可以是IPv6的形式
    
    tcpdump net 192.168.1.0 mask 255.255.255.0
    # 效果同上
    
    tcpdump net 192.168.1.0/24
    # 效果同上
    ```

  - `port`    指定端口

    ```shell
    tcpdump dst port 80
    # 指定抓取目标端口号为80（包括tcp和udp）的数据包
    
    tcpdump tcp dst port 80
    # 指定tcp端口为80的数据包
    ```

  - `portrange`    指定一个端口范围

    ```shell
    tcpdump src portrange 2000-3000
    # 指定抓取源端口号2000~3000的数据包（同样也包括tcp和udp）
    ```

- `dir`    指定方向，常用的就是源（src）和目的（dst），当不指定方向时，愿或者目的都匹配

  - `src`    指定发送方的信息

  - `dst`    指定接收方的信息

  - 后面可以跟任意的`type`

    ```shell
    tcpdump src 192.168.1.7 and dst 112.80.248.75
    # 指定抓取源IP地址为192.168.1.7和目的IP地址为112.80.248.75之间通信的数据包
    ```

  - `ra, ta, addr1, addr2, addr3, addr4`    这几个只对IEEE 802.11 （无线局域网链路层）的数据包生效

- `proto`    指定协议，包括ether、fddi、tr、wlan、ip、ip6、arp、rarp、decnet、tcp、udp

  - `ether`    指定数据链路层使用的是以太网协议的数据包
  - `fddi、tr、wlan`    都是`ether`的别名
  - `ip`    使用的是IPv4的数据包
  - `ip6`    使用的是IPv6的数据包
  - `decent`

## （3）关键词

- 关键词：和基本表达式作用类似
  - `if`    interface name，网络接口名字
  - `proc`    process name
  - `pid`    process id
  - `svc`    service class，服务类型
  - `dir`    direction，方向
  - `eproc`    effective process name
  - `epid`    effective process id

# 3、tcpdump简单使用

- 先看一下tcpdump的输出

```shell
dream:~ dream$ tcpdump -i en4 host 192.168.1.9 and 153.37.235.5		
# 该命令是只抓取en4上的192.168.1.9和153.37.235.5通信的数据包
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on en4, link-type EN10MB (Ethernet), capture size 262144 bytes
23:48:03.741911 IP 192.168.1.9 > 153.37.235.5: ICMP echo request, id 24627, seq 0, length 64
23:48:03.776818 IP 153.37.235.5 > 192.168.1.9: ICMP echo reply, id 24627, seq 0, length 64
^C
2 packets captured
144 packets received by filter
0 packets dropped by kernel
```

- tcpdump输出解释

  - `23:48:03.741911 `    系统时间
  - `IP 192.168.1.9 > 153.37.235.5`    源IP地址和目的IP地址
  - `ICMP echo request, id 24627, seq 0, length 64`    表示和协议相关内容
    - `ICMP echo request`    表示这是一个ICMP数据包，类型是echo request（即ping的请求数据）
    - `id 24627, seq 0, length 64`    数据包的一些具体信息


## （1）指定源IP地址和目的IP地址

```shell
dream:~ dream$ tcpdump -i en4 src host 192.168.1.9 and dst 153.37.235.5
```

## （2）指定通信双方端口号

```shell
dream:~ dream$ tcpdump -i en4 -X udp port 53 
```

# 4、tcpdump进阶使用

## （1）抓取本地网络的数据包

```shell
dream:~ dream$ sudo tcpdump -X src or dst net 192.168.1.0/24   
```

- 该命令效果是监视网络`192.168.1.0/24`的所有数据包













参考：

- https://blog.csdn.net/leeshuheng/article/details/7729514