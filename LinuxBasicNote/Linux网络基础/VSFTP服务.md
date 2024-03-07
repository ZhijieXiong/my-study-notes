[TOC]

# 一、FTP简介与原理

- ftp协议（File Transfer Protocol）
  - ftp是C/S结构，即分客户端和服务端，它用于共享文件，主要是针对企业
  - ftp和个人的文件传输（如qq、网盘）最大区别在于，使用FTP共享的文件是有权限的
  - ftp可以用于Internet上的控制文件的双向传输
    - 下载：从远程主机拷贝文件到自己的计算机上
    - 上传：将文件从自己的计算机上拷贝到远程主机上
- ftp工作模式
  - 主动模式：服务端主动向客户端发起连接，服务器连接的端口为20端口
    1. 服务器监听21端口，等待客户端登入ftp服务器
    2. 客户端通过服务器的21端口登入服务器成功后，客户端随机开放一个端口
    3. 客户端通过port命令将开启的随机端口号发给服务器，告诉服务器准备连接
    4. 服务器得到客户端的端口号后，***主动***通过20端口和客户端连接
  - 被动模式：服务器在指定范围内的端口被动等待客户端连接
    1. 服务器监听21端口，等待客户端登入ftp服务器
    2. 客户端登入成功后，向服务器发送pasv命令
    3. 服务器收到客户端的pasv命令后，随机开启一个端口，并将该端口号发给客户端
    4. 客户端也随机开启一个端口，并连接服务器的随机端口
    5. 服务器是开启一个随机端口后，***被动***等待客户端连接
  - 主动模式和被动模式比较
    - 被动模式优于主动模式
    - 主动模式是服务器主动连接客户端，因此服务器发送的连接可能被客户端的防火墙屏蔽掉
    - 而被动模式下，只要工程师配置好ftp服务器，连接就不会因为防火墙问题而中断

- ftp连接端口
  - tcp21：用于传送ftp命令信息
  - tcp20：用于上传或下载文件

# 二、相关文件

- 常见的ftp服务器程序
  - Windows：IIS、Serv-U
  - Linux：wu-ftpd（已淘汰）、Proftpd、vsftpd（Very Secure FTP Daemon） 

- 相关文件

  - 主配置文件：`/etc/vsftpd/vsftpd.conf`
  - 用户控制列表文件（即黑名单文件）
    - `/etc/vsftpd/ftpusers`：ftp默认禁止以root用户登入
    - `/etc/vsftpd/user_list`
    - 默认情况下，user_list是黑名单，但是可以通过修改配置文件，将user_list改为白名单
    - ftpusers文件优先级更高

- ftp相关用户

  - 匿名用户
    - 用户名为anonymous或ftp，匿名用户密码为空，或为邮箱
    - 匿名用户不安全，建议ftp服务器禁止匿名用户登入
  -  本地用户
    - 即Linux系统用户，用户名和密码与系统相同
    - 本地用户也有安全隐患，如果本地用户密码泄漏，则攻击者可以使用该用户登入Linux服务器
  - 虚拟用户
    - 即该用户与系统无关，只能登入ftp服务器
    - 虚拟用户安全级别最高

- 实验时注意事项，否则可能实验不成功

  - 关闭防火墙

    - 方法一：使用setup工具
    - 方法二：使用命令`iptables -F`，该命令是临时的，再使用`service iptables save`保存状态
  - 方法三：Centos7中用`systemctl status firewall.service`查看防火墙状态
      - `systemctl stop firewall.service` 关闭防火墙
    - `systemctl status firewall.service`永久关闭防火墙
  
- 关闭SELinux
  
    - 查看SELinux状态
  
    ```shell
  [dream@192 ~]$ sestatus
    SELinux status:                 disabled
  ```
  
    - 关闭SELinux方法
  
    ```shell
    [dream@192 ~]$ setenforce 0
    # 或者修改配置文件`/etc/selinux/config`
    ```

# 三、配置文件详解

- ftp的默认配置文件只有基本功能，有些功能需要手动添加

- `/etc/vsftpd/vsftpd.conf`主要内容

  - 默认配置内容

  ```shell
  anonymous_enable=YES		# 允许匿名用户登入
  local_enable=YES				# 允许本地用户登入			
  write_enable=YES				# 允许本地用户上传
  local_umask=022					# 本地用户上传umask值
  anon_upload_enable=YES  # 下面这两个是与匿名用户有关的，默认关闭
  anon_mkdir_write_enable=YES
  dirmessage_enable=YES		# 用户进入目录时，显示的信息
  message_file=.message		# 显示信息所在的文件
  xferlog_enable=YES			# 激活ftp日志记录
  xferlog_std_format=YES  # 使用标准ftp日志格式
  connect_from_port_20=YES		# 设置主动模式传输数据的端口为20
  ftpd_banner=Welcome to blah FTP service.			# 欢迎信息
  listen=YES							# 是否允许被监听，默认端口为21
  pam_service_name=vsftpd	# ftp使用pam验证，即ftp使用默认用户名和默认密码
  userlist_enable=YES			# 用户登入限制，光开启这个没有用
  tcp_wrappers=YES				# 是否使用tcp_wrappers作为主机控制访问方式
  ```

  - umask讲解
    - umask确定文件权限，用默认最大权限与umask相减，得到的结果即为文件权限
    - 例如：umask为022，文件默认最大权限为666，相减后为644，即该文件权限为644（rw-r--r--）

  

  - 全局配置内容（默认配置中没有，需要手动添加）

  ```shell
  listen_address=192.168.1.5			# 设置监听的IP地址，即只允许该IP地址连接
  listen_port=21									# 设置监听ftp服务的端口，可改
  download_enable=YES							# 是否允许下载文件
  max_client=0										#	限制并发客户端连接数
  max_per_ip=0										# 限制同一IP的并发连接数
  ```

  - 开启被动模式

  ```shell
  pasv_enable=YES					# 开启被动模式
  pasv_min_port=10000			# 被动模式最小端口
  pasv_max_port=15000			# 被动模式最大端口
  ```

  - 常用安全配置

  ```shell
  accept_timeout=60       		  # 被动模式，连接超时时间
  connect_timeout=60					  # 主动模式，连接超时时间
  idle_session_timeout=600		  #	600秒没有任何操作就断开连接
  data_connection_timeout=500   # 资料传输超过500秒，就断开传输
  ```

# 四、客户端使用

- ftp服务器默认使用系统用户登入，且为明文传输

- ftp使用命令行连接

  - ftp命令行不能下载文件夹，只能下载文件，也不支持断点续传

  ```shell
  ftp <服务器IP地址>
  ```

  - `help`：获取帮助信息
  - `get`：下载文件，默认下载到客户端登入ftp的位置
  - `mget`：下载一批文件
  - `put`：上传文件
  - `mput`；上传一批文件
  - `exit`：退出

- 使用第三方工具，若第三方工具支持断点续传，则可以断电续传

# 五、匿名用户使用

- 不推荐使用匿名用户，安全性低
- 匿名用户登入用户名为`anonymous`，密码为空 
- ftp匿名用户映射到系统上的用户为ftp的伪用户，可以在`/etc/passwd`查看

```shell
[dream@192 桌面]$ cat /etc/passwd
root:x:0:0:root:/root:/bin/bash
...
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
..
sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin
...
dream:x:1000:1000:dream:/home/dream:/bin/bash
dhcpd:x:177:177:DHCP server:/:/sbin/nologin
```

- 匿名用户配置如下

```shell
anonymous_enable=YES
anon_upload_enable=YES						# 允许匿名用户上传文件
anon_mkdir_write_enable=YES				# 允许匿名用户建立目录 
anon_umask=600			
```

- 匿名用户可能不能上传文件，因为ftp设置的权限和Linux系统的权限是同时生效的，系统设定ftp用户对匿名用户的家目录（匿名用户的家目录为`/var/ftp`）没有写权限，正确操作如下

  ```shell
  [dream@192 桌面]$ cd /var/ftp
  [dream@192 ftp]$ ls						# pub目录是专门给匿名用户使用的
  pub
  [dream@192 ftp]$ ll -d pub
  drwxr-xr-x 2 root root 6 10月 31 2018 pub
  [dream@192 ftp]$ sudo chown ftp pub		# 更改pub目录的所有者，则ftp匿名用户可以有rwx权限
  [sudo] dream 的密码：
  [dream@192 ftp]$ ll -d pub
  drwxr-xr-x 2 ftp root 6 10月 31 2018 pub
  ```

# 六、本地用户访问

## （1）基本设置

- 本地用户访问使用的是系统用户，安全性较低

- 使用本地用户登入ftp的默认目录就是用户的家目录

- 用户访问的基本配置如下

  ```shell
  local_enable=YES				# 允许本地用户登入			
  write_enable=YES				# 允许本地用户上传
  local_umask=022					# 本地用户上传umask值
  local_root=/var/ftp			# 设置本地用户的ftp的根目录，对所有用户生效
  local_max_rate=0				# 限制最大传输速率（字节/秒）
  ```

  - 使用本地用户访问模式时， 用户的权限是由系统权限和ftp服务权限共同决定的

- 注意：默认配置下，本地用户访问是可以访问根目录的，这非常不安全，需要将用户访问的权限限制到家目录

  ```shell
  chroot_local_user=YES		# 开启用户目录限制，开启后，所有本地用户都会限制到家目录下
  ```

  - 这样配置后可能会报错：`500 OOPS: vsftpd: refusing to run with writable root inside chroot()`，原因是从2.3.5之后，vsftpd增强了安全检查，如果用户被限定在了其主目录下，则该用户的主目录不能再具有写权限了！如果检查发现还有写权限，就会报该错误。
    - 去除该目录的写权限
    - 在配置文件中添加`allow_writeable_chroot=YES`
  - 从下例中可以看到配置好以后，使用本地用户访问，是不能访问系统的根目录的

  ```shell
  ftp> pwd
  257 "/"					# 这是ftp的根目录，不是系统的
  ftp> ls
  200 PORT command successful. Consider using PASV.
  150 Here comes the directory listing.
  226 Directory send OK.
  ftp> cd /
  250 Directory successfully changed.
  ftp> ls
  200 PORT command successful. Consider using PASV.
  150 Here comes the directory listing.
  226 Directory send OK.
  ```

  - 还可以针对每个用户进行目录访问限制

  ```shell
  chroot_local_user=YES
  chroot_list_enable=YES
  chroot_list_file=/etc/vsftpd/chroot_list		# 写入该文件的用户不会受目录访问限制
  ```

## （2）用户访问控制

- `/etc/vsftpd/user_list` `/etc/vsftpd/ftpusers`：默认情况下这两个文件是黑名单

- `/etc/vsftpd/user_list`：该文件可通过修改配置文件改为白名单

- 访问控制配置

  ```shell
  userlist_enable=YES										# 开启用户访问控制
  userlist_deny=YES											# 控制user_list文件是黑名单还是白名单，默认是YES（黑名单）
  userlist_file=/etc/vsftpd/user_list		# 默认为这个文件，不可修改
  ```

# 七、虚拟用户访问

[待补全](https://www.bilibili.com/video/av38486547?p=28)

## （1）配置虚拟用户

- 虚拟用户ftp创建的模拟用户，它只能用于登入ftp服务器，不能登入Linux系统，是ftp最安全的一种用户访问
- 虚拟用户的另一个好处是可以为每个用户单独设置配置文件





## （2）单独定义虚拟用户权限

































