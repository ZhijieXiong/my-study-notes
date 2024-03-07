# 1、表单交互

- 通过表单进行数据交互

  - `index.html`

    ```html
    <form action="/register" method="post" id="form">
    	用户名： <input type="text" name="username" value="请输入用户名"> <br>
    	密码： <input type="password" name="password"> <br>
    	确认密码： <input type="password" name="passwordConfirm"> <br>
    	<input type="submit" value="提交">
    </form>
    ```

  - `index.py`

    ```python
    from flask import Flask, request, render_template
    
    app = Flask(__name__)
    
    
    @app.route('/register', methods=['POST', 'GET'])
    def register():
    	if request.method == 'POST':
    		uname = request.form.get('username')
    		passwd = request.form.get('password')
    		passwd_confirm = request.form.get('passwordConfirm')
    	elif request.method == 'GET':
    		pass
    	return render_template('index.html')
    
    
    if __name__ == '__main__':
    	app.run(debug=True)
    ```

# 2、csrf攻击

- csrf攻击

  - 原理：当我们在网站A登入后，若网站设置了cookie，在这个时候去访问网站B，则B就可以获取浏览器里的cookie信息

    <img src="../../img/flask-csrf.png">

  - 例子

    - 未设置csrf保护的网站A

      - `login.html`    
  
        ```html
        <form action="/login" method="post" id="loginForm">
        	用户名： <input type="text" name="username" value="请输入用户名"> <br>
        	密码： <input type="password" name="password"> <br>
        	<input type="submit" value="登入">
      </form>
        ```

      - `transfer.html`
  
        ```html
        <form action="/register" method="post" id="transferForm">
        	转账金额： <input type="text" name="account" value="请输入转账金额"> <br>
        	<input type="submit" value="确认转账">
      </form>
        ```

      - `login.py`
  
        ```python
        from flask import Flask, request, render_template, redirect, url_for
        
        app = Flask(__name__)
        
        
        @app.route('/login', methods=['POST', 'GET'])
        def login():
        	if request.method == 'POST':
        		uname = request.form.get('username')
        		passwd = request.form.get('password')
        		response = redirect(url_for('transfer'))
        		response.set_cookie("username", uname, max_age=3600)
        		return response
        	else:
        		return render_template('login.html')
        
        
        @app.route('/transfer', methods=['POST', 'GET'])
        def transfer():
        	if request.method == 'POST':
        		return "转账成功"
        	else:
        		return render_template('transfer.html')
        
        if __name__ == '__main__':
      	app.run(debug=True, port=8081)
        ```

    - 攻击网站B

      - `attack.html`
  
        ```html
        <form action="/attack" method="post" id="transferForm">
        	<input type="submit" value="领取优惠卷">
      </form>
        ```

      - `attack.py`
  
        ```python
        from flask import Flask, request, render_template
        
        app = Flask(__name__)
        
        
        @app.route('/attack', methods=['POST', 'GET'])
        def attack():
        	if request.method == 'POST':
        		cookies = request.cookies.get('username')
        		print('cookie是： ', cookies)
        		return "取券成功"
        	else:
        		return render_template('attack.html')
        
        if __name__ == '__main__':
      	app.run(debug=True, port=8080)
        ```
  
        