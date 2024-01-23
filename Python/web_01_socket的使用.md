# 1、socket

- 如何通信
  - 同一台主机上，通过端口号就可以唯一标识一个进程
  - 在网络中，ip+协议+端口号可以表示网络中的一个进程
- socket使用	
  - socket（套接字）：进程通信的一种方式，它能实现不同主机间的进程通信，我们网络上各种各样的服务大部分都是通过socket实现的
  - API（具体使用见例子）
    - `SOCKET = socket.socket()`    创建一个套接字
    - `SOCKET.sendto()`    发送数据
    - `SOCKET.bind()`    绑定ip和port
    - `SOCKET.recvfrom()`    返回接收到的数据				
    - `SOCKET.close()`    关闭套接字
- socket的机制
  - socket是全双工，一个socket可以发也可以收
  - 端口通信的机制（以python实现socket为例）：		
    - 当我们创建一个套接字并在等待接受数据，在未接收到数据前，进程是阻塞的		
    - 如果其它的机器给我们的某一个端口发信息，如果我们用套接字接受数据，那么就会收到数据		
    - 但是如果我们没有使用socket.recvfrom()接受数据，操作系统会把收到的信息存起来，等待接受		
    - 拒绝服务攻击：扫描一台机器的端口，查到哪个端口是开着的，就不停地向该端口发送数据，知道容量被占满

# 2、tcp

- tcp介绍
  - TCP协议（Transmission Control Protocol）：一种面向连接的、可靠的、基于字节流的传输层通信协议
  - UDP协议（User Datagram Protocol）：一种无连接的传输层协议，提供面向事务的简单不可靠信息传送服务
  - TCP、UDP区别：
    - udp通信模型中，在通信开始之前，不需要建立相关的连接，只发送数据（不安全）
    - tcp通信需要经过“创建连接”、“数据传送”和“终止连接”，在通信开始之前，要建立相关连接（安全）
- python编程实现tcp通信
  - tcp严格区分服务端和客户端
  - 客户端流程
    -  创建套接字：`socket.socket()`
    - 连接服务器：`socket.connect()`
    - 传送数据/接受数据：`socket.send()`  `socket.recv()`
  - 服务端创建一个套接字并监听这个套接字，当有客户端连接服务器时，服务器获得客户端的地址，并分配一个新套接字用于与这个客户端通信
    - 创建套接字：`socket.socket()`
    - 绑定端口：`socket.bind()`
    - 监听端口（将主动套接字变为被动套接字）：`socket.listen(128)`
    - 等待连接（返回客服端地址和一个新套接字）：`socket.accept()`
    - 接受/发送：`socket.recv()`  `socket.send()`
  - 关于程序阻塞		
    - 当客户端连接上服务器，服务器在等待客户端发送数据时，程序阻塞		
    - 只有以下两种情况，程序解阻塞：			
      - 客户端发送数据，且服务器接收到			
      - 客户端关闭套接字

# 3、例子

## （1）使用UDP通信

- 发送端代码

```python
import socket


def main():
    # socket.socket()接收两个参数
    # Address Family：AF_INET（网络进程间通信），AF_UNIX（同一台机器进程间通信）
    # Type：SOCK_STREAM（流式套接字，TCP协议），SOCK_DGRAM（数据报套接字，UDP协议）
    udpSocket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    
    udpSocket.bind(("", 3000))    

    # socketObject.sendto()接收两个参数
    # bytes：一个bytes
    # 目标进程地址：元组，("IP", port)
    ip = "127.0.0.1"
    port = "2000"
    udpSocket.sendto(("hello, I am %s:%s" % (ip, port)).encode("utf-8"), (ip, int(port)))

    udpSocket.close()


if __name__ == "__main__":
    main()
```

- 接收端代码

```python
import socket


def main():
    udpSocket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    
    # socket.bind(("ip", port))绑定ip和端口号，如为主机，则绑定空字符串
    udpSocket.bind(("", 2000))

    # socket.recvfrom()返回接收到的数据（未解码），参数为一次接收最大字节
    data = udpSocket.recvfrom(1024)

    # data的格式为元组，如：(b'hello!', ('127.0.0.1', 3000))
    print("ip:%s-port:%s接受到：%s" % (data[1][0], data[1][1], data[0].decode("utf-8")))
    
    udpSocket.close()


if __name__ == "__main__":
    print("------run------")
    main()
    print("------end------")
```

- 运行结果

```shell
# 执行接收端程序，等待接受
dream:Web相关 dream$ python socket_udp_accept.py 

# 执行发送端程序，发送数据
dream:Web相关 dream$ python socket_udp_send.py 

# 接收端结果
------run------
ip:127.0.0.1-port:3000接受到：hello, I am 127.0.0.1:2000
------end------
```

## （2）使用tcp通信

- 服务端程序

```python
import socket


def main():
	# 创建服务器套接字
	server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

	# 绑定服务器端口
	server_socket.bind(("", 10000))

	# 监听端口，将套接字变为被动的，参数为可同时连接到服务器的客服端数目
	server_socket.listen(128)

	# 等待客户端连接
	print("------------等待中-----------")
	
	# socket.accept()返回一个元组，有两个元素
	# 1、新的套接字，专门用于与连接的这个客户端通信
	# 2、客户端的ip和port
	new_socket, client_addr = server_socket.accept()
	
	# 接收数据
	data = new_socket.recv(1024).decode("utf-8")
	print(client_addr, "发送数据：", data)
	message = b"Hello, Client!"
	print("回复：" + message.decode("utf-8"))
	
	# 发送数据
	new_socket.send(message)
		
	# 关闭客服端套接字
	print("已关闭客户端套接字")
	new_socket.close()	

	print("-----------关闭服务器--------")
	server_socket.close()


if __name__ == "__main__":
	main()
```

- 客户端程序

```python
import socket


def main():
	# 创建一个客户端的套接字
	client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	
	# 连接服务器
	client_socket.connect(("", 10000))

	print("---------已连接上服务器--------")

	# 传送数据
	message = b"Hello, Server!"
	print("发送：" + message.decode("utf-8"))
	client_socket.send(message)
	
	# 接收数据
	data = client_socket.recv(1024)
	print("接收：" + data.decode("utf-8"))

	print("------------连接断开----------")
	
	client_socket.close()


if __name__ == "__main__":
	main()
```

- 运行结果

```python
# 执行服务端程序
dream:Web相关 dream$ python socket_tcp_server.py 
------------等待中-----------

# 执行客户端程序
dream:Web相关 dream$ python socket_tcp_clinet.py 
---------已连接上服务器--------
发送：Hello, Server!
接收：Hello, Client!
------------连接断开----------

# 服务端接收结果
dream:Web相关 dream$ python socket_tcp_server.py 
------------等待中-----------
('127.0.0.1', 61979) 发送数据： Hello, Server!
回复：Hello, Client!
已关闭客户端套接字
-----------关闭服务器--------
```

# 4、使用socket实现简单的ssh

- 服务端程序

```python
import socket
import subprocess
import struct


def main():
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind(("", 11111))  # ""表示"127.0.0.1"
    server_socket.listen(5)

    while True:
        client_socket, client_addr = server_socket.accept()
        print(client_addr, "已连接到本机")
        while True:
            try:
                data = client_socket.recv(1024).decode("utf-8")
                if data == "exit":
                    client_socket.close()
                    print("客户端已退出")
                    break

                # subprocess.Popen()用来执行终端命令
                ret = subprocess.Popen(data, shell=True, 
                											 stderr=subprocess.PIPE, stdout=subprocess.PIPE)
                # 从标准输出和标准错误输出读取输出和错误信息到out和err中
                out = ret.stdout.read()
                err = ret.stderr.read()

                if bool(out):
                    out_len = struct.pack('i', len(out))
                    # 先发送信息的长度给客户端，让客户端做好接受准备，避免黏包现象
                    client_socket.send(out_len) 
                    client_socket.send(out)
                else:
                    err_len = struct.pack('i', len(err))
                    client_socket.send(err_len)
                    client_socket.send(err)
            except Exception:
                client_socket.close()
                print('客户端异常退出，已关闭连接')
                break


main()
```

- 客户端程序

```python
import socket
import struct


def main():
    flag = 'Y'
    while flag == 'Y' or flag == 'y':
        client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        server_IP = input("请输入服务器IPv4地址:")
        server_info = (server_IP, 11111)
        client_socket.connect(server_info)

        print('已连接到服务器')
        while True:
            cmd = input("请输入命令：")
            client_socket.send(cmd.encode('utf-8'))

            if cmd == 'exit':
                client_socket.close()
                print("已退出")
                break
            else:
                data_len_packed = client_socket.recv(4)
                # 首先接受服务端发送的信息长度
                data_len = struct.unpack('i', data_len_packed)[0]
                length = 0
                info = b''

                # 若服务端发送的信息长度超过1024，则分多次接受
                while length < data_len:
                    data = client_socket.recv(1024)
                    info = info + data
                    length += len(data)

                print('返回信息长度为： ', length)
                print(info.decode('utf-8'))
        flag = input("请问是否继续（若继续请输入Y/y）：")


main()
```

- 运行结果

```shell
# 这是服务器端结果（总共连接了两次）
dream:sshTest dream$ python ssh_server.py 
('127.0.0.1', 62012) 已连接到本机
客户端已退出
('127.0.0.1', 62014) 已连接到本机
客户端已退出

# 这是客户端结果
dream:sshTest dream$ python ssh_client.py 
请输入服务器IPv4地址:127.0.0.1
已连接到服务器
请输入命令：pwd
返回信息长度为：  48
/Users/dream/Desktop/Source/python/test/sshTest

请输入命令：ls
返回信息长度为：  28
ssh_client.py
ssh_server.py

请输入命令：ifconfig
返回信息长度为：  3081
lo0: flags=8049<UP,LOOPBACK,RUNNING,MULTICAST> mtu 16384
	options=1203<RXCSUM,TXCSUM,TXSTATUS,SW_TIMESTAMP>
	inet 127.0.0.1 netmask 0xff000000 
	inet6 ::1 prefixlen 128 
	inet6 fe80::1%lo0 prefixlen 64 scopeid 0x1 
	nd6 options=201<PERFORMNUD,DAD>
...（后面的内容略）

请输入命令：exit
已退出
请问是否继续（若继续请输入Y/y）：Y
请输入服务器IPv4地址:127.0.0.1
已连接到服务器
请输入命令：pwd
返回信息长度为：  48
/Users/dream/Desktop/Source/python/test/sshTest

请输入命令：exit
已退出
请问是否继续（若继续请输入Y/y）：n
```

 