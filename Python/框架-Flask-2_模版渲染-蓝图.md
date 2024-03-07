# 1、模版渲染

- 模版渲染例子1

  - `templates/index.html`

    ```jinja2
    <h1>{{ POST.title }}</h1>
    ```

  - `index.py`

    ```python
    from flask import Flask, render_template
    
    app = Flask(__name__)
    
    
    @app.route('/')
    def manage():
    	POST = {
    		'title': 'study',
    	}
    	return render_template('manage.html', POST=POST)
    
    
    if __name__ == '__main__':
    	app.run()
    ```

- 模版渲染例子2：字符串过滤器

  - `templates/index.html`

    ```jinja2
    禁止转义： <br>
    <p>{{ '<em>hello</em>' | safe }}</p>
    把值转化成小写： <br>
    <p>{{ 'HELLO' | lower }}</p>
    把值转化成大写： <br>
    <p>{{ 'hello' | upper }}</p>
    反转： <br>
    <p>{{ 'hello' | reverse }}</p>
    格式化输出： <br>
    <p>{{ '%s is %d' | format('age', 18) }}</p>
    字符串截断： <br>
    <p>{{ 'hello, I am dream and I like sth' | truncate(20) }}</p>
    ```

  - `index.py`

    ```python
    from flask import Flask, render_template
    
    app = Flask(__name__)
    
    
    @app.route('/')
    def manage():
    	return render_template('manage.html')
    
    
    if __name__ == '__main__':
    	app.run()
    ```

- 模版渲染例子3：列表过滤器

  - `templates/index.html`

    ```jinja2
    获取第一个元素： <br>
    <p>{{ [1, 2, 3, 4] | first }}</p>
    获取最后一个元素： <br>
    <p>{{ [1, 2, 3, 4] | last }}</p>
    获取列表长度： <br>
    <p>{{ [1, 2, 3, 4] | length }}</p>
    列表求和： <br>
    <p>{{ [1, 2, 3, 4] | sum }}</p>
    列表排序： <br>
    <p>{{ [1, 2, 3, 4] | sort }}</p>
    ```

  - `index.py`

    ```python
    from flask import Flask, render_template
    
    app = Flask(__name__)
    
    
    @app.route('/')
    def manage():
    	return render_template('manage.html')
    
    
    if __name__ == '__main__':
    	app.run()
    ```

- 模版渲染例子4：自定义过滤器

  - `templates/index.html`

    ```jinja2
    列表反转： <br>
    <p>{{ [1, 2, 3, 4] | listreverse }}</p>
    ```

  - `index.py`

    ```python
    from flask import Flask, render_template
    
    app = Flask(__name__)
    
    
    @app.route('/')
    def manage():
    	return render_template('manage.html')
    
    
    def do_list_reverse(li):
        temp = list(li)
        temp.reverse()
        return temp
    
    
    app.add_template_filter(do_list_reverse, 'listreverse')
    
    if __name__ == '__main__':
    	app.run()
    ```

- 模版渲染例子5：if 判断

  - `templates/index.html`

    ```jinja2
    {% if li | length > 5 %}
    	列表的长度大于5
    	{% else %}
    		列表长度小于等于5
    {% endif %}
    ```

  - `index.py`

    ```python
    from flask import Flask, render_template
    
    app = Flask(__name__)
    
    
    @app.route('/')
    def manage():
    	li = [1, 2, 3, 4, 5, 6]
    	return render_template('manage.html', li=li)
    
    
    if __name__ == '__main__':
    	app.run(debug=True)
    ```

- 模版渲染例子6：for 循环

  - `templates/index.html`

    ```jinja2
    {% for ele in li %}
    	{{ ele }} <br>
    {% endfor %}
    ```

  - `index.py`

    ```python
    from flask import Flask, render_template
    
    app = Flask(__name__)
    
    
    @app.route('/')
    def manage():
    	li = [1, 2, 3, 4, 5, 6]
    	return render_template('manage.html', li=li)
    
    
    if __name__ == '__main__':
    	app.run(debug=True)
    ```

- 模版渲染例子7：for和if混用

  ```
  li = [1, 2, 3]
  {% for ele in li if ele != 3 %}
  	操作。。。
  {% endfor %}
  ```

# 2、蓝图



































































