[TOC]

# 1、pandas数据类型

## （1）Series

- 创建Series（一维数据）

```python
# 指定内容，默认索引
In [4]: pd.Series(np.arange(0, 10, 2))
Out[4]: 
0    0
1    2
2    4
3    6
4    8
dtype: int64

# 指定索引
In [5]: pd.Series(np.arange(0, 10, 2), index=['a', 'b', 'c', 'd', 'e'])
Out[5]: 
a    0
b    2
c    4
d    6
e    8
dtype: int64

# 使用字典创建Series
In [6]: pd.Series({'li': 10, 'wang': 20, 'zhao': 30})
Out[6]: 
li      10
wang    20
zhao    30
dtype: int64
  
In [7]: pd.Series({'li': 10, 'wang': 20, 'zhao': 30}).index
Out[7]: Index(['li', 'wang', 'zhao'], dtype='object')

In [8]: pd.Series({'li': 10, 'wang': 20, 'zhao': 30}).values
Out[8]: array([10, 20, 30])

In [9]: pd.Series({'li': 10, 'wang': 20, 'zhao': 30})['li']
Out[9]: 10
```

## （2）DataFrame

- 二维数据，行和列
  - 行索引：index，0轴，axis=0
  - 列索引：column，1轴，axis=1

```python
In [10]: x = np.array([[1, 2, 3], [4, 5, 6]])

In [15]: index = ['第{}行'.format(str(i+1)) for i in range(x.shape[0])]

In [16]: column = ['第{}列'.format(str(i+1)) for i in range(x.shape[1])]

# 若不指定index和columns，则默认为0～N
In [17]: d.DataFrame(x, index=index, columns=column)
Out[17]: 
     第1列  第2列  第3列
第1行    1    2    3
第2行    4    5    6

In [18]: pd.DataFrame(x, index=index, columns=column).shape
Out[18]: (2, 3)

In [19]: pd.DataFrame(x, index=index, columns=column).index
Out[19]: Index(['第1行', '第2行'], dtype='object')

In [20]: pd.DataFrame(x, index=index, columns=column).columns
Out[20]: Index(['第1列', '第2列', '第3列'], dtype='object')

In [21]: pd.DataFrame(x, index=index, columns=column).values
Out[21]: 
array([[1, 2, 3],
       [4, 5, 6]])

# 转置
In [22]: pd.DataFrame(x, index=index, columns=column).T
Out[22]: 
     第1行  第2行
第1列    1    4
第2列    2    5
第3列    3    6

# 前n行，默认为5
In [24]: pd.DataFrame(x, index=index, columns=column).head(1)
Out[24]: 
     第1列  第2列  第3列
第1行    1    2    3

# 后n行，默认为5
In [25]: pd.DataFrame(x, index=index, columns=column).tail(1)
Out[25]: 
     第1列  第2列  第3列
第2行    4    5    6
```

- 修改索引：给index赋值或者set_index方法

```python
In [26]: data = pd.DataFrame(x, index=index, columns=column)

In [27]: data
Out[27]: 
     第1列  第2列  第3列
第1行    1    2    3
第2行    4    5    6

In [30]: data.index = list(range(len(data.index)))

In [31]: data
Out[31]: 
   第1列  第2列  第3列
0    1    2    3
1    4    5    6

In [36]: data = pd.DataFrame(x, index=index, columns=column)

In [37]: data
Out[37]: 
     第1列  第2列  第3列
第1行    1    2    3
第2行    4    5    6

# 重设索引
In [38]: data.reset_index()
Out[38]: 
  index  第1列  第2列  第3列
0   第1行    1    2    3
1   第2行    4    5    6

In [39]: data
Out[39]: 
     第1列  第2列  第3列
第1行    1    2    3
第2行    4    5    6

# 把某一列设置为index
In [42]: data = pd.DataFrame({'month': [1, 2, 3], 'mean_sale': [100, 200, 300], 'max_sale': [170, 230, 360]})

In [43]: data
Out[43]: 
   max_sale  mean_sale  month
0       170        100      1
1       230        200      2
2       360        300      3

In [44]: data.set_index('month')
Out[44]: 
       max_sale  mean_sale
month                     
1           170        100
2           230        200
3           360        300
```

## （3）MultiIndex

- 三维数据：在Series或DataFrame上拥有两个或以上的索引

# 2、基本操作

## （1）文件读取

- 读取网页文件：`pandas.read_csv(url)`

  - 可能报错：全局取消证书验证

    ```python
    In [4]: import ssl
    
    In [5]: ssl._create_default_https_context = ssl._create_unverified_context
    ```

    

- csv格式文件

  - `pandas.read_csv(path_or_buf, sep=',', usecols)`：读取csv文件
    - sep：分隔符
    - usecols：指定读取的列名，列表形式
  - `DataFrame.to_csv(path_or_buf, sep=',', columns=None, header=True, index=True, mode='w', encoding=None)`
    - columns：列索引
    - header：是否写进索引值，为布尔值或者字符串列表
    - index：是否写进索引
    - mode：w是重写，a是追加

  ```python
  # 读取文件
  In [1]: import numpy as np
  
  In [2]: import pandas as pd
  
  In [3]: import os
  
  In [4]: os.system('pwd')
  /Users/dream/.virtualenvs/MLstudy/data
  Out[4]: 0
  
  In [5]: os.system('ls')
  IMDB-Movie-Data.csv            day_close.h5                   stock_day.csv                  
  Sarcasm_Headlines_Dataset.json starbucks                                             
  Out[5]: 0
  
  In [6]: data_csv1 = pd.read_csv('./stock_day.csv')
  
  In [7]: data_csv1.head()
  Out[7]: 
               open   high  close    low    volume  price_change  p_change  \
  2018-02-27  23.53  25.88  24.16  23.53  95578.03          0.63      2.68   
  2018-02-26  22.80  23.78  23.53  22.80  60985.11          0.69      3.02   
  2018-02-23  22.88  23.37  22.82  22.71  52914.01          0.54      2.42   
  2018-02-22  22.25  22.76  22.28  22.02  36105.01          0.36      1.64   
  2018-02-14  21.49  21.99  21.92  21.48  23331.04          0.44      2.05   
  
                 ma5    ma10    ma20     v_ma5    v_ma10    v_ma20  turnover  
  2018-02-27  22.942  22.142  22.875  53782.64  46738.65  55576.11      2.39  
  2018-02-26  22.406  21.955  22.942  40827.52  42736.34  56007.50      1.53  
  2018-02-23  21.938  21.929  23.022  35119.58  41871.97  56372.85      1.32  
  2018-02-22  21.446  21.909  23.137  35397.58  39904.78  60149.60      0.90  
  2018-02-14  21.366  21.923  23.253  33590.21  42935.74  61716.11      0.58  
  
  In [8]: data_csv2 = pd.read_csv('./stock_day.csv', usecols=['open', 'close'])
  
  In [10]: data_csv2.head()
  Out[10]: 
               open  close
  2018-02-27  23.53  24.16
  2018-02-26  22.80  23.53
  2018-02-23  22.88  22.82
  2018-02-22  22.25  22.28
  2018-02-14  21.49  21.92
  
  
  
  # 保存文件
  In [12]: data_csv2['open'].head()
  Out[12]: 
  2018-02-27    23.53
  2018-02-26    22.80
  2018-02-23    22.88
  2018-02-22    22.25
  2018-02-14    21.49
  Name: open, dtype: float64
  
  In [13]: data_csv2['open'].to_csv('./stock_day_open.csv', header=['开盘价'])
      
  # 发现原来的列索引变成了单独的一列
  In [15]: pd.read_csv('./stock_day_open.csv').head()
  Out[15]: 
     Unnamed: 0    开盘价
  0  2018-02-27  23.53
  1  2018-02-26  22.80
  2  2018-02-23  22.88
  3  2018-02-22  22.25
  4  2018-02-14  21.49
  
  # 重新保存
  In [25]: data_csv2['open'].to_csv('./stock_day_open_new.csv', header=['开盘价'], index=False)
  
  In [26]: pd.read_csv('./stock_day_open_new.csv').head()
  Out[26]: 
       开盘价
  0  23.53
  1  22.80
  2  22.88
  3  22.25
  4  21.49
  ```

- json格式文件

  - `pandas.read_json(path_or_buf, orient=None, type='frame', lines=False)`
    - orient：期待的读取json后的数据格式
      - `split`
      - `records`
      - `index`
      - `columns`
      - `values`
    - lines：是否按照每行读取文件
    - typ：转换为`frame`还是`series`
  - `DataFrame.to_json(path_or_buf, orient=None, lines=None)`

  ```python
  # json文件内容（一行一个json对象）
  {"article_link": "https://www.huffingtonpost.com/entry/versace-black-code_us_5861fbefe4b0de3a08f600d5", "headline": "former versace store clerk sues over secret 'black code' for minority shoppers", "is_sarcastic": 0}
  {"article_link": "https://www.huffingtonpost.com/entry/roseanne-revival-review_us_5ab3a497e4b054d118e04365", "headline": "the 'roseanne' revival catches up to our thorny political mood, for better and worse", "is_sarcastic": 0}
  ...
  
  
  # 读取文件
  In [27]: os.system('ls')
  IMDB-Movie-Data.csv            day_close.h5                   stock_day.csv                  stock_day_open_new.csv
  Sarcasm_Headlines_Dataset.json starbucks                      stock_day_open.csv
  
  # records
  In [30]: pd.read_json('./Sarcasm_Headlines_Dataset.json', orient='records', lines=True).head()
  Out[30]: 
                                          article_link  \
  0  https://www.huffingtonpost.com/entry/versace-b...   
  1  https://www.huffingtonpost.com/entry/roseanne-...   
  2  https://local.theonion.com/mom-starting-to-fea...   
  3  https://politics.theonion.com/boehner-just-wan...   
  4  https://www.huffingtonpost.com/entry/jk-rowlin...   
  
                                              headline  is_sarcastic  
  0  former versace store clerk sues over secret 'b...             0  
  1  the 'roseanne' revival catches up to our thorn...             0  
  2  mom starting to fear son's web series closest ...             1  
  3  boehner just wants wife to listen, not come up...             1  
  4  j.k. rowling wishes snape happy birthday in th...             0  
  
  # columns
  In [32]: pd.read_json('./Sarcasm_Headlines_Dataset.json', orient='columns', lines=True).head()
  Out[32]: 
                                          article_link  \
  0  https://www.huffingtonpost.com/entry/versace-b...   
  1  https://www.huffingtonpost.com/entry/roseanne-...   
  2  https://local.theonion.com/mom-starting-to-fea...   
  3  https://politics.theonion.com/boehner-just-wan...   
  4  https://www.huffingtonpost.com/entry/jk-rowlin...   
  
                                              headline  is_sarcastic  
  0  former versace store clerk sues over secret 'b...             0  
  1  the 'roseanne' revival catches up to our thorn...             0  
  2  mom starting to fear son's web series closest ...             1  
  3  boehner just wants wife to listen, not come up...             1  
  4  j.k. rowling wishes snape happy birthday in th...             0 
  
  # index，有点像转置
  In [31]: pd.read_json('./Sarcasm_Headlines_Dataset.json', orient='index', lines=True).head()
  Out[31]: 
                                                            0      \
  article_link  https://www.huffingtonpost.com/entry/versace-b...   
  headline      former versace store clerk sues over secret 'b...   
  is_sarcastic
  ...
  [3 rows x 26709 columns]
  
  # values
  In [33]: pd.read_json('./Sarcasm_Headlines_Dataset.json', orient='values', lines=True).head()
  Out[33]: 
                                          article_link  \
  0  https://www.huffingtonpost.com/entry/versace-b...   
  1  https://www.huffingtonpost.com/entry/roseanne-...   
  2  https://local.theonion.com/mom-starting-to-fea...   
  3  https://politics.theonion.com/boehner-just-wan...   
  4  https://www.huffingtonpost.com/entry/jk-rowlin...   
  
                                              headline  is_sarcastic  
  0  former versace store clerk sues over secret 'b...             0  
  1  the 'roseanne' revival catches up to our thorn...             0  
  2  mom starting to fear son's web series closest ...             1  
  3  boehner just wants wife to listen, not come up...             1  
  4  j.k. rowling wishes snape happy birthday in th...             0 
  
  
  
  
  
  # 保存文件
  In [38]: data_json1['article_link'].to_json('./article_link.json', orient='records')
  
  In [39]: data_json1['article_link'].to_json('./article_link_new.json', orient='records', lines=True)
  
  In [40]: pd.read_json('./article_link.json', orient='records').head()
  Out[40]: 
                                                     0
  0  https://www.huffingtonpost.com/entry/versace-b...
  1  https://www.huffingtonpost.com/entry/roseanne-...
  2  https://local.theonion.com/mom-starting-to-fea...
  3  https://politics.theonion.com/boehner-just-wan...
  4  https://www.huffingtonpost.com/entry/jk-rowlin...
  
  In [42]: pd.read_json('./article_link_new.json', orient='records', lines=True).head()
  Out[42]: 
                                                     0
  0  https://www.huffingtonpost.com/entry/versace-b...
  1  https://www.huffingtonpost.com/entry/roseanne-...
  2  https://local.theonion.com/mom-starting-to-fea...
  3  https://politics.theonion.com/boehner-just-wan...
  4  https://www.huffingtonpost.com/entry/jk-rowlin...
  ```

  - 注意，如果json文件有多行，必须lines=True

- hdf5文件格式
  
  - `pandas.read_hdf()`和`DataFrame.to_hdf()`

## （2）基本数据操作

- 索引

  - 注意，DataFrame一定是先列后行索引的，也不支持直接切片（如data[1:3]）
  - DataFrame.loc支持索引切片，DataFrame.iloc支持索引下标切片
  - DataFrame.ix可以结合loc与iloc，但是高版本不再支持

  ```python
  In [45]: data.head()
  Out[45]: 
               open   high  close    low
  2018-02-27  23.53  25.88  24.16  23.53
  2018-02-26  22.80  23.78  23.53  22.80
  2018-02-23  22.88  23.37  22.82  22.71
  2018-02-22  22.25  22.76  22.28  22.02
  2018-02-14  21.49  21.99  21.92  21.48
  
  In [46]: data['open'].head(3)
  Out[46]: 
  2018-02-27    23.53
  2018-02-26    22.80
  2018-02-23    22.88
  Name: open, dtype: float64
  
  In [47]: data['open']['2018-02-27']
  Out[47]: 23.53
  
  In [48]: data.loc['2018-02-27':'2018-02-22', 'open':'close']
  Out[48]: 
               open   high  close
  2018-02-27  23.53  25.88  24.16
  2018-02-26  22.80  23.78  23.53
  2018-02-23  22.88  23.37  22.82
  2018-02-22  22.25  22.76  22.28
  
  In [49]: data.iloc[:3, :3]
  Out[49]: 
               open   high  close
  2018-02-27  23.53  25.88  24.16
  2018-02-26  22.80  23.78  23.53
  2018-02-23  22.88  23.37  22.82
  ```

- 赋值

  ```python
  In [50]: data.head()
  Out[50]: 
               open   high  close    low
  2018-02-27  23.53  25.88  24.16  23.53
  2018-02-26  22.80  23.78  23.53  22.80
  2018-02-23  22.88  23.37  22.82  22.71
  2018-02-22  22.25  22.76  22.28  22.02
  2018-02-14  21.49  21.99  21.92  21.48
  
  In [51]: data['open'] = 100
  
  In [52]: data.head()
  Out[52]: 
              open   high  close    low
  2018-02-27   100  25.88  24.16  23.53
  2018-02-26   100  23.78  23.53  22.80
  2018-02-23   100  23.37  22.82  22.71
  2018-02-22   100  22.76  22.28  22.02
  2018-02-14   100  21.99  21.92  21.48
  
  In [53]: data.open = 200
  
  In [54]: data.head()
  Out[54]: 
              open   high  close    low
  2018-02-27   200  25.88  24.16  23.53
  2018-02-26   200  23.78  23.53  22.80
  2018-02-23   200  23.37  22.82  22.71
  2018-02-22   200  22.76  22.28  22.02
  2018-02-14   200  21.99  21.92  21.48
  ```

- 排序

  ```python
  In [56]: data.head()
  Out[56]: 
               open   high  close    low
  2018-02-27  23.53  25.88  24.16  23.53
  2018-02-26  22.80  23.78  23.53  22.80
  2018-02-23  22.88  23.37  22.82  22.71
  2018-02-22  22.25  22.76  22.28  22.02
  2018-02-14  21.49  21.99  21.92  21.48
  
  # 根据value排序：by指定排序的键，可以单个，也可以多个，ascending指定升序/降序
  In [57]: data.sort_values(by='open', ascending=True).head()
  Out[57]: 
               open   high  close    low
  2015-03-02  12.25  12.67  12.52  12.20
  2015-09-02  12.30  14.11  12.36  12.30
  2015-03-03  12.52  13.06  12.70  12.52
  2015-03-04  12.80  12.92  12.90  12.61
  2015-03-05  12.88  13.45  13.16  12.87
  
  In [58]: data.sort_values(by='open', ascending=False).head()
  Out[58]: 
               open   high  close    low
  2015-06-15  34.99  34.99  31.69  31.69
  2015-06-12  34.69  35.98  35.21  34.01
  2015-06-10  34.10  36.35  33.85  32.23
  2017-11-01  33.85  34.34  33.83  33.10
  2015-06-11  33.17  34.98  34.39  32.51
  
  In [59]: data.sort_values(by=['open', 'high'], ascending=False).head()
  Out[59]: 
               open   high  close    low
  2015-06-15  34.99  34.99  31.69  31.69
  2015-06-12  34.69  35.98  35.21  34.01
  2015-06-10  34.10  36.35  33.85  32.23
  2017-11-01  33.85  34.34  33.83  33.10
  2015-06-11  33.17  34.98  34.39  32.51
  
  In [60]: data.head()
  Out[60]: 
               open   high  close    low
  2018-02-27  23.53  25.88  24.16  23.53
  2018-02-26  22.80  23.78  23.53  22.80
  2018-02-23  22.88  23.37  22.82  22.71
  2018-02-22  22.25  22.76  22.28  22.02
  2018-02-14  21.49  21.99  21.92  21.48
  
  # 根据index排序，原本日期是降序的，可以升序排序
  In [61]: data.sort_index().head()
  Out[61]: 
               open   high  close    low
  2015-03-02  12.25  12.67  12.52  12.20
  2015-03-03  12.52  13.06  12.70  12.52
  2015-03-04  12.80  12.92  12.90  12.61
  2015-03-05  12.88  13.45  13.16  12.87
  2015-03-06  13.17  14.48  14.28  13.13
  ```

  - Series排序同理

## （3）基本运算

- 所有元素加减

  ```python
  In [63]: data.head()
  Out[63]: 
               open   high  close    low
  2018-02-27  23.53  25.88  24.16  23.53
  2018-02-26  22.80  23.78  23.53  22.80
  2018-02-23  22.88  23.37  22.82  22.71
  2018-02-22  22.25  22.76  22.28  22.02
  2018-02-14  21.49  21.99  21.92  21.48
  
  In [64]: data1 = data['open']
  
  In [65]: data1.head()
  Out[65]: 
  2018-02-27    23.53
  2018-02-26    22.80
  2018-02-23    22.88
  2018-02-22    22.25
  2018-02-14    21.49
  Name: open, dtype: float64
  
  In [66]: data1.add(10).head()
  Out[66]: 
  2018-02-27    33.53
  2018-02-26    32.80
  2018-02-23    32.88
  2018-02-22    32.25
  2018-02-14    31.49
  Name: open, dtype: float64
  
  In [67]: data1.sub(10).head()
  Out[67]: 
  2018-02-27    13.53
  2018-02-26    12.80
  2018-02-23    12.88
  2018-02-22    12.25
  2018-02-14    11.49
  Name: open, dtype: float64
  ```

- 逻辑运算

  ```python
  In [63]: data.head()
  Out[63]: 
               open   high  close    low
  2018-02-27  23.53  25.88  24.16  23.53
  2018-02-26  22.80  23.78  23.53  22.80
  2018-02-23  22.88  23.37  22.82  22.71
  2018-02-22  22.25  22.76  22.28  22.02
  2018-02-14  21.49  21.99  21.92  21.48
  
  # 逻辑运算返回Series
  In [68]: (data['open'] > 23).head()
  Out[68]: 
  2018-02-27     True
  2018-02-26    False
  2018-02-23    False
  2018-02-22    False
  2018-02-14    False
  Name: open, dtype: bool
  
  # 也可以将逻辑运算结果作为过滤条件
  In [69]: data[data['open'] > 23].head(10)
  Out[69]: 
               open   high  close    low
  2018-02-27  23.53  25.88  24.16  23.53
  2018-02-01  23.71  23.86  22.42  22.22
  2018-01-31  23.85  23.98  23.72  23.31
  2018-01-30  23.71  24.08  23.83  23.70
  2018-01-29  24.40  24.63  23.77  23.72
  2018-01-26  24.27  24.74  24.49  24.22
  2018-01-25  24.99  24.99  24.37  24.23
  2018-01-24  25.49  26.28  25.29  25.20
  2018-01-23  25.15  25.53  25.50  24.93
  2018-01-22  25.14  25.40  25.13  24.75
  
  # 与条件
  In [71]: data[(data['open'] > 23) & (data['open'] < 24)].head(10)
  Out[71]: 
               open   high  close    low
  2018-02-27  23.53  25.88  24.16  23.53
  2018-02-01  23.71  23.86  22.42  22.22
  2018-01-31  23.85  23.98  23.72  23.31
  2018-01-30  23.71  24.08  23.83  23.70
  2018-01-16  23.40  24.60  24.40  23.30
  2018-01-12  23.70  25.15  24.24  23.42
  2018-01-11  23.67  23.85  23.67  23.21
  2017-12-22  23.21  23.39  22.99  22.90
  2017-12-21  23.39  23.50  23.21  22.86
  2017-12-20  23.61  23.96  23.33  23.20
  ```

- 逻辑运算函数

  ```python
  In [78]: data.head()
  Out[78]: 
               open   high  close    low
  2018-02-27  23.53  25.88  24.16  23.53
  2018-02-26  22.80  23.78  23.53  22.80
  2018-02-23  22.88  23.37  22.82  22.71
  2018-02-22  22.25  22.76  22.28  22.02
  2018-02-14  21.49  21.99  21.92  21.48
  
  # 查询字符串
  In [79]: data.query('open>23 & open<24').head()
  Out[79]: 
               open   high  close    low
  2018-02-27  23.53  25.88  24.16  23.53
  2018-02-01  23.71  23.86  22.42  22.22
  2018-01-31  23.85  23.98  23.72  23.31
  2018-01-30  23.71  24.08  23.83  23.70
  2018-01-16  23.40  24.60  24.40  23.30
  
  # 判断是否为23.53
  In [80]: data['open'].isin([23.53]).head()
  Out[80]: 
  2018-02-27     True
  2018-02-26    False
  2018-02-23    False
  2018-02-22    False
  2018-02-14    False
  Name: open, dtype: bool
  
  # 判断是否为23.53或23.71
  In [81]: data['open'].isin([23.53, 23.71]).head()
  Out[81]: 
  2018-02-27     True
  2018-02-26    False
  2018-02-23    False
  2018-02-22    False
  2018-02-14    False
  Name: open, dtype: bool
  
  # 过滤
  In [83]: data[data['open'].isin([23.53, 23.71])].head()
  Out[83]: 
               open   high  close    low
  2018-02-27  23.53  25.88  24.16  23.53
  2018-02-01  23.71  23.86  22.42  22.22
  2018-01-30  23.71  24.08  23.83  23.70
  2017-07-26  23.53  23.92  23.40  22.85
  2015-12-18  23.53  24.66  23.99  23.43
  ```

- 统计运算

  - 和numpy差不多

  ```python
  In [84]: data.head()
  Out[84]: 
               open   high  close    low
  2018-02-27  23.53  25.88  24.16  23.53
  2018-02-26  22.80  23.78  23.53  22.80
  2018-02-23  22.88  23.37  22.82  22.71
  2018-02-22  22.25  22.76  22.28  22.02
  2018-02-14  21.49  21.99  21.92  21.48
  
  # 综合描述
  In [85]: data.describe()
  Out[85]: 
               open        high       close         low
  count  643.000000  643.000000  643.000000  643.000000
  mean    21.272706   21.900513   21.336267   20.771835
  std      3.930973    4.077578    3.942806    3.791968
  min     12.250000   12.670000   12.360000   12.200000
  25%     19.000000   19.500000   19.045000   18.525000
  50%     21.440000   21.970000   21.450000   20.980000
  75%     23.400000   24.065000   23.415000   22.850000
  max     34.990000   36.350000   35.210000   34.010000
  
  # 单个函数
  In [86]: data.min()
  Out[86]: 
  open     12.25
  high     12.67
  close    12.36
  low      12.20
  dtype: float64
  
  In [87]: data.max()
  Out[87]: 
  open     34.99
  high     36.35
  close    35.21
  low      34.01
  dtype: float64
  ```

  - 累计统计函数

    - `cumsum() cumprod() cummin() cummax()`

    ```python
    # 排序
    In [88]: data = data.sort_index()
    
    In [89]: data.head(10)
    Out[89]: 
                 open   high  close    low
    2015-03-02  12.25  12.67  12.52  12.20
    2015-03-03  12.52  13.06  12.70  12.52
    2015-03-04  12.80  12.92  12.90  12.61
    2015-03-05  12.88  13.45  13.16  12.87
    2015-03-06  13.17  14.48  14.28  13.13
    2015-03-09  14.14  14.85  14.31  13.80
    2015-03-10  14.20  14.80  14.65  14.01
    2015-03-11  14.80  15.08  14.30  14.14
    2015-03-12  14.11  14.80  14.11  13.95
    2015-03-13  14.13  14.50  14.47  14.08
    
    # 累加
    In [90]: data['open'].cumsum().head(10)
    Out[90]: 
    2015-03-02     12.25
    2015-03-03     24.77
    2015-03-04     37.57
    2015-03-05     50.45
    2015-03-06     63.62
    2015-03-09     77.76
    2015-03-10     91.96
    2015-03-11    106.76
    2015-03-12    120.87
    2015-03-13    135.00
    Name: open, dtype: float64
    ```

  - 自定义运算：`apply(func, axis=0)`

    ```python
    In [92]: data.head()
    Out[92]: 
                 open  close
    2018-02-27  23.53  24.16
    2018-02-26  22.80  23.53
    2018-02-23  22.88  22.82
    2018-02-22  22.25  22.28
    2018-02-14  21.49  21.92
    
    # 求data每一列最大值和最小值的差值
    In [93]: data.apply(lambda col: col.max() -col.min(), axis=0)
    Out[93]: 
    open     22.74
    close    22.85
    dtype: float64
    ```

## （4）绘图

- DataFrame.plot()

  - kind可取值：line, bar, bar, hist, pie, scatter

  ```python
  In [97]: import matplotlib.pyplot as plt
  
  In [98]: data.plot(kind = 'line')
  Out[98]: <matplotlib.axes._subplots.AxesSubplot at 0x12c095d68>
  
  In [99]: plt.show()
  ```

# 3、高级处理

## （1）缺失值处理

- isnull判断是否有缺失数据
- fillna填充缺失数据
  - `fillna(value, inplace=True)` inplace为True会修改原数据
- dropna删除缺失数据
  - `dropna(axis='rows')`
- replace替换数据

```python
In [6]: data.head(10)  # 有缺失值
Out[6]: 
   Rank                    Title                       Genre  \
0     1  Guardians of the Galaxy     Action,Adventure,Sci-Fi   
1     2               Prometheus    Adventure,Mystery,Sci-Fi   
2     3                    Split             Horror,Thriller   
3     4                     Sing     Animation,Comedy,Family   
4     5            Suicide Squad    Action,Adventure,Fantasy   
5     6           The Great Wall    Action,Adventure,Fantasy   
6     7               La La Land          Comedy,Drama,Music   
7     8                 Mindhorn                      Comedy   
8     9       The Lost City of Z  Action,Adventure,Biography   
9    10               Passengers     Adventure,Drama,Romance   

                                         Description              Director  \
0  A group of intergalactic criminals are forced ...            James Gunn   
1  Following clues to the origin of mankind, a te...          Ridley Scott   
2  Three girls are kidnapped by a man with a diag...    M. Night Shyamalan   
3  In a city of humanoid animals, a hustling thea...  Christophe Lourdelet   
4  A secret government agency recruits some of th...            David Ayer   
5  European mercenaries searching for black powde...           Yimou Zhang   
6  A jazz pianist falls for an aspiring actress i...       Damien Chazelle   
7  A has-been actor best known for playing the ti...            Sean Foley   
8  A true-life drama, centering on British explor...            James Gray   
9  A spacecraft traveling to a distant colony pla...         Morten Tyldum   

                                              Actors  Year  Runtime (Minutes)  \
0  Chris Pratt, Vin Diesel, Bradley Cooper, Zoe S...  2014                121   
1  Noomi Rapace, Logan Marshall-Green, Michael Fa...  2012                124   
2  James McAvoy, Anya Taylor-Joy, Haley Lu Richar...  2016                117   
3  Matthew McConaughey,Reese Witherspoon, Seth Ma...  2016                108   
4  Will Smith, Jared Leto, Margot Robbie, Viola D...  2016                123   
5      Matt Damon, Tian Jing, Willem Dafoe, Andy Lau  2016                103   
6  Ryan Gosling, Emma Stone, Rosemarie DeWitt, J....  2016                128   
7  Essie Davis, Andrea Riseborough, Julian Barrat...  2016                 89   
8  Charlie Hunnam, Robert Pattinson, Sienna Mille...  2016                141   
9  Jennifer Lawrence, Chris Pratt, Michael Sheen,...  2016                116   

   Rating   Votes  Revenue (Millions)  Metascore  
0     8.1  757074              333.13       76.0  
1     7.0  485820              126.46       65.0  
2     7.3  157606              138.12       62.0  
3     7.2   60545              270.32       59.0  
4     6.2  393727              325.02       40.0  
5     6.1   56036               45.13       42.0  
6     8.3  258682              151.06       93.0  
7     6.4    2490                 NaN       71.0  
8     7.1    7188                8.01       78.0  
9     7.0  192177              100.01       41.0  

# 判断是否为缺失值NaN
In [9]: pd.isnull(data).head()
Out[9]: 
    Rank  Title  Genre  Description  Director  Actors   Year  \
0  False  False  False        False     False   False  False   
1  False  False  False        False     False   False  False   
2  False  False  False        False     False   False  False   
3  False  False  False        False     False   False  False   
4  False  False  False        False     False   False  False   

   Runtime (Minutes)  Rating  Votes  Revenue (Millions)  Metascore  
0              False   False  False               False      False  
1              False   False  False               False      False  
2              False   False  False               False      False  
3              False   False  False               False      False  
4              False   False  False               False      False  

# 判断是否不为缺失值NaN
In [10]: pd.notnull(data).head()
Out[10]: 
   Rank  Title  Genre  Description  Director  Actors  Year  Runtime (Minutes)  \
0  True   True   True         True      True    True  True               True   
1  True   True   True         True      True    True  True               True   
2  True   True   True         True      True    True  True               True   
3  True   True   True         True      True    True  True               True   
4  True   True   True         True      True    True  True               True   

   Rating  Votes  Revenue (Millions)  Metascore  
0    True   True                True       True  
1    True   True                True       True  
2    True   True                True       True  
3    True   True                True       True  
4    True   True                True       True  

# 判断一列数据是否有缺失值
In [11]: np.all(pd.notnull(data))
Out[11]: 
Rank                   True
Title                  True
Genre                  True
Description            True
Director               True
Actors                 True
Year                   True
Runtime (Minutes)      True
Rating                 True
Votes                  True
Revenue (Millions)    False
Metascore             False
dtype: bool
    
# 使用平均值填充缺失值
In [16]: for col in data.columns:
    ...:     if np.all(pd.notnull(data[col])) == False:
    ...:         print(col + '列有缺失值')
    ...:         data[col].fillna(data[col].mean(), inplace=True)
    ...: 
Revenue (Millions)列有缺失值
Metascore列有缺失值
```

- 对于缺失值不是NaN的，先替换为NaN（`DadaFrame.replace(to_replace='?', value=np.nan)`）

## （2）数据离散化

-   离散化就是在连续属性的值域上，将值域划分为若干个区间，用不同的符号代表一个区间的值

  ```python
  >> time
  0         829
  1         829
  2         829
  3         829
  4         829
           ... 
  99994    1111
  99995    1111
  99996    1111
  99997    1111
  99998    1111
  Name: time_stamp, Length: 99999, dtype: int64
              
  >> time_qcut = pd.qcut(time, 3, labels=['small', 'middle', 'big'])  # 分成2组，分别标记
  >> time_qcut
  0        middle
  1        middle
  2        middle
  3        middle
  4        middle
            ...  
  99994       big
  99995       big
  99996       big
  99997       big
  99998       big
  Name: time_stamp, Length: 99999, dtype: category
  Categories (3, object): ['small' < 'middle' < 'big']
      
  >> time_qcut.value_counts()  # 统计每组个数
  middle    34341
  small     33618
  big       32040
  Name: time_stamp, dtype: int64
          
  >> time_cut = pd.cut(time, [828, 1000, 1111])  # 自定义区间
  >> time_cut
  time = user_log['time_stamp']...
  0         (828, 1000]
  1         (828, 1000]
  2         (828, 1000]
  3         (828, 1000]
  4         (828, 1000]
               ...     
  99994    (1000, 1111]
  99995    (1000, 1111]
  99996    (1000, 1111]
  99997    (1000, 1111]
  99998    (1000, 1111]
  Name: time_stamp, Length: 99999, dtype: category
  Categories (2, interval[int64]): [(828, 1000] < (1000, 1111]]
                                                   
  >> pd.get_dummies(time_cut, prefix='分组名为：')  # 获取one-hot编码矩阵
  	分组名为：_(828, 1000]	分组名为：_(1000, 1111]
  0	1	0
  1	1	0
  2	1	0
  3	1	0
  4	1	0
  ...	...	...
  99994	0	1
  99995	0	1
  99996	0	1
  99997	0	1
  99998	0	1
  99999 rows × 2 column
  ```

## （3）合并

- 合并指的是将多张不同内容的表合并在一起

  ```python
  # 数据见前一节
  >> pd.concat([time_cut, time_one_hot], axis=1)  # axis=1表示按照行索引合并
  	time_stamp	分组名为：_(828, 1000]	分组名为：_(1000, 1111]
  0	(828, 1000]	1	0
  1	(828, 1000]	1	0
  2	(828, 1000]	1	0
  3	(828, 1000]	1	0
  4	(828, 1000]	1	0
  ...	...	...	...
  99994	(1000, 1111]	0	1
  99995	(1000, 1111]	0	1
  99996	(1000, 1111]	0	1
  99997	(1000, 1111]	0	1
  99998	(1000, 1111]	0	1
  99999 rows × 3 columns
  ```

- pd.merge(left, right, how='rigth'|'left', on=[key])，类似mysql数据库表的连接

  ```python
  >> left
  	A	key
  0	A0	k0
  1	A1	k0
  2	A2	k1
  3	A3	k1
  >> right
  	B	key
  0	B0	k1
  1	B1	k1
  2	B2	k2
  3	B3	k2
  >> pd.merge(left, right, on=['key'])
  	A	key	B
  0	A2	k1	B0
  1	A2	k1	B1
  2	A3	k1	B0
  3	A3	k1	B1
  >> pd.merge(left, right, how='left', on=['key'])
  	A	key	B
  0	A0	k0	NaN
  1	A1	k0	NaN
  2	A2	k1	B0
  3	A2	k1	B1
  4	A3	k1	B0
  5	A3	k1	B1
  >> pd.merge(left, right, how='right', on=['key'])
  	A	key	B
  0	A2	k1	B0
  1	A3	k1	B0
  2	A2	k1	B1
  3	A3	k1	B1
  4	NaN	k2	B2
  5	NaN	k2	B3
  >> pd.merge(left, right, how='outer', on=['key'])
  	A	key	B
  0	A0	k0	NaN
  1	A1	k0	NaN
  2	A2	k1	B0
  3	A2	k1	B1
  4	A3	k1	B0
  5	A3	k1	B1
  6	NaN	k2	B2
  7	NaN	k2	B3
  >> pd.merge(left, right, how='inner', on=['key'])
  	A	key	B
  0	A2	k1	B0
  1	A2	k1	B1
  2	A3	k1	B0
  3	A3	k1	B1
  ```

## （4）交叉表与透视表

```python
>> data  # 交叉表数据
	good	bad
0	0.2	0.8
1	0.7	0.3
2	1.0	0.0
3	0.0	1.0
4	0.9	0.1
```

- 使用`data_pd.pivot_table()`实现透视表

## （5）分组和聚合

- 分组API

  ```
  >> data3
  	color	price
  0	white	10
  1	black	15
  2	white	10
  3	white	10
  4	black	15
  >> data3.groupby(['color']).mean()
  		price
  color	
  black	15
  white	10
  >> data3['price'].groupby(data3['color']).mean()
  color
  black    15
  white    10
  Name: price, dtype: int64
  ```


# 4、小技巧

## （1）深拷贝与更改具体数据

```python
new_data = data.copy(deep=True)
new_data.loc[i, "praise_number"] = 100
```

- 先行后列

```python
In [12]: result
Out[12]: 
  book_id praise_number
0     100            12

In [13]: result['praise_number'].loc[result['book_id'] == 100] = 10

In [14]: result
Out[14]: 
  book_id  praise_number
0     100             10
```

