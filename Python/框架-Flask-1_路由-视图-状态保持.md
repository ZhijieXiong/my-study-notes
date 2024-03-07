[TOC]



- flask是用python基于Werkzeug工具箱编写的轻量级的Web开发框架

# 1、基本使用

- 例子

  ```python
  # 代码如下
  from flask import Flask
  
  # 创建一个app应用
  app = Flask(__name__)
  
  # 装饰器的作用：将路由映射到视图函数上
  @app.route("/")
  def index():
  	return "hello world"
  
  
  if __name__ == "__main__":
  	# web服务器的路口
  	app.run()
  	
  
  # 执行结果如下
  dream:flask测试 dream$ python manage.py 
   * Serving Flask app "manage" (lazy loading)
   * Environment: production
     WARNING: Do not use the development server in a production environment.
     Use a production WSGI server instead.
   * Debug mode: off
   * Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
  127.0.0.1 - - [03/Sep/2020 22:36:23] "GET / HTTP/1.1" 200 -
  127.0.0.1 - - [03/Sep/2020 22:36:23] "GET /favicon.ico HTTP/1.1" 404 -
  ```

- `Flask`初始化参数

  - `import_name`    Flask程序所在的包    
  - `static_url_path`    静态文件访问路径，默认为`static_folder`
  - `static_folder`    静态文件存储的文件夹，默认为`static`
  - `template_folder`    模版文件存储的文件夹，默认为`templates`

- 加载配置

  - 方法一：配置对象

    ```python
    # 配置对象，里面定义需要给app添加的一系列配置
    class Config(object):
    	# 开启调试模式
    	DEBUG = True  
    
    app = Flask(__name__)
    # 从配置对象中加载配置
    app.config.from_object(Config) 
    ```

  - 方法二：配置文件（如config.ini）

    ```python
    # 配置文件内容
    DEBUG = True
    
    # app文件内容
    app = Flask(__name__)
    app.config.from_pyfile('./config.ini') 
    ```

  - 方法三：pycharm里面环境变量添加配置

  - 方法四：

    ```python
    app.run(debug=True, port=8080)
    ```

# 2、路由与视图

- 路由与视图函数

  - 例子1：路由传参

    ```python
    @app.route("/index/<user_id>")
    def index(user_id):
    	return "用户的id是{}".format(user_id)
    ```

    - 如果给路由传递了参数，则视图函数必须接收参数

  - 例子2：限制路由参数类型

    ```python
    @app.route("/index/<int:user_id>")
    def index(user_id):
    	return "用户的id是{}".format(user_id)
    ```

    - 可以限定传递参数的类型

  - 例子3：限定请求方式

    ```python
    from flask import Flask, request
    
    app = Flask(__name__)
    
    # 指定请求方式
    @app.route("/index", methods=["GET", "POST"])
    def index():
        # 直接请求中得到请求方式
    	return request.method
    ```

  - 例子4：返回json数据

    ```python
    from flask import Flask, jsonify
    
    app = Flask(__name__)
    
    @app.route("/index")
    def index():
    	json_dict = {
    		'user_id': 100,
    		'user_name': 'dream',
    	}	
    	# 返回json数据
    	return jsonify(json_dict)
    ```

  - 例子5：重定向

    ```python
    from flask import Flask, redirect
    
    app = Flask(__name__)
    
    @app.route("/index")
    def index():
    	return redirect('https://www.baidu.com')
    ```

  - 例子6：重定向到自己的视图函数

    ```python
    from flask import Flask, redirect, url_for
    
    app = Flask(__name__)
    
    @app.route("/index")
    def index():
    	return "hello"
    	
    @app.route("/test")
    def test():
    	return redirect(url_for("index"))
    ```

  - 例子7：自定义状态码

    ```python
    @app.route("/index")
    def index():
    	return "状态码是404", 404
    ```

    - 可用于反爬虫

- 正则匹配路由

  - 应用场景：限制用户访问

  - 具体步骤

    - 导入转换类基类：在flask中，所有的路由的匹配规则都是用转换器对象进行记录
    - 自定义转换器：继承转换器基类
    - 添加转换器到默认的转换器字典中
    - 使用自定义转换器实现自定义匹配规则

  - 例子

    ```python
    from werkzeug.routing import BaseConverter 
    from flask import Flask
    
    
    # 自定义转换器
    class RegexConverter(BaseConverter):
    	def __init__(self, url_map, *args):
    		# super重写父类
    		super(RegexConverter, self).__init__(url_map)
    		# 将第一个接收的参数当作匹配规则进行保存
    		self.regex = args[0]
    
    app = Flask(__name__)
    
    # 将自定义转换器添加到转换器字典中，并指定使用时的名字
    app.url_map.converters['re'] = RegexConverter
    
    # 路由就可以使用正则表达式匹配
    @app.route('/index/<re("[0-9]{3}"):user_id>')
    def index(user_id):
    	return user_id
    ```

- 异常的捕获

  - 例子

    ```python
    from flask import Flask
    
    app = Flask(__name__)
    
    @app.errorhandler(404)
    def server_error(e):
    	return "服务器未找到"
    ```

# 3、请求钩子

- 请求钩子（？）

  - 客户端和服务器交互时，有一些准备工作和扫尾工作需要做

    - 请求开始时，建立数据库连接
    - 请求开始时，进行权限验证
    - 请求结束时，指定数据的交互格式

  - 例子1

    ```python
    from flask import Flask, abort
    
    app = Flask(__name__)
    
    # 在第一次请求前调用，可以在此方法内部做一些初始化操作
    @app.before_first_request
    def before_first_request():
    	print("before first request")
        
      
    @app.route("/index")
    def index():
        return "hello"
    
    
    if __name__ == "__main__":
        app.run()
    ```

  - 例子2

    ```python
    from flask import Flask, abort
    
    app = Flask(__name__)
    
    # 在每次请求前调用，可以在此方法内部做一些请求的校验
    # 如果校验不成功，可以直接在此方法内部进行响应，即直接return后就不会执行视图函数
    @app.before_request
    def before_request():
    	print("before request")
        
      
    @app.route("/index")
    def index():
        return "hello"
    
    
    if __name__ == "__main__":
        app.run()
    ```

  - 例子3

    ```python
    from flask import Flask, abort
    
    app = Flask(__name__)
    
    # 在每次请求结束后调用，并且会把视图函数所生成的响应传入，能够对响应最后一步统一处理
    @app.after_request
    def after_request(response):
    	print("after request")
        response.headers["Content-Type"] = "application/json"
        return response
        
      
    @app.route("/index")
    def index():
        return "hello"
    
    
    if __name__ == "__main__":
        app.run()
    ```

# 4、cookie和session

- 用户登入状态保持

  - cookie（保存在客户端）

    - 指网站为了识别用户，进行会话跟踪，而存储在用户本地的数据（一段纯文本信息），不同域名的cookie不能互相访问

    - 例子1：设置cookie

      ```python
      from flask import Flask, make_response
      
      app = Flask(__name__)
      
      
      @app.route("/cookie")
      def cookie():
      	response = make_response("this is cookie")
      	# 可以设置过期时间（以秒为单位）
      	response.set_cookie("username", "dream", max_age=3600)
      	return response
      	
      
      if __name__ == "__main__":
          app.run()
      ```

    - 例子2：获取cookie

      ```python
      from flask import Flask, request
      
      app = Flask(__name__)
      
      
      @app.route("/askcookie")
      def askcookie():
      	response = request.cookies.get("username")
      	return response
      ```

  - session（在服务器端保持）

    - 依赖于cookie

    - 例子

      ```python
      """
          没有设置session时，获取session就是None
      """
       
      from flask import Flask, session
       
      app = Flask(__name__)
       
      """
          在flask当中使用 session 时，必须要做一个配置、
          即 flask的session中需要用到的秘钥字符串，可以是任意值
          flask默认把数据存放到了cookie中
      """
       
      app.config["SECRET_KEY"] = "renyizifuchuan"
       
       
      @app.route("/login")
      def login():
          """设置session的数据"""
          session["name"] = "python"
          session["mobile"] = "18612345678"
          return "login success"
       
       
      @app.route("/index")
      def index():
          """获取session的数据"""
          name = session.get("name")
          return "hello %s" % name
       
       
      if __name__ == '__main__':
          app.run(debug=True)
      ```

      

