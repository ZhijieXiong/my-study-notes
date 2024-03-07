[TOC]

# 1、node中的模块系统

- ES

- 核心模块：fs、http、os、url、path等等

- 第三方模块：art-template等

- 自定义模块

- js本身不支持模块化（即文件作用域和通信规则）

- node中导出的方法

  ```javascript
  // 1、挂载到expors上
  let a = 100;
  exports.a = a;
  
  // 2、默认导出
  let a = 100;
  module.exports = a;  // 注意不能exports = a
  ```

- 小结：node加载和导出使用`require`和`exports`

# 2、模块原理

- node底层代码 

  ```javascript
  let module = {
  	exports: {},
  	// ...
  };
  let exports = module.exports;
  // ...
  return module.exports;  // 实际导出的是module.exports而不是exports，所以给exports赋值并不会导出（给exports或者module.exports重新赋值都会丢掉exports和module.exports共同的引用）
  ```

- 优先从缓存中加载：已被加载过的模块不会再次加载，例子如下

  ```javascript
  // main.js
  require("./a.js")
  require("./b.js")
  
  // a.js
  console.log("a")
  require("./b.js")
  
  // b.js
  console.log("b")
  
  
  // node main.js结果为
  >> a
  >> b
  ```

  - 在main中加载b时，由于在加载a时已经加载过了b，所以在main里面不会再次加载b，而只是获取接口对象

- require加载方式

  - 加载自定义模块：模块标识符必须使用路径，即`/  ./  ../`开头
  - 核心模块：按照名字加载
  - 第三方包
    - 第三方包通过npm下载
    - 加载第三方包顺序（以art-template为例）
      - 首先到当前目录下找node_modules/art-template/package.js里的main属性所对应的文件（入口模块），假如是`{main: 'index.js'}，那么``require(art-template)`实际上加载的是node_modules/art-template/index.js
      - 注意：`index.js`是默认的入口模块，如果没有package.json或者main属性错误，就会自动加载index.js
      - 如当前目录不满足加载条件，则会到上一级目录下找包（方法同上），如果再不满足加载条件，则到上上级目录，一次类推，直到磁盘根目录

# 3、npm与package.jspn

## （1）包描述文件package.json

```json
{
    "name": "",
    "version": "",
    "description": "",
    "main": "",  // 入口模块
    "scripts": {
        "": ""
    },
    "author": "",
    "license": "",
    "depedencies": {
		"": ""    
	}
}
```

## （2）npm

- 常用命令

  ```shell
  # 查看版
  npm --version
  
  # 升级npm
  npm install --global npm
  
  # 下载多个包
  npm install xxx yyy zzz
  
  # 下载包，并记录到package.json
  npm install xxx --save
  
  # 自动初始化package.json（交互式），加上-y可以跳过向导
  npm init
  
  # 下载包简写
  npm i xxx -S
  
  # 根据package.json安装第三方包
  npm install
  
  # 删除包，加上--save会删除package.json中的信息
  npm uninstall xxx
  ```

- 解决npm被墙问题：淘宝的开发人员把npm再国内做了一个备份（`npm.taobao.org`）

  ```shell
  # 安装cnpm
  npm install --global cnpm
  cnpm install xxx
  
  # 不使用cnpm，但是仍选择使用淘宝的镜像源下载包
  npm install xxx --registry=https://registry.npm.taobao.org
  
  # 把上面写入配置
  npm config set registry https://registry.npm.taobao.org
  
  # 查看配置信息
  npm config list
  ```

# 4、express入门

- express是一个nodejs框架

- 基本使用

  ```javascript
  let express = require('express');
  let app = express();
  // 公开指定目录（/public/开头的url均可访问，路径为./public/）
  app.use('/public/', express.static('./public/'));
  // 收到GET请求的回应，可以并列写get，并且不用考虑顺序
  app.get('/', (req, res) => {  
      console.log(req.query);  // 获取查询字符串
      res.send('hello world');
  });  
  app.listen(3000, () => {});
  ```

- 注意：express仍然可以用原来的API，如res.write

- 修改完代码自动重启服务（第三方工具nodemon：`npm install --global nodemon`，使用方法`nodemon server.js`）

- 路由处理

  ```javascript
  let express = require('express');
  let app = express();
  
  app.get(<url>, <callback(req, res)>);
  app.post(<url>, <callback(req, res)>);
  
  // 或者这样写也可以
  app
  	.get(<url>, <callback(req, res)>)
  	.get(<url>, <callback(req, res)>)
  	.post(<url>, <callback(req, res)>)
  	.get(<url>, <callback(req, res)>)
  ```

- express静态服务

  ```javascript 
  let express = require('express');
  let app = express();
  
  // 当请求以urlStart开头的资源时，返回fielPath下的同名文件，即开放filePath下的资源
  app.use(<urlStart>, express.static(<fielPath>));  
  
  // app.use可以省略第一个参数，例子如下
  app.use(express.static('./public/'));  
  // 假设有文件./public/js/index.js，则可以通过/js/index.js的url访问
  ```

- express中使用art-template

  - 安装

    - `npm install art-template --save` 
    - `npm install express-art-template --save`

  - 配置

    ```javascript
    let express = require('express');
    let app = express();
    // 核心代码，表示当渲染以.art结尾的文件时，使用express-art-template（该包整合了art-template和express） 
    app.engine('art', require('express-art-template'));  
    app.set('view options', {
    	debug: process.env.NODE_ENV !== 'production'
    });
    app.get('/', (req, res) => {
        // res.render默认不可以使用，但是配置了模版引擎就可以使用
        // 第一个参数是渲染的文件名，默认到views目录下找
    	res.render('index.art', {
    		user: {
    			name: 'xzj',
    		}
    	});
    });
    ```

    - 修改默认render的路径：`app.set('views', <renderPath>)`

- 重定向：`res.redirect('/')`

- express解析post请求

  - `app.post('/post', (req, res) => {})`

  - 获取post表单数据 ：需要使用中间件body-parser

    - `npm install body-parser`

    - 配置

      ```javascript
      let express = require('express');
      let bodyParser = require('body-parser');
      
      let app = express();
      
      // 加入这个配置，则req就会多出一个属性body
      app.use(bodyParser.urlencoded({extend: false}));
      app.use(bodeParser.json());
      
      app.use((req, res) => {
      	res.setHeader('Content-Type', 'text/plain');
      	res.write('posted：\n');
      	res.end(JSON.stringify(req.body, null, 2));
      });
      ```

- 服务端有错误：`res.status(500).send('server error')`

# 5、crud

- 第一步：路由设计

- 第二步：路由模块提取

  - 把路由提取到`router.js`

  - 始终把app.js作为入口

    ```javascript
    // router.js
    modules.exports = (app) => {
    	let fs = require('fs');
    	// ...
    	app.get();
    	app.post();
    }
    
    
    // app.js
    let express = require('express');
    let router = require('./router.js');
    
    let app = express();
    
    app.use();
    app.engine();
    // ...
    
    router(app);
    
    app.listen(3000, () => {});
    ```

  - express提供了一个更好的方式来包装路由

    ```javascript
    // router.js
    let express = require('express');
    
    // 1、创建一个路由容器
    let router = express.Router()
    
    // 2、把路由都挂载到路由容器中
    router.get();
    router.post();
    // ...
    
    // 3、导出router
    module.exports = router;
    
    
    
    // app.js
    let express = require('express');
    let router = require('./router.js');
    
    let app = express();
    
    app.use();
    app.engine();
    // ...
     
    app.use(router);
    
    app.listen(3000, () => {});
    ```

- 第三步：配置中间件（如body-parser）

  - 注意：配置一定要在挂载路由（`app.use(router)`）之前

- 封装文件读写

  - 获取函数中异步操作结果：通过回调函数

    ```javascript
    let find = (callback) => {
    	fs.readFile('path', (err, data) => {
    		if (err) {
    			callback(err);
    		} else {
    			callback(null, data);
    		}
    	}); 
    }
    ```


# 6、中间件

## （1）中间件概念

- 比喻：自来水厂处理水的过程，把一个复杂的流程分布到多个环节有序执行，每个环节有输入输出

- 不使用中间件

  - 我们在接收到用户请求后，需要根据请求做出反应
  - 这时就需要做许多准备工作，如解析get请求，解析post请求，解析cookies等等
  - 如果不使用中间件，就需要自己去做这些工作，因为node原生不提供这些功能

- 中间件：就是把以上工作代码封装以后得到的文件，这样要使用时就引入这些中间件文件就行，即在做业务处理之前使用中间件

- 中间件概念：处理请求的函数，express中中间件分为以下几类

  - 第一类：不关心请求路径和请求方法的，即`app.use()`，传入一个函数即可，任何请求都会触发这个传入的函数 ；中间件本身是一个方法，接收三个参数，请求对象、响应对象和下一个中间件

    ```javascript
    const express = require('express');
    const app = express();
    
    app.use((req, res, next) => {
        console.log('1：进来一个请求');
        next();  // 没有next()，默认是不会执行第二个use的中间件的
    });
    
    app.use((req, res, next) => {
        console.log('2：执行第二个中间件');
    });
    ```

  - 第二类：关心请求路径的中间件

    ```javascript
    app.get('/abc', (req, res, next) => {
    // 请求url以/abc开头（如/abc/index，但是/abcd/index不行）时，执行中间件，如请求url为/abc/index，则req.url为index
    	console.log(req.url); 
    });
    ```

  - 第三类：关心请求路径和请求方法的中间件，即`app.get`和`app.post`

    - 同一个请求可以经过多个中间件处理，只要调用next

## （2）中间件配置

- 中间件分为以下几类

  - 应用程序级别中间件

  - 路由级别中间件

  - 错误处理中间件

    ```javascript
    app.get('/', (res, req, next) => {
        fs.readFile('/index', (err, data) => {
            if (err) {
                next(err);  // next传参数，会直接进入错误处理中间件（4个参数）
            }
        });
    });
    
    // 错误处理中间件（注意参数个数，一定为4个）
    app.use((err, res, req, next) => {
    	res.status(500).send('500，服务器错误');
    }); 
    ```

  - 内置中间件

  - 第三方中间件 

  - 补充概念：同一个请求所经过的中间件处理，都是同一个请求和响应