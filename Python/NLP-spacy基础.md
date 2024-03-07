[TOC]

# 一、词语、短语、名字和概念的检索

## 1、文本、跨度和词符

- 导入spacy库

  ```python
  In [1]: from spacy.lang.zh import Chinese
  
  In [2]: nlp = Chinese()
  ```

- 概念

  - 文本（documents）

  ```python
  In [3]: doc = nlp('你好，我是熊治杰。')
  
  In [4]: doc
  Out[4]: 你好，我是熊治杰。
  
  In [5]: doc[0]
  Out[5]: 你
  
  In [6]: doc[0:2]
  Out[6]: 你好
  ```

  - 词符（tokens）

  ```python
  In [7]: for token in doc:
     ...:     print(token.text)
     ...:     
  你
  好
  ，
  我
  是
  熊
  治
  杰
  。
  
  In [8]: token = doc[0]
  
  In [9]: token
  Out[9]: 你
  
  In [10]: token.text
  Out[10]: '你'
  ```

  - 跨度（spans）

  ```python
  In [11]: span = doc[3:8]
  
  In [12]: span
  Out[12]: 我是熊治杰
  
  In [13]: span.text
  Out[13]: '我是熊治杰'
  ```

- 常用词符属性

  - `is_alpha` 检测词符是否由字母表字符组成
  - `is_punct` 检测词符是否是标点符号
  - `like_num` 检测词符是否_代表了_一个数字

  ```python
  In [14]: print("Index:   ", [token.i for token in doc])
  Index:    [0, 1, 2, 3, 4, 5, 6, 7, 8]
  
  In [15]: print("Text:    ", [token.text for token in doc])
  Text:     ['你', '好', '，', '我', '是', '熊', '治', '杰', '。']
  
  In [16]: print("is_alpha:", [token.is_alpha for token in doc])
  is_alpha: [True, True, False, True, True, True, True, True, False]
  
  In [17]: print("is_punct:", [token.is_punct for token in doc])
  is_punct: [False, False, True, False, False, False, False, False, True]
  
  In [18]: print("like_num:", [token.like_num for token in doc])
  like_num: [False, False, False, False, False, False, False, False, False]
  ```

## 2、统计模型

- 统计模型让spaCy可以通过语境来做抽取，抽取结果通常包括了词性标注、依存关系和命名实体。

- 下载模型

  - 在线加载

    ```shell
    python -m spacy download en  # 自动安装最合适的英文语料模块
    python -m spacy download zh  # 自动安装最合适的中文语料模块
    python -m spacy download [语言缩写]  # 自动安装最合适的语料模块
    python -m spacy download en_core_web_sm  # 安装指定模块，版本号自动匹配
    ```

  - 离线下载后加载：如`https://github.com/explosion/spacy-models/releases/download/zh_core_web_md-2.3.1.tar.gz`

    ```python
    dream:~ dream$ pip install ~/Desktop/StudyData/毕设/zh_core_web_md-2.3.1.tar.gz  # 下载好后安装导入
    ```

  -  最新spacy两个版本对应的模块及版本

    ```json
    {
      "spacy": {
        "3.0.0": {
          "zh_core_web_sm": ["3.0.0a0"],
          "zh_core_web_md": ["3.0.0a0"],
          "zh_core_web_lg": ["3.0.0a0"],
          "zh_core_web_trf": ["3.0.0a0"],
          "en_core_web_sm": ["3.0.0a0"],
          "en_core_web_md": ["3.0.0a0"],
          "en_core_web_lg": ["3.0.0a0"],
          "en_core_web_trf": ["3.0.0a0"],
          "en_vectors_web_lg": ["3.0.0a0"]
        },
        "2.3.5": {
          "zh_core_web_sm": ["2.3.1", "2.3.0"],
          "zh_core_web_md": ["2.3.1", "2.3.0"],
          "zh_core_web_lg": ["2.3.1", "2.3.0"],
          "en_core_web_sm": ["2.3.1", "2.3.0"],
          "en_core_web_md": ["2.3.1", "2.3.0"],
          "en_core_web_lg": ["2.3.1", "2.3.0"],
          "en_trf_bertbaseuncased_lg": ["2.3.0"],
          "en_trf_xlnetbasecased_lg": ["2.3.0"],
          "en_trf_robertabase_lg": ["2.3.0"],
          "en_trf_distilbertbaseuncased_lg": ["2.3.0"],
        }
    }
    ```

- 代码中导入模型

  ```python
  In [1]: import spacy
  
  In [2]: nlp = spacy.load('zh_core_web_md')
  Building prefix dict from the default dictionary ...
  Loading model from cache /var/folders/xx/5zswwj0n063dy9k_c9v6c1dh0000gn/T/jieba.cache
  Loading model cost 0.845 seconds.
  Prefix dict has been built successfully.
  ```

- 词性标注、依存关系和命名实体示例

  ```python
  In [5]: doc = nlp('我想学编程。')
  
  # 词性标注
  In [6]: for token in doc:
     ...:     print(token.text, '： ', token.pos_)
     ...:     
  我 ：  PRON
  想 ：  VERB
  学 ：  VERB
  编程 ：  NOUN
  。 ：  PUNCT
  
  # 依存关系，即词与词之间的关系，比如一个词是某一个句子或者物体的主语。
  In [7]: for token in doc:
     ...:     print(token.text, token.pos_, token.dep_, token.head.text)
     ...:     
  我 PRON nsubj 想  # nsubj是名词主语，这里“我”是“想”的名词主语
  想 VERB ROOT 想
  学 VERB ccomp 想
  编程 NOUN dobj 学  # dobj是目的语，这里“编程”是“学”的目的语
  。 PUNCT punct 
  
  # 命名实体，即那些被赋予了名字的真实世界的物体，比如一个人、一个组织或者一个国家。
  In [10]: doc = nlp("微软准备用十亿美金买下这家英国的创业公司。")
  
  In [11]: for ent in doc.ents:
      ...:     print(ent.text, ent.label_)
  微软 ORG
  十亿美金 MONEY
  英国 GPE
  
  # 标注和标注定义
  In [12]: spacy.explain("GPE")
  Out[12]: 'Countries, cities, states'
  
  In [13]: spacy.explain("NNP")
  Out[13]: 'noun, proper singular'
  
  In [14]: spacy.explain("dobj")
  Out[14]: 'direct object'
  
  In [15]: spacy.explain('nsubj')
  Out[15]: 'nominal subject'
  
  In [16]: spacy.explain('ROOT')
  
  In [17]: spacy.explain('ccomp')
  Out[17]: 'clausal complement'
  ```

## 3、基于规则的匹配抽取

- 与正则表达式相比，matcher是配合`Doc`和`Token`这样的方法来使用的， 而不是只作用于字符串上。

- 模版匹配

  ```python
  In [1]: import spacy
  
  In [2]: from spacy.matcher import Matcher
  
  In [3]: nlp = spacy.load("zh_core_web_md")
  Building prefix dict from the default dictionary ...
  Loading model from cache /var/folders/xx/5zswwj0n063dy9k_c9v6c1dh0000gn/T/jieba.cache
  Loading model cost 0.872 seconds.
  Prefix dict has been built successfully.
  
  # 用模型分享出的vocab初始化matcher
  In [4]: matcher = Matcher(nlp.vocab)
  
  # 给matcher加入模板
  In [5]: pattern = [{"TEXT": "iPhone"}, {"TEXT": "X"}]
  
  # 第一个参数：唯一ID；第二个参数：回调参数；第三个参数：模版变量
  In [6]: matcher.add("IPHONE_PATTERN", None, pattern)
  
  In [7]: doc = nlp("即将上市的iPhone X发布日期被泄露了")
  
  In [8]: matches = matcher(doc)
  
  In [9]: matches
  Out[9]: [(9528407286733565721, 3, 5)]
  
  In [10]: for match_id, start, end in matches:
      ...:     # 获取匹配的跨度
      ...:     matched_span = doc[start:end]
      ...:     print(matched_span.text)
  iPhone X
  ```

  - 模版（列表，列表元素是字典）

    ```python
    # 匹配词符的完全一致的文字
    [{"TEXT": "iPhone"}, {"TEXT": "X"}]
    # 匹配词汇属性
    [{"LOWER": "iphone"}, {"LOWER": "x"}]
    # 匹配任意的词符属性
    [{"LEMMA": "buy"}, {"POS": "NOUN"}]
    ```

  - 例子

    ```python
    # 例子1
    In [11]: pattern = [
        ...:     {"IS_DIGIT": True},
        ...:     {"LOWER": "国际"},
        ...:     {"LOWER": "足联"},
        ...:     {"LOWER": "世界杯"},
        ...:     {"IS_PUNCT": True}
        ...: ]
    
    In [12]: matcher.add('test', None, pattern)
    
    In [13]: doc = nlp("2018国际足联世界杯：法国队赢了！")
    
    In [14]: matches = matcher(doc)
    
    In [15]: matches
    Out[15]: [(1618900948208871284, 0, 5)]
    
    In [16]: for match_id, start, end in matches:
        ...:     matched_span = doc[start:end]
        ...:     print(matched_span.text)
    2018国际足联世界杯：
    
    # 例子2
    In [17]: pattern = [
        ...:     {"LEMMA": "喜欢", "POS": "VERB"},
        ...:     {"POS": "NOUN"}
        ...: ]
    
    In [18]: doc = nlp('我喜欢书，也喜欢游戏。')
    
    In [21]: matcher.add('test2', None, pattern)
    
    In [22]: matches = matcher(doc)
    
    In [23]: for match_id, start, end in matches:
        ...:     matched_span = doc[start:end]
        ...:     print(matched_span.text)  
    喜欢书
    喜欢游戏
    
    # 例子3：使用运算符和量词
    # {"OP": "!"}	否定: 0次匹配
    # {"OP": "?"}	可选: 0次或1次匹配
    # {"OP": "+"}	1次或更多次匹配
    # {"OP": "*"}	0次或更多次匹配
    In [25]: pattern = [
        ...:     {"LEMMA": "买"},
        ...:     {"POS": "NUM", "OP": "?"},  # 可选: 匹配0次或者1次
        ...:     {"POS": "NOUN"}
        ...: ]
    
    In [26]: matcher.add('test3', None, pattern)
    
    In [27]: doc = nlp("我买个肉夹馍。我还要买凉皮。")
    
    In [28]: matches = matcher(doc)
    
    In [29]: for match_id, start, end in matches:
        ...:     matched_span = doc[start:end]
        ...:     print(matched_span.text)   
    买个肉夹馍
    买凉皮
    ```

# 二、使用spaCy进行大规模数据分析

## 1、数据结构：Vocab, Lexemes和StringStore

- 共享词汇表和字符串库：采用hash的方法存储词汇

  ```python
  In [1]: import spacy
  
  In [2]: nlp = spacy.load('zh_core_web_md')
  Building prefix dict from the default dictionary ...
  Loading model from cache /var/folders/xx/5zswwj0n063dy9k_c9v6c1dh0000gn/T/jieba.cache
  Loading model cost 0.851 seconds.
  Prefix dict has been built successfully.
  
  In [3]: dream_hash = nlp.vocab.strings['dream']
  
  In [4]: dream_hash
  Out[4]: 15068273739048504437
  
  In [5]: dream_string = nlp.vocab.strings[dream_hash]
  
  In [6]: dream_string
  Out[6]: 'dream'
     
  # doc也会暴露出词汇表和字符串，doc与nlp的词汇表独立
  In [7]: doc = nlp('我爱打篮球。')
  
  In [8]: baseketball_hash = doc.vocab.strings['篮球']
  
  In [9]: baseketball_hash
  Out[9]: 14024677897207006562
  
  In [10]: baseketball_string = doc.vocab.strings[baseketball_hash]
  
  In [11]: baseketball_string
  Out[11]: '篮球'
  
  # doc与nlp的词汇表独立，所以用doc的hash到nlp里搜索结果为空
  In [12]: baseketball_string = nlp.vocab.strings[baseketball_hash]
  ```

- 语素：词汇表中与语境无关的元素

  ```python
  In [16]: lexeme = nlp.vocab['绿茶']
  
  In [17]: print(lexeme.text, lexeme.orth, lexeme.is_alpha)
  绿茶 385439745240711484 True
  ```

- doc包含了语境中的词汇以及它们的词性标注和依存关系，每个词符对应一个语素lexeme，里面保存着词汇的哈希ID。 要拿到这个词的文本表示，spaCy要在字符串库里面查找它的哈希值。

- 使用`nlp(string)`时就可以把新的词汇加入nlp.vocab中

## 2、数据结构：Doc、Span和Token

- Doc

  ```python
  # 创建一个nlp实例
  from spacy.lang.en import English
  nlp = English()
  
  # 导入Doc类
  from spacy.tokens import Doc
  
  # 用来创建doc的词汇和空格
  words = ["Hello", "world", "!"]
  spaces = [True, False, False]
  
  # 手动创建一个doc，相对地，nlp('Hello world!')就是自动初始化一个Doc对象
  doc = Doc(nlp.vocab, words=words, spaces=spaces)
  ```

  - 实例化Doc时可以传入一个vocab

- Span

  ![image-20210325094142724](/Users/dream/Desktop/StudyData/毕设/img/spacy-DocSpanToken.png)

  ```python
  # 导入Doc和Span类
  from spacy.tokens import Doc, Span
  
  # 创建doc所需要的词汇和空格
  words = ["Hello", "world", "!"]
  spaces = [True, False, False]
  
  # 手动创建一个doc
  doc = Doc(nlp.vocab, words=words, spaces=spaces)
  
  # 手动创建一个span，相对地，doc[0:2]就是自动创建一个Span对象
  span = Span(doc, 0, 2)
  
  # 创建一个带标签的span
  span_with_label = Span(doc, 0, 2, label="GREETING")
  
  # 把span加入到doc.ents（命名实体）中
  doc.ents = [span_with_label]
  ```

- 例子

  ```python
  In [1]: from spacy.lang.zh import Chinese
     ...: 
     ...: nlp = Chinese()
     ...: 
     ...: # 导入Doc和Span类
     ...: from spacy.tokens import Doc, Span
     ...: 
     ...: words = ["我", "喜欢", "周", "杰伦"]
     ...: spaces = [False, False, False, False]
     ...: 
     ...: # 用words和spaces创建一个doc
     ...: doc = Doc(nlp.vocab, words=words, spaces=spaces)
     ...: print(doc.text)
     ...: 
     ...: # 为doc中的"周杰伦"创建一个span，并赋予其"PERSON"的标签
     ...: span = Span(doc, 2, 4, label="PERSON")
     ...: print(span.text, span.label_)
     ...: 
     ...: # 把这个span加入到doc的实体中
     ...: doc.ents = [span]
     ...: 
     ...: # 打印所有实体的文本和标签
     ...: print([(ent.text, ent.label_) for ent in doc.ents])
  Building prefix dict from the default dictionary ...
  Loading model from cache /var/folders/xx/5zswwj0n063dy9k_c9v6c1dh0000gn/T/jieba.cache
  Loading model cost 0.872 seconds.
  Prefix dict has been built successfully.
  我喜欢周杰伦
  周杰伦 PERSON
  [('周杰伦', 'PERSON')]
  ```

- 例子

  ```python
  In [3]: import spacy
     ...: 
     ...: nlp = spacy.load("zh_core_web_md")
     ...: doc = nlp("北京是一座美丽的城市。")
     ...: 
     ...: # 遍历所有的词符
     ...: for token in doc:
     ...:     # 检查当前词符是否是一个专有名词
     ...:     if token.pos_ == "PROPN":
     ...:         # 检查下一个词符是否是一个动词
     ...:         if doc[token.i + 1].pos_ == "VERB":
     ...:             print("找到了动词前面的一个专有名词:", token.text)
  找到了动词前面的一个专有名词: 北京
  ```

## 3、词向量和语义相识度

- 要计算相似度，我们必须需要一个比较大的含有词向量的spaCy模型。比如，我们可以用中等或者大的英文模型，但不能用小模型。

  ```python
  In [1]: import spacy
  
  In [2]: nlp = spacy.load('zh_core_web_md')
  Building prefix dict from the default dictionary ...
  Loading model from cache /var/folders/xx/5zswwj0n063dy9k_c9v6c1dh0000gn/T/jieba.cache
  Loading model cost 0.839 seconds.
  Prefix dict has been built successfully.
  
  In [3]: li = ['我想打球。', '我喜欢看书', '我明天要出去', '吃饭了吗？', '我想看电视']
  
  In [5]: docs = [nlp(item) for item in li]
  
  In [7]: print(docs[0].similarity(docs[1]))
  0.6130181807719022
  
  In [8]: print(docs[0].similarity(docs[2]))
  0.7751346007288319
  
  In [9]: print(docs[0].similarity(docs[3]))
  0.6314630709787792
  
  In [10]: print(docs[0].similarity(docs[4]))
  0.7198500273693017
  
  In [11]: print(docs[1].similarity(docs[2]))
  0.5273727992198902
  
  In [12]: print(docs[1].similarity(docs[3]))
  0.4949605829784323
  
  In [13]: print(docs[1].similarity(docs[4]))
  0.8089280265571016
  
  In [14]: print(docs[2].similarity(docs[3]))
  0.6552734075152615
  
  In [15]: print(docs[2].similarity(docs[4]))
  0.636252033096267
  
  In [16]: print(docs[3].similarity(docs[4]))
  0.5639068375596534
  ```

  - 词符（token）也可以比较相似度
  
- 获取词向量

  ```python
  In [1]: import spacy
  
  In [2]: nlp = spacy.load('zh_core_web_md')
  Building prefix dict from the default dictionary ...
  Dumping model to file cache /var/folders/xx/5zswwj0n063dy9k_c9v6c1dh0000gn/T/jieba.cache
  Loading model cost 1.096 seconds.
  Prefix dict has been built successfully.
  
  In [3]: doc = nlp('我想学编程。')
  
  In [4]: doc[3:5].vector
  Out[4]: 
  array([ 1.16095   ,  1.4994    ,  1.3886001 ,  1.8088    ,  0.26770002,
  ...
  ```

## 4、结合模型与规则

- 统计模型适用场景：需要能够根据一些例子而进行泛化

  - 举个例子，统计模型通常可以优化产品和人名的识别。 相比于给出一个所有曾经出现过的人名库，你的应用可以判断一段文本中的几个词符是否是人名。 相类似的你也可以预测依存关系标签从而得到主宾关系。
  - 我们可以使用spaCy的实体识别器、依存句法识别器或者词性标注器来完成这些任务。

- 规则适用场景：要查找的例子差不多是有限个的时候

  - 比如世界上所有的国家名或者城市名、药品名或者甚至狗的种类。
  - 在spaCy中我们可以用定制化的分词规则以及matcher和phrase matcher这样的匹配器来完成这些任务。

- 高效短语匹配：PhraseMatcher

  ```python
  In [11]: from spacy.matcher import PhraseMatcher
      ...: 
      ...: matcher = PhraseMatcher(nlp.vocab)
      ...: 
      ...: pattern = nlp("Golden Retriever")  
      ...: matcher.add("DOG", None, pattern)  # # 实例化需要一个Doc而不是字典
      ...: doc = nlp("I have a Golden Retriever")
      ...: 
      ...: # 遍历匹配结果
      ...: for match_id, start, end in matcher(doc):
      ...:     # 获取匹配到的span
      ...:     span = doc[start:end]
      ...:     print("Matched span:", span.text)
      ...: 
      ...: 
  Matched span: Golden Retriever
  ```

  