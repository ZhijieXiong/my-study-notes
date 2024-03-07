[TOC]

# 1、path模块

- 另一种开放目录的方法

  ```javascript
  const express = require('express');
  const path = require('path');
  
  let app = express();
  
  app.use('/public/', express.static(path.join(__dirname, './public/')));
  app.use('/node_modules/', express.static(path.join(__dirname, '/node_modules/')));
  ```

- 常用API

  ```javascript
  > path.basename('~/Desktop/Sourec/nodejs/deom/test.js')
  'test.js'
  > path.basename('~/Desktop/Sourec/nodejs/deom/test.js', '.js')
  'test'
  > path.dirname('~/Desktop/Sourec/nodejs/deom/test.js')
  '~/Desktop/Sourec/nodejs/deom'
  > path.extname('~/Desktop/Sourec/nodejs/deom/test.js')
  '.js'
  > path.isAbsolute('~/Desktop/Sourec/nodejs/deom/test.js')
  false
  > path.isAbsolute('/Desktop/Sourec/nodejs/deom/test.js')
  true
  > path.parse('/Users/Desktop/test.js')
  {
    root: '/',
    dir: '/Users/Desktop',
    base: 'test.js',
    ext: '.js',
    name: 'test'
  }
  > path.parse('./test.js')
  { root: '', dir: '.', base: 'test.js', ext: '.js', name: 'test' }
  > path.join('/Users', 'Desktop/test.js')
  '/Users/Desktop/test.js'
  > path.join('/Users', 'demo','Desktop/test.js')
  '/Users/demo/Desktop/test.js'
  ```

- node中的非模块成员：`__dirname  __filename`
  - __dirname：当前文件所属目录的绝对路径
  - __filename：当前文件的绝对路径
- 在文件操作中，相对路径是不可靠的，因为相对路径相对的是执行命令的路径，而不是文件所在的路径
- 注意：模块中的文件标识就是以该文件为参考的（如`require('./a.js')`），而不是相对执行命令的路径

# 2、art-template模版继承

- art-template可以提取公共部分作为模版

  ```html
  // header.html
  <div>
  	<h1>header</h1>	
  </div>
  
  // header.html
  <div>
  	<h1>footer</h1>	
  </div>
  
  // layout.html
  <head>
      {{ block 'head' }}
      {{ /block }}
  </head>
  <body>
  	{{ include './header.html' }}
  	<!-- 公共部分 -->
  	{{ block 'content' }}
  		<p>默认内容</p>
  	{{ /block }}
  	{{ include './footer.html' }}
  </body>
  
  
  // index.html（使用默认内容）
  {{ extend './layout.html' }}
  
  // index.html（使用自己填写的内容）
  {{ extend './layout.html' }}
  {{ block 'content' }}
  	<div>
  		<p>定制内容</p>	
  	</div>
  {{ /block }}
  ```

# 3、细节

- 目录结构

  ```shell
  dream:7-综合案例 dream$ tree .
  .
  ├── README.md
  ├── app.js
  ├── controllers
  ├── models
  ├── package.json
  ├── public
  ├── routes
  └── views
  
  5 directories, 3 files
  ```

- 数据模型

  ```javascript
  let userSchema = new Schema({
  	time: {
  		type: Date,
  		default: Date.now  // 传入一个方法，而不是写死的时间，这样当我们 new model 时没有传递 time 时，mongoose就
          				   // 会调用default方法
  	},
      status: {
          type: Number,
          enum: [0, 1, 2],  // 0表示没有权限限制，1表示不可以评论，2表示不可以登入
          default: 0
      }
  });
  ```

- express提供json方法：`res.status(200).json({ login:true })`

- md5第三方包：到github上找

- 表单同步提交、异步提交

  - await：等待操作结束才进行下一步
  - async：定义异步函数
  - 表单具有默认提交行为，默认是同步的，同步表单提交，浏览器会锁死等待服务器响应结果；并且同步提交表单，浏览器会把服务端响应结果直接渲染到浏览器上

- 服务端针对异步请求重定向无效，只能客户端重定向

- 通过session保存登入状态

  - cookie可以用来保存一些不太敏感的东西，但不能用来保存用户登入的状态

  - session保存到服务端，可以保存一些敏感的信息

  - express默认不支持session，但是可以使用第三方中间件express-session来解决

    ```javascript
    const express = require('express');
    const session = require('express-session');
    
    let app = express();
    
    // 配置（一定要在路由之前）
    app.use(session({
        secret: 'keyboard cat',  // 盐，添加到要加密的信息后面，增加安全性
        resave: false,  
        saveUninitialized: true  // 无论是否使用session，都分配一把钥匙
    }));
    
    // 使用：配置好以后，就可以通过req.session来访问和设置session成员
    // 添加session数据：req.session.property = something
    // 访问session数据：req.session.property
    ```

    - 默认session数据是内存存储的，真正的生产环境会把session持久化存储

