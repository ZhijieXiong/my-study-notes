[TOC]

# 1、Linux的IP地址配置

- Linux配置IP地址的方法
  - ifconfig命令临时配置
  - setup工具永久配置IP地址
  - 修改网络配置文件
  - 图形界面修改IP地址

## （1）ifconfig

- ifconfig：查看与配置网络状态命令
  - `eth0`    Ethernet（以太网）：网卡标志，同理eth1、eth2···也是（在CentOS中是ens33）
  - `lo`      local loopback（本地回环网卡）
    - 所有计算机都有，且IP地址都为127.0.0.1，仅代表localhost
    - 如果ping该ip没有问题，说明tcp/ip协议安装没有问题，但不能说明计算机已经连入网络
- 使用ifconfig配置IP地址
  - `ifconfig eth0 [IP地址] netmask [子网掩码]`（netmask可以省略）
  - `ifconfig eth0:0 [IP地址]`：虚拟一个假的网卡，一块网卡可以绑多个IP（只有一个生效）
  - `ifconfig eth0:0 down`：取消配置（使用up可以重新生效）

## （2）修改网络配置文件

- setup命令本质上也是通过相关网络配置文件来配置IP地址

- `/etc/sysconfig/network-scripts/ifcfg-eth0`

  ```shell
  [dream@localhost network-scripts]$ cat ifcfg-ens33 
  TYPE=Ethernet			# 类型是否是以太网
  PROXY_METHOD=none
  BROWSER_ONLY=no
  BOOTPROTO=dhcp			 # 是否自动获取IP（none、static、dhcp，dhcp为自动获取IP）
  DEFROUTE=yes
  IPV4_FAILURE_FATAL=no
  IPV6INIT=yes			# IPv6是否启动
  IPV6_AUTOCONF=yes
  IPV6_DEFROUTE=yes
  IPV6_FAILURE_FATAL=no
  IPV6_ADDR_GEN_MODE=stable-privacy
  NAME=ens33
  UUID=ee1fc2aa-6a56-438b-a0ca-b60ef9f1fed8			# 唯一识别码，两台设备UUID相同时，不能上网
  DEVICE=ens33			# 网卡设备名											
  ONBOOT=no			# 是否随网络服务启动，eth0生效（如果为no，则IP不生效）		
  ```

  - `HWADDR=00:5f:24:a3:12:09`：MAC地址		

  - `NM_CONTROLLED=yes` ： 是否可以由Network Manager图形管理工具托管		

  - `USERCTL=no`：非root用户不能控制此机
  - `IPADDR`：IPv4地址

- 主机名配置
  - `/etc/sysconfig/network`：主机名文件
    - `NETWORKING=yes`：网络服务是否工作
    - `HOSTNAME=localhost.localdomain` ：主机名（Linux下都相同）
  - `hostname`命令查看主机名：`hostname [主机名]`  临时修改主机名
- DNS配置文件`/etc/resolv.conf`
  - `nameserver [DNS地址]`

# 2、Linux常用网络命令

[Linux网络命令](../Linux命令/网络命令)

# 3、虚拟机网络配置

- 第一步：配置IP地址

  - setup配置或修改配置文件
  - 重启网络：`service network restart`
  - 例子如下：此时物理机IP地址为192.168.1.8 

  ```
  [dream@localhost network-scripts]$ sudo ifconfig ens33 192.168.1.10 netmask 255.255.255.0
  [sudo] dream 的密码：
  [dream@localhost network-scripts]$ ifconfig
  ens33: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
          inet 192.168.1.10  netmask 255.255.255.0  broadcast 192.168.1.255
          ...
  
  lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
          inet 127.0.0.1  netmask 255.0.0.0
          ...
  
  virbr0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
          inet 192.168.122.1  netmask 255.255.255.0  broadcast 192.168.122.255
          ...
  [dream@localhost network-scripts]$ ping 192.168.1.8
  PING 192.168.1.8 (192.168.1.8) 56(84) bytes of data.
  64 bytes from 192.168.1.8: icmp_seq=1 ttl=64 time=0.643 ms
  64 bytes from 192.168.1.8: icmp_seq=2 ttl=64 time=0.417 ms
  64 bytes from 192.168.1.8: icmp_seq=3 ttl=64 time=0.471 ms
  ^C
  --- 192.168.1.8 ping statistics ---
  3 packets transmitted, 3 received, 0% packet loss, time 2001ms
  rtt min/avg/max/mdev = 0.417/0.510/0.643/0.098 ms
  
  ```

- 虚拟机网络设置
  - 桥接：直接桥接到真实网卡（有线/无线），占用真实IP地址，此时虚拟机可以和局域网内其它主机通信
  - NAT：转换物理机的IP地址
    - 若物理机连接到互联网，则虚拟机也可以上网
    - 使用NAT模式，虚拟机不能和局域网上其它主机通信
  - host-only：类似NAT
    - 只能和物理机通信，不能上网
    - 使用host-only模式，虚拟机同样不能和局域网上其它主机通信
- 复制镜像（即克隆虚拟机）时，需要修改UUID

