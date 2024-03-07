[TOC]

# 一、DHCP简介和原理

- DHCP（Dynamic Host Configuration Protocol）作用
  - 为大量客户机自动分配地址，提供集中管理
  - 减轻管理和维护成本，提高网络配置效率
- 可分配的地址信息如下
  - IP地址，子网掩码
  - 对应的网络地址，广播地址
  - 默认网关地址
  - DNS服务器地址
  - 引导文件、TFTP服务器地址
- DHCP服务器一般要求和客户机在同一网段，才可以分配地址，若不在同一网段，则要用到中继
- DHCP的原理
  1. 客户端寻找服务器
     - 客户端在局域网上广播寻找DHCP服务器
     - Win7以前以及Linux若找不到DHCP服务器，则会每隔一段时间就广播一次
     - Win7以后若找不到DHCP服务器，则会自动配置一个假IP（169.254.···）
     - 若在局域网内有多台DHCP服务器，则客户机会选择响应最快的服务器
  2. 服务器提供地址信息
     - 服务器监听到请求以后，回复OFFER数据包给客户端
     - OFFER数据包只有服务器的IP地址
  3. 客户端接受并广播
     - 客户端收到服务器发送到OFFER数据包后，在局域网上广播REQUEST数据包
  4. 服务器接受并确认
     - 服务器向客户端发送ACK数据包（里面有各种地址信息）
  5. 客户端关机后重新登入或IP地址租约到期后重新申请
     - 在客户端本地已经有DHCP服务器的地址，直接向服务器发送REQUEST请求
  6. 服务器确认
     - 若服务器确认IP地址未被其他人使用，则回复ACK数据包
- DHCP租约
  - DHCP服务器分配的IP地址是有时间限制的，假设为n天
  - 在使用了IP地址时间为n/2天时，客户端会询问服务器是否能增加IP使用时间
  - 服务器正常，则一般会延长客户端使用IP的时间
  - 服务器出问题，则客户端会在3n/4天时间再询问一次，若还是没有回应，客户端会在IP地址使用时间到期后，重新寻找DHCP服务器

# 二、相关文件

- dchp端口号
  - IPv4：udp67、udp68
  - IPv6：udp546、udp547
- 服务名：`dhcpd`
- 主配置文件：`/etc/dhcpd/dhcpd.conf`

```shell
[root@192 dhcp-4.2.5]# cat /etc/dhcp/dhcpd.conf 
#
# DHCP Server Configuration file.
#   see /usr/share/doc/dhcp*/dhcpd.conf.example
#   see dhcpd.conf(5) man page
#
```

- 模版文件：`/usr/share/doc/dhcp-4.2.5/dhcpd.conf.example `

  - 可以直接将模版文件复制到主配置文件，即可生效

  ```shell
  [root@192 /]# cp /usr/share/doc/dhcp-4.2.5/dhcpd.conf.example /etc/dhcp/dhcpd.conf 
  cp：是否覆盖"/etc/dhcp/dhcpd.conf"？ y
  ```

# 三、配置文件主要内容

- `option domain-name "example.org";`：dhcp服务器的域名
- `option domain-name-servers ns1.example.org, ns2.example.org;`：使用的DNS域名，如8.8.8.8
- `default-lease-time 600;`：默认dhcp租约时间，单位为s
- `max-lease-time 7200;`：最大dhcp租约时间
- `#authoritative;`：标识为权威服务器，即局域网内有多台dhcp服务器时，权威服务器优先去分配地址，以
                                      防止IP地址混乱（局域网内不要搭建实验dhcp服务器）

# 四、配置服务器

## （1）配置服务器端

- 修改配置文件

  - 修改DNS域名：常用的有8.8.8.8，202.106.0.20
  - 配置子域：选择一个subnet进行配置，其它可以删除

  ```shell
  # A slightly different configuration for an internal subnet.
  subnet 192.168.1.0 netmask 255.255.255.0 {							  # 必须和dhcp服务器在同一网段
    range 192.168.1.50 192.168.1.100;											  # 设置分配的IP地址范围
  #  option domain-name-servers ns1.internal.example.org;		# 已配置
  #  option domain-name "internal.example.org";
    option routers 192.168.1.1;															# 设置网关
    option broadcast-address 192.168.1.255;									# 设置广播地址
    default-lease-time 600;
    max-lease-time 7200;
  }
  ```

  - `host fantasia`可删除（实验，只有一台主机请求IP）

- 重启服务

```shell
service dhcpd restart
```

## （2）配置客户端

- 修改配置文件：`/etc/sysconfig/network-scripts/ifcfg-eth0`，改为下面4句即可

```shell
TYPE=Ethernet			# 类型是否是以太网
BOOTPROTO=dhcp			 # 是否自动获取IP（none、static、dhcp，dhcp为自动获取IP）
DEVICE=ens33			# 网卡设备名											
ONBOOT=no			# 是否随网络服务启动，eth0生效（如果为no，则IP不生效）
```

- 重启网络服务

```shell
service network restart
```

## （3）查看租约信息

- 服务器端查看：`/var/lib/dhcpd/dhcpd.leases`
- 客户端查看：`/var/lib/dhclient`