[TOC]

# 1、websocket介绍

- websocket是一种基于http的网络协议
- websocket是持久性连接的，且服务端可以主动向客户端发送消息
- 在websocket出现以前，实现实时聊天都是基于ajax轮询的

# 2、h5中使用websocket

- h5已经支持websocket（https://developer.mozilla.org/zh-CN/docs/Web/API/WebSocket/WebSocket）

- 使用方法

  ```javascript
  let socket = new WebSocket(url, [protocol]);  // url为 ws://...
  socket.addEventListener('open', () => {
     ... 
  });  // 建立连接
  socket.send('hello');  // 发送消息
  socket.addEventListener('message', (e) => {
      console.log(e.data);
  });  // 接受消息
  ```

- websocket事件

  | 事件    | 处理程序         | 描述                       |
  | ------- | ---------------- | -------------------------- |
  | open    | Socket.onopen    | 建立连接时触发             |
  | message | Socket.onmessage | 客户端接受服务端数据时触发 |
  | error   | Socket.onerror   | 通信发生错误时触发         |
  | close   | Socket.onclose   | 连接关闭时触发             |

- websocket方法

  - `Socket.send()` 使用连接发送数据
  - `Socket.close()`

# 3、服务端使用websocket

- 方法一：使用`nodejs-websocket`

  ```javascript
  const ws = require('nodejs-websocket');
  
  const server = ws.createServer((connect) => {
      // 接收到用户数据，触发事件
  	connect.on('text', (data) => {
          // 返回数据
          connect.send(data, () => {
              
          });  
      });  
      
      // 用户关闭连接事件和处理错误事件
      connect.on('close', () => {
          
      });
      connect.on('error', () => {
          
      });
  });
  
  
  // 广播函数
  function broadcast(msg) {
      server.connections.forEach((user) => {
          user.send(JSON.stringfy(msg));
      });
  }
  
  server.listen(3000, () => {
      console.log('server is running');
  })
  ```

- 方法二：使用`socket.io`

  - `socket.emit()` 触发事件（服务端或者客户端给对方发数据）
  - `socket.on()` 注册事件（监听事件）

  ```javascript
  const http = require('http');
  
  const express = require('express');
  const socketIo = require('socket.io');
  
  const app = express();
  const server = http.createServer(app);
  const io = socketIo(server);
  
  app.get('/', (req, res) => {
    res.sendFile(__dirname + '/index.html');
  });
  
  io.on('connection', (socket) => {
    console.log('a user connected');
      
    // 服务端给客户端发数据
    socket.emit('send', 'hello');
      
    socket.on('disconnect', () => { 
      console.log('user disconnected');
    });
      
    socket.on('chat message', (msg) => {
      // 广播收到的消息
      io.emit('chat message', msg);
    });
  });
  
  server.listen(3001, () => {
    console.log('listening on *:3001');
  });
  ```

  - 客户端代码

    ```html
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Document</title>
        <!-- 使用socket.io -->
        <script src="/socket.io/socket.io.js"></script>
      </head>
      <body>
        <ul id="messages"></ul>
        <form id="form" action="">
          <input id="input" autocomplete="off" /><button>Send</button>
        </form>
        <script>
          // io(url)
          var socket = io();
    
          var messages = document.getElementById("messages");
          var form = document.getElementById("form");
          var input = document.getElementById("input");
    
          form.addEventListener("submit", function (e) {
            e.preventDefault();
            if (input.value) {
              socket.emit("chat message", input.value);
              input.value = "";
            }
          });
    
          // 接受服务端发送的数据（send事件）
          socket.on('send', (data) => {
              console.log(data);
          })
            
          socket.on("chat message", function (msg) {
            var item = document.createElement("li");
            item.textContent = msg;
            messages.appendChild(item);
            window.scrollTo(0, document.body.scrollHeight);
          });
        </script>
      </body>
    </html>
    
    ```

# 4、其它

- 发送文件：https://developer.mozilla.org/zh-CN/docs/Web/API/FileReader/readAsDataURL

  

  