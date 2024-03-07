[TOC]

# 1、Scrapy介绍

- Scrapy是python的一个爬虫框架
- Scrapy使用Twisted（异步网络库）来处理网络通信
- 我也是初学者，所以这篇博客只是讲了Scrapy的最基本的使用

# 2、基本使用（官方文档内容）

- 准备爬取的网站是：`quotes.toscrape.com/page/1/`和`quotes.toscrape.com/page/2/`

## （1）创建项目

- 在命令行中运行如下命令

  ```shell
  dream:tmp dream$ scrapy startproject tutorial  # tutorial是项目的名称，可自己决定
  New Scrapy project 'tutorial', using template directory '/anaconda3/lib/python3.6/site-packages/scrapy/templates/project', created in:
      /private/tmp/tutorial
  
  You can start your first spider with:
      cd tutorial
      scrapy genspider example example.com  
  ```

- 运行命令后，会在当前目录（可用pwd命令查看当前目录）下创建一个tutorial文件夹

- 该文件夹的内容如下

  ```shell
  dream:tmp dream$ tree tutorial/
  tutorial/
  ├── scrapy.cfg
  └── tutorial
      ├── __init__.py
      ├── __pycache__
      ├── items.py
      ├── middlewares.py
      ├── pipelines.py
      ├── settings.py
      └── spiders
          ├── __init__.py
          └── __pycache__
  
  4 directories, 7 files
  ```

  - `settings.py`    设置爬虫相关的配置
  - `spiders`    该文件夹下放置爬虫文件
  - 其它未提到的在这篇博客里未涉及

## （2）spiders里的内容

- 使用scrapy爬虫时，需要先在`spiders`文件夹下的爬虫文件里定义一个`Spider`的继承类，官网给的例子如下
- 该例子中涉及到了生成器，关于生成器，详细内容见[链接](../10_迭代器和生成器.md)

```python
import scrapy

class QuotesSpider(scrapy.Spider):
    name = "quotes"  # 爬虫的名字（必须唯一），在运行爬虫时用到

    def start_requests(self):
        urls = [
            'http://quotes.toscrape.com/page/1/',
            'http://quotes.toscrape.com/page/2/',
        ]
        for url in urls:
            yield scrapy.Request(url=url, callback=self.parse)  

    def parse(self, response):  
        page = response.url.split("/")[-2]
        filename = 'quotes-%s.html' % page
        with open(filename, 'wb') as f:
            f.write(response.body)
        self.log('Saved file %s' % filename)
```

- 如果不想写`start_request()`方法，也可以按如下方式定义`QuotesSpider`类
- 这种方式是利用了约束（关于约束，请点[链接](../20_面向对象3_函数与方法-反射-约束.md)查看详细内容）

```python
import scrapy


class QuotesSpider(scrapy.Spider):
    name = "quotes"
    start_urls = [
        'http://quotes.toscrape.com/page/1/',
        'http://quotes.toscrape.com/page/2/',
    ]

    def parse(self, response):
        page = response.url.split("/")[-2]
        filename = 'quotes-%s.html' % page
        with open(filename, 'wb') as f:
            f.write(response.body)
```

## （3）交互式查看数据

- 运行如下命令，进入scrapy shell（一个交互式python解释器）

  ```python
  dream:tmp dream$ scrapy shell 'http://quotes.toscrape.com/page/1/'
  ...输出略
  In [1]:   # 这里表示进入了scrapy shell
  ```

- 例子

  ```python
  In [1]: view(response)  # 打开所选择的链接（即打开html文件）
  Out[1]: True
  
  In [2]: response.css("title")  
    # 根据html标签筛选数据（这里是提取<title>标签的全部内容），返回一个选择器类列表对象
  Out[2]: [<Selector xpath='descendant-or-self::title' data='<title>Quotes to Scrape</title>'>]  
    # 返回的是一个类似列表的对象（即可索引），数据存放在data里
    # 当匹配到的数据不止一个时，可通过索引选择所需的选择器
    
  In [3]: response.css("title::text")  # 这里是提取<title>标签内部的文本信息
  Out[3]: [<Selector xpath='descendant-or-self::title/text()' data='Quotes to Scrape'>]
  
  In [4]: response.css("title::text").get()  
    # 提取选择器数据（只提取一个，若有多个数据，则返回第一个选择器的data）
  Out[4]: 'Quotes to Scrape'
    
  In [5]: response.css("title::text")[0].get()
  Out[5]: 'Quotes to Scrape'
  
  In [6]: response.css("title::text").getall()  # 返回一个列表，列表里是选择器的所有data
  Out[6]: ['Quotes to Scrape']
  
  In [10]: response.css("link").re(r'href="(.*[\.]css)"')  
    # 可以使用正则表达式筛选数据，直接返回选择器的data，以列表形式返回
  Out[10]: ['/static/bootstrap.min.css', '/static/main.css']
  ```


# 3、Scrapy原理

<img src="../img/Scrapy原理.png">

- 各步骤如下
  1. 爬虫文件将请求（网址）交给引擎
  2. 引擎将请求交给调度器的入队列进行排队
  3. 调度器通过出队列将请求返回给引擎
  4. 引擎将请求交给下载器
  5. 下载器下载请求的数据（网页源代码）
  6. 下载器将响应（网页源代码）交给引擎
  7. 引擎将响应交给爬虫文件，爬虫文件提取数据或发现新请求
  8. 爬虫文件将提取的数据/发现的新请求交给给引擎
     - 若爬虫文件交给引擎的是数据，则执行步骤9
     - 若爬虫文件交给引擎的是新请求，则回到步骤2
  9. 引擎将数据交给管道文件，管道文件保存、处理数据

# 4、创建爬虫项目的步骤（带实例）

- 总共有四个步骤
  1. 新建项目
  2. 创建爬虫
  3. 分析
     - 定位数据
     - 数据提取
     - 跳转（如果有多页的话）
  4. 运行爬虫

## （1）新建项目

- 见目录2，这里略

## （2）创建爬虫

- 两个方法

  - 写一个py文件，就是目录2中官方文档介绍的方法

  - 在项目顶级目录下运行命令

    ```shell
    scrapy genspider <爬虫名字> <网页域名>  # 爬虫名字必须唯一
    ```

  - 例子

    ```shell
    dream:tutorial dream$ pwd
    /Users/dream/Desktop/Source/python/all_test/scrapyTest/tutorial
    dream:tutorial dream$ scrapy  genspider quotes quotes.toscrape.com
    Created spider 'quotes' using template 'basic' in module:
      tutorial.spiders.quotes
    dream:tutorial dream$ tree .
    .
    ├── scrapy.cfg
    └── tutorial
        ├── __init__.py
        ├── __pycache__
        │   ├── __init__.cpython-36.pyc
        │   └── settings.cpython-36.pyc
        ├── items.py
        ├── middlewares.py
        ├── pipelines.py
        ├── settings.py
        └── spiders
            ├── __init__.py
            ├── __pycache__
            │   └── __init__.cpython-36.pyc
            └── quotes.py  # 自动创建了py文件
    
    4 directories, 11 files
    ```

## （3）分析数据

- 选择器
  - Scrapy提取数据有自己的一套机制，它们被称为选择器（selectors），通过特定的XPath或者CSS表达式来选择html文件中的某个部分，本身是基于parse模块实现的
  - 有四个基本的方法
    - `xpath()`    传入xpath表达式，返回该表达式对应所有节点的列表
    - `css()`   传入css表达式，返回该表达式对应所有节点的列表
    - `extract()`    序列化该节点为unicode字符串，并返回列表
    - `re()`    传入正则表达式，返回该表达式对应所有节点的列表
- 修改quotes.py文件如下

```python
# -*- coding: utf-8 -*-
import scrapy


# 创建爬虫类，基础自scrapy.Spider（最基础的类，其它几个相关类也是继承的这个）
class QuotesSpider(scrapy.Spider):
    name = 'quotes'  # 爬虫名字，必须唯一
    allowed_domains = ['quotes.toscrape.com']  # 允许采集的网页域名
    start_urls = ['http://quotes.toscrape.com/page/1/']  # 开始采集的页面
    # 加入有多页的话，可以这样创建列表（假设有100页）：
    # allowed_domains = [f'http://quotes.toscrape.com/page/{n}/' for n in range(100)]

    # 解析响应数据，提取数据（网页源码），response就是提取到到数据，为字符串
    def parse(self, response):
        # 提取数据：可以使用（1）正则表达式（2）Xpath（3）CSS选择器
        selectors = response.xpath("//span[@class='text']")  
        # 这里使用Xpath提取数据（提取的是页面里的语句所在的标签）

        sentence_list = []
        for selector in selectors:
            sentence = selector.xpath("./text()").get()  # 提取标签里的语句
            # 另一个提取数据的方法：selector.xpath("./text()").extract_first()
            sentence_list.append(sentence)

        print(sentence_list)
```

- 需要注意的几个点（`settings.py`相关内容）

  - `ROBOTSTXT_OBEY = True`    是否遵守君子协议

  - `DEFAULT_REQUEST_HEADERS`   

    -  防反爬虫的一个方法，在这个字典里加一个`User-Agent`
    - 这个键的值随便去一个页面的http响应头里查找复制即可

  - `LOG_LEVEL = 'WARN'`    设置日志级别，假设设置为WARN级别才显示，那么WARN以下级别的日志都不输出了

- 补充：若需要翻页，可按如下方式操作

  ```python
  next_url = response.xpath('xxx').get()  # 想办法提取下一页的url
  if next_page:
      yield srcapy.Request(next_url, callback=self.parse)  # 将请求到的响应交给自己处理
  ```

## （4）运行爬虫

- 然后在命令行里允许命令以开始爬虫，如下

```shell
dream:tutorial dream$ scrapy crawl quotes  # 执行该命令运行爬虫，quotes为创建的爬虫的名字
2020-05-17 00:46:05 [scrapy.utils.log] INFO: Scrapy 2.0.1 started (bot: tutorial)
...  # 这些内容略去
2020-05-17 00:46:06 [scrapy.core.engine] DEBUG: Crawled (200) <GET http://quotes.toscrape.com/page/1/> (referer: None)  # 下面就是我提取到的数据，和网页一致
['“The world as we have created it is a process of our thinking. It cannot be changed without changing our thinking.”', '“It is our choices, Harry, that show what we truly are, far more than our abilities.”', '“There are only two ways to live your life. One is as though nothing is a miracle. The other is as though everything is a miracle.”', '“The person, be it gentleman or lady, who has not pleasure in a good novel, must be intolerably stupid.”', "“Imperfection is beauty, madness is genius and it's better to be absolutely ridiculous than absolutely boring.”", '“Try not to become a man of success. Rather become a man of value.”', '“It is better to be hated for what you are than to be loved for what you are not.”', "“I have not failed. I've just found 10,000 ways that won't work.”", "“A woman is like a tea bag; you never know how strong it is until it's in hot water.”", '“A day without sunshine is like, you know, night.”']
2020-05-17 00:46:06 [scrapy.core.engine] INFO: Closing spider (finished)
...  # 这些内容略去
```

## （5）保存数据

- 如下

  ```
  scrapy crawl quotes -o name.json
  或者
  scrapy crawl quotes -o name.csv
  ```




# 5、可能遇到的问题

## （1）scrapy shell被拒绝

- 解决办法
  - 第一步：修改settings.py里的USER_AGENT，如`Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36`
  - 第二步：到项目目录里面去运行命令，这样settings.py才能覆盖默认的设置

## （2）破解反爬虫：字符映射反爬策略

- 反爬原理：使用css3的font-face
- 解决办法：获取字体文件，动态解码
  - https://blog.csdn.net/weixin_39850787/article/details/111013841
  - https://blog.csdn.net/weixin_41804512/article/details/108871124

## （3）破解反爬虫：图片懒加载

- 反爬原理：图片在未进入可视区域之前，链接是保存在伪属性中的，比如src2，当图片进入可视区域后才会变成src属性，而请求是没有可视区域的
- 解决办法：直接提取对应的伪属性

## （4）自动获取cookie

- 使用`requests.Session()`对象发起请求，如果产生cookie，则该cookie会保存到该session对象中，下次用该session请求即可
- 第一次使用session请求，捕获cookie，再次使用session获取数据

## （5）免费代理服务器

- https://www.zdaye.com/shanghai_ip.html#Free

- 封装代理池

  - 获取代理IP

  - 代理池：列表

    ```python
    [
    	{
    		'http': '...',
    		'https': '...'
    	},
    	{
    		'http': '...',
    		'https': '...'
    	},
    	{
    		'http': '...',
    		'https': '...'
    	},
    ]
    ```


## （6）动态参数获取

- 隐藏在前台页面
- 抓包找到对应的请求，拿到请求参数