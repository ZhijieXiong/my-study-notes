[TOC]

# 一、SSH简介

- ssh（Secure Shell）是客户端远程登入服务器进行管理的工具

  - ssh是建立在应用层和传输层基础上的安全协议

  - 以前是使用telnet（明文传输）来远程管理，现在telnet已经被淘汰（不要使用，不安全）

  - ssh使用了加密算法，传递的数据包是密文

- ssh端口
  - 端口号：22
  - Linux守护进程：sshd
  - 安装服务：OpenSSH
  - 客户端主程序：`/usr/bin/ssh`
  - 服务端主程序：`/usr/sbin/sshd`
- 相关配置文件
  - 客户端配置文件：`/etc/ssh/ssh_config`
  - 服务端配置文件：`/etc/ssh/sshd_config`

```shell
[dream@localhost /]$ which sshd
/usr/sbin/sshd
[dream@localhost /]$ which ssh
/usr/bin/ssh
[dream@localhost /]$ ps aux | grep sshd | grep -v grep      # Linux中sshd默认开启
root       1049  0.0  0.2 105996  4080 ?        Ss   16:22   0:00 /usr/sbin/sshd -D                        
[dream@localhost /]$ netstat -tuln | grep :22
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN     
tcp6       0      0 :::22                   :::*                    LISTEN 
```

# 二、SSH加密原理

- ssh使用的非对称加密算法对文件进行加密
  - 客户端会下载服务端的公钥到本地（第一次登入时），传输信息时使用公钥进行加密
  - ssh保护的是文件在网络中的安全

# 三、SSH配置文件

- Linux中ssh配置文件分客户端和服务端，重点是服务端配置文件

- 服务端配置文件：`/etc/ssh/sshd_config`，主要内容如下

## （1）基本配置

- `PORT 22`：默认为22，建议修改，防止被攻击

- `ListenAddress 0.0.0.0`：监听的IP地址（客户端），0.0.0.0表示监听所有IP

- `Protocal 2`：SSH版本，1已被逐渐淘汰

- `HostKey /etc/ssh/ssh_host_rsa_key`：服务器端私钥保存位置

- `ServerKeyBits 1024`：私钥位数

- `SyslogFacility AUTH`：日志记录ssh登入情况（`/var/log/secure`）

- `LogLevel INFO`：日志等级（等级越高，信息越重要）

- `GSSAPIAuthentication yes`：GSSAPI认证，默认开启

  ```shell
  192:~ dream$ cat /etc/ssh/ssh_config | grep GSSAPIAuth
  #   GSSAPIAuthentication no
  ```

  - 开启该认证后，在进行ssh连接时会进行DNS解析，比较消耗时间
  - 建议关闭客户端的GSSAPI认证

## （2）安全设定部分

- `PermitRootLogin yes`：是否允许root用户登入，默认为yes，建议改成no
  - 若允许root登入，且要求使用密码，则密码可能被截获
  - 若使用公钥和私钥的配对来登入，则可以设定不使用密码（密码就不会被截获）
- `PubKeyAuthentication yes`：是否使用公钥验证登入

- `AuthorizeKeysFile .ssh/authenorized_keys`：公钥保存位置
- `PasswordAuthentication yes`：是否允许使用密码登入
  - 设置了使用公钥验证后，建议改成no，防止密码被截获
  - 在未设置公钥验证前，不要改为no，否则客户端无法登入

- `PermitEmptyPassword no`：是否允许使用空密码登入，建议为no

# 四、SSH命令

## 1、远程管理登入

```shell
ssh <用户名>@<服务器IP地址>
```

## 2、ssh远程传输文件命令scp

- 从服务器上下载文件

```shell
scp <用户名>@<服务器IP地址>:<待下载文件> <下载到本地的位置>
```

```shell
dream:~ dream$ scp dream@192.168.1.13:/tmp/test_for_scp.txt /tmp
dream@192.168.1.13's password: 
test_for_scp.txt                              100%    0     0.0KB/s   00:00    
dream:~ dream$ ls /tmp | grep test_for_scp
test_for_scp.txt
```

- 上传文件到服务器

```shell
scp -r <本地文件路径> <用户名>@<服务器IP地址>:<存放到服务器的路径>
```

```shell
dream:~ dream$ scp -r /tmp/test_for_scp22.txt dream@192.168.1.13:/tmp
dream@192.168.1.13's password: 
test_for_scp22.txt                            100%    0     0.0KB/s   00:00
```

## 3、文件传输sftp命令

- 使用sftp命令可以远程传输文件（加密）
- 服务器sftp还是使用的sshd，所以端口号也是22
- 登入sftp服务器命令如下

```shell
sftp <用户名>@<服务器IP地址>
```

```shell
dream:~ dream$ sftp dream@192.168.1.13
dream@192.168.1.13's password: 
Connected to dream@192.168.1.13.
```

- 登入到服务器sftp后，常用命令如下
  - cd：切换服务器端路径
  - ls：查看服务器端文件
  - lcd：切换本地路径
  - lls：查看本地文件
  - get：从服务器端下载文件
  - put：从客户端上传文件

# 五、SSH连接工具

- Linux远程管理Linux服务器使用ssh命令
- Windows远程管理Linux服务器
  - 安装虚拟机，在Linux虚拟机上使用ssh命令
  - 使用ssh远程管理工具
- Windows常用ssh工具
  - SecureCRT（收费）
  - Xshell（有免费版本）

# 六、SSH秘钥对登入

- 提高ssh管理的安全性方法
  - 更改服务器ssh端口号（不够安全）
  - 使用防火墙，禁止非法IP访问（不够灵活）
  - 使用ssh秘钥对登入
- 秘钥对验证
  - 第一步：在客户端本地创建秘钥对，公钥文件为id_rsa.pub，私钥文件为id_rsa
  - 第二步：上传公钥文件id_rsa.pub到服务器
  - 第三步：服务器导入客户端上传到公钥文件到公钥数据库，即`~/.ssh/authorized_keys`下
                    注意，导入到服务器的哪个用户下的数据库中，就得用那个用户登入
  - 第四步：使用秘钥对验证方式登入，就不需要输入密码



- 生成秘钥对

```shell
dream:.ssh dream$ ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/Users/dream/.ssh/id_rsa): 		# 秘钥保存位置
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /Users/dream/.ssh/id_rsa.    # 私钥
Your public key has been saved in /Users/dream/.ssh/id_rsa.pub.		 # 公钥
The key fingerprint is:
SHA256:CQ6zSK4XZB/aF45qRwh8Tgw17q3EnbPqpR/39kcw/oI dream@dream
The key's randomart image is:
+---[RSA 2048]----+
| ..o             |
|. + .            |
|..+=+ o          |
| ***oO.o . o     |
|  *=*=+ S . o    |
| ..+..o    . .   |
|. +..+ .  . o    |
| o .+ o .E . o   |
|  .+..  ....o    |
+----[SHA256]-----+
dream:.ssh dream$ cd ~/.ssh
dream:.ssh dream$ ls
id_rsa		id_rsa.pub	known_hosts
```

- 上传到服务器，导入到公钥数据库中

```shell
dream:.ssh dream$ scp id_rsa.pub dream@192.168.1.13:/tmp
dream@192.168.1.13's password: 
id_rsa.pub                                                                                    100%  393   259.0KB/s   00:00    
dream:.ssh dream$ ssh dream@192.168.1.13
dream@192.168.1.13's password: 
Last login: Mon Feb 10 23:27:37 2020 from 192.168.1.5
[dream@192 ~]$ cd /home/dream/
[dream@192 ~]$ mkdir .ssh
[dream@192 ~]$ cat /tmp/id_rsa.pub >> /home/dream/.ssh/authorized_keys
[dream@192 ~]$ chmod 600 /home/dream/.ssh/authorized_keys		# 更改权限，防止信息泄漏
```

- 更改配置文件

  - `RSAAuthentication yes`：设置使用RSA秘钥
  - `PubkeyAuthentication yes`：使用公钥验证
  - `AuthorizedKeysFile      .ssh/authorized_keys`：设定公钥保存位置
  - `PasswordAuthentication no`：禁止密码登入
  - `StrictModes no`：改为no，否则可能因为某些文件到权限不对而无法登入

- 服务器管关闭SELinux服务

  - SELinux强制要求`authorized_keys`的权限为600
  - 更改配置文件，然后重启系统

  ```shell
  [root@192 ~]# cat /etc/selinux/config 
  
  # This file controls the state of SELinux on the system.
  # SELINUX= can take one of these three values:
  #     enforcing - SELinux security policy is enforced.
  #     permissive - SELinux prints warnings instead of enforcing.
  #     disabled - No SELinux policy is loaded.
  #SELINUX=enforcing
  SELINUX=disabled					# 改为disabled
  # SELINUXTYPE= can take one of three two values:
  #     targeted - Targeted processes are protected,
  #     minimum - Modification of targeted policy. Only selected processes are protected. 
  #     mls - Multi Level Security protection.
  SELINUXTYPE=targeted 
  ```

- 重启sshd服务

```shell
[root@192 ~]# service sshd restart
Redirecting to /bin/systemctl restart sshd.service
```

