[TOC]

# 1、防火墙简介

- 防火墙功能：限制访问（限制mac、IP、port），限制访问数量，给数据包打标签，控制网速，统计流量等
                                            即过滤数据包

- 防火墙分类：硬件/软件防火墙， Linux中的防火墙偏硬件（因为是调用系统内核使用的）
- Linux（CentOS）中的防火墙：iptables、firewall、SELinux
  - Linux是通过iptables（firewall也是基于iptables的）向内核写入规则
  - 也就是说Linux下的防火墙分为内核态和用户态
    - 内核态：`netfilter`
    - 用户态：`iptables | firewall`，为指令集

# 2、iptables

## （1）基本使用

- 安装

```shell
yum install iptables.x86_64 iptables-devel.x86_64 iptables-services.x86_64 -y
```

- 启动iptables的方法

```shell
systemctl start iptables
```

- 使用
  1. 查看防火墙规则：`iptables -L`
  2. 清除所有防火墙规则：`iptables -F`

## （2）防火墙的基本原理（Linux下）

- 防火墙就是对指定条件的数据包作出指定动作，包括不限于过滤
- Linux下，通过iptables命令将规则写入内核态，当有数据包进入或出去时，就会和我们所写的规则一条条去匹配，若匹配到特定条件的规则，则按该规则所指定的动作执行；若未匹配到特定条件，则按默认规则处理
- iptables定义的规则
  - 表：定义的规则放到表里，有4张表
    - `raw`    数据包跟踪
    - `mangle`    标记数据包（只标记，不做其它动作）
    - `nat`   网络地址转换，用于修改源地址和目的地址
    - `filter`    数据包过滤
  - 链：链里放的是具体的规则，一张最多有5种链
    - `PREROUTING`    路由之前（即针对的是路由之前的数据包）
    - `INPUT`    数据包流入网卡
    - `FORWARD`    数据包流经网卡
    - `OUTPUT`    数据包流出网卡
    - `POSTROUTING`    路由之后
  - 匹配条件时按顺序匹配(`raw`-->`mangle`-->`nat`-->`filter`，链也是从上到下按顺序匹配)

## （3）iptables的语法规则

- 规则分为增删改查四种类型
- 语法模版：`iptables [-t table_name] <动作> <链名> <匹配条件> <目标动作>`

### <1>查看规则

- 查看防火墙规则

  - `iptables -L`    查看4张表的全部规则

  - `iptables -L -t table_name`    查看指定表的规则

  - `iptables -nL`    把所有主机名用IP地址表示

  - `iptables -S [-t table_name]`    直接查看创建规则时的命令

    ```shell
    [root@192 ~]# iptables -L -t filter 
    Chain INPUT (policy ACCEPT)
    target     prot opt source               destination         
    
    Chain FORWARD (policy ACCEPT)
    target     prot opt source               destination   
    ...
    
    [root@192 ~]# iptables -S -t filter 
    -P INPUT ACCEPT
    -P FORWARD ACCEPT
    ...
    ```

### <2>添加规则

- 增加规则：`-A`（add）或`-I`（insert）

  - 在指定表的最后面增加一条规则（若没有`-t table_name`，默认为filter表）

    ```shell
    iptables -t filter -A INPUT -p icmp -s IP -j REJECT
    ```

    - `-A`    表示动作为添加规则
    - `INPUT`    表示添加的规则是针对INPUT链的（即进入网卡的数据包）
    - `-p icmp -s IP`    匹配的条件
      - `-p icmp`    表示使用的协议是ICMP协议的（协议是protocol）
      - `-s IP`    表示指定源IP地址（源地址是source IP）
    - `-j REJECT`    表示拒绝匹配到的数据包（jump有快速行动的意思）
    - 该命令的效果是拒绝指定IP地址的主机ping本机

  - 在一张表中指定链的指定位置插入规则

    ```shell
    iptables [-t table_name] -I [n] <链名> <匹配条件> <目标动作>
    ```

    - `-I [n]`    不加n时，是在指定表的指定链的最前面加入规则，使用n可以指定添加到第n条
    - 同理，删除时也可以指定删除，如`iptables -D INPUT 3`表示删除filter表的INPUT链的第3条规则

  - 自定义链：非自定义链（即那5个链）是即写即生效的，而自定义链写好后要被调用才生效

    - 创建自定义链

      ```shell
      iptables -N <chain_name>
      ```

      - 若要更改自定义链的名字，使用命令`iptables -E <old_name> <new_name>`
      - 创建后就可以往自定义链里写规则了

    - 调用自定义链，即将自定义链添加到5条链中去

      ```shell
      iptables -t filter -A INPUT -j test
      ```

      - 该命令是将自定义链test添加到filter表的INPUT链中去

    - 删除自定义链：注意，被调用的自定义链和写了规则的自定义链不能删除

      ```shell
      iptables -X <chain_name>
      ```

### <3>更改规则

- 不常用，比较麻烦，一般先删除再添加即可

  ```shell
  iptables [-t table_name] -R n <chain_name> <匹配条件> <目标动作>`
  ```

  - R是replace的意思
  - `-R n`     表示修改指定表中的指定链的第n条规则

### <4>删除规则

- 删除所有规则：`iptables -F`
- 删除指定链的规则：`iptables -F <chain_name>`
- 删除指定链的指定行：`iptables -D INPUT 3`表示删除filter（默认）的INPUT链的第3条规则

### <5>关于默认规则

- 所有数据包都会经过防火墙，当数据包匹配到了特点规则时，就按指定的动作执行；当未匹配到特点规则时，就按默认动作（规则）执行。默认规则只有`ACCEPT`和`DROP`

- 查看一下默认规则

  ```SHELL
  [root@192 ~]# iptables -L
  Chain INPUT (policy ACCEPT)
  target     prot opt source               destination 
  ...
  ```

  - 可以看到这条INPUT链的默认规则时ACCEPT

- 修改默认规则

  ```shell
  iptables -P INPUT DROP
  ```

  - 该命令是将INPUT链的默认规则都改为DROP（丢弃）

### <6>补充

- iptables还可以查看流量

  ```shell
  iptables -nL -v
  # 查看流量
  iptables -Z [chain_name n]
  # 清空流量，可以指定链和链中第n条规则的流量
  ```

## （4）iptables的匹配条件

- iptables可以匹配的条件非常多，可以在需要的时候查看手册，如查看设定一个范围的IP地址的用法

  ```shell
  [dream@192 ~]$ iptables -m iprange --help
  [dream@192 ~]$ iptables -m iprange --help
  iprange: Could not determine whether revision 1 is supported, assuming it is.
  iptables v1.4.21
  ...
  iprange match options:      # 这就是iprange的用法
  [!] --src-range ip[-ip]    Match source IP in the specified range
  [!] --dst-range ip[-ip]    Match destination IP in the specified range
  ```

  - `-m range`    m表示match，即扩展匹配
  - 另外可以使用命令`man iptables -extensions`查看所有用法

- iptables有三个基本匹配条件：IP地址，协议protocol，端口port

  - IP地址匹配

    ```shell
    -s IP_address[/mask] [, IP_address[/mask], ...]  # 指定源IP地址，可以同时指定多个
    -d IP_address[/mask] [, IP_address[/mask], ...]  # 指定目的IP地址，可以同时指定多个
    ```

    - `-s --source`    `-d --destination`
    - `mask`    即子网掩码，可写可不写，可以写出数字，也可以写成掩码，如`24 = 255.255.255.0`
    - 也可以指定一个IP范围，如`-m iprange --src-range 192.168.1.1-192.168.1.10`表示匹配条件为源IP地址在指定范围内

  - 端口匹配

    ```shell
    -sport port_num     # 匹配源端口（source port）
    -dport port_num			# 匹配目的端口（destination port）
    ```

    - 也可以多端口匹配

      ```shell
      [dream@192 ~]$ iptables -m multiport --help
      multiport: Could not determine whether revision 1 is supported, assuming it is.
      iptables v1.4.21
      ...
      multiport match options:
      [!] --source-ports port[,port:port,port...]
       --sports ...
      				match source port(s)
      [!] --destination-ports port[,port:port,port...]
       --dports ...
      				match destination port(s)
      [!] --ports port[,port:port,port]
      				match both source and destination port(s)
      ```

    - 例子：

    ```shell
    [dream@192 ~]$ sudo iptables -A INPUT -p tcp -m multiport --dports 22,21,80 -j REJECT
    [sudo] dream 的密码：
    [dream@192 ~]$ sudo iptables -L
    Chain INPUT (policy ACCEPT)
    target   prot   opt   source     destination         
    REJECT   tcp    --    anywhere   anywhere       multiport dports ssh,ftp,http reject-with icmp-port-unreachable
    ```

## （5）iptables的目标动作

- 当匹配到了条件后，就要执行特定的动作

- 常用的动作如下

  - `DROP`    丢弃

  - `REJECT`    拒绝

  - `ACCEPT`    接收

  - `SNAT`    修改源IP地址，必须按如下格式书写

    ```shell
    iptables -t nat -A POSTROUTING -s <old_IP> -j SNAT  <old_IP> to <new_IP> 
    ```

    - 理解：计算机只能修改已经路由后，准备发出去的数据包的源IP（如果修改目标IP，就找不到了）

      ​            机理和网络地址转换协议NAT是一样的

  - `DNAT`     修改源目标P地址，必须按如下格式书写

    ```shell
    iptables -t nat -A PREROUTING -d <old_IP> -j DNAT  <old_IP> to <new_IP> 
    ```

    - 理解：计算机只能修改路由前，刚收到的数据包的目标IP，机理同NAT协议

  





