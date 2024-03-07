[TOC]

# 1、numpy和pandas常用代码

```python
import numpy as np
import pandas as pd
```

## （1）创建数据

### 创建指定大小的，全为0的一维/多维数据

```python
>> np.zeros((5))  # 1行5列
array([0., 0., 0., 0., 0.])

>> np.zeros((5, 5))  # 5行5列
array([[0., 0., 0., 0., 0.],
       [0., 0., 0., 0., 0.],
       [0., 0., 0., 0., 0.],
       [0., 0., 0., 0., 0.],
       [0., 0., 0., 0., 0.]])
```

### 创建一维数组

- `np.linspace(start, stop, num, endpoint)`
  - 创建等差数组：num为生成元素的数量，默认为50，endpoint为序列中是否包含stop，默认为true
- `np.arange(start, stop, step, dtype)`
- `np.logspace(start, stop, num)`
  - 创建等比数组：第一个是10的start次方，最后一个是10的stop次方，总共num个

```python
>> np.linspace(10, 20, 5, False)
array([10., 12., 14., 16., 18.])
>> np.arange(10, 20, 2, np.int8)
array([10, 12, 14, 16, 18], dtype=int8)
>> np.logspace(1, 2, 4)
array([ 10.        ,  21.5443469 ,  46.41588834, 100.        ])
```

### 创建正态/均匀分布的数据

```python
>> np.random.normal(0, 1, 10)  # 从均值为0，方差为1的正态分布中采样10个数据
array([ 1.15370444,  2.97871395, -0.57874393,  1.43843364, -1.73328534,
       -1.00400726, -1.03894349,  1.13981494,  0.15755228, -2.35291102])

>> np.random.uniform(0, 5, 10)  # 从0～5的均匀分布中采样10个数据
array([0.13329396, 1.565597  , 2.84536795, 3.73518421, 3.08613517,
       4.27400976, 0.41213595, 3.88200423, 1.27818383, 4.92181118])
```

### 根据列表创建`np.ndarray`数据

```python
>> np.array([i for i in range(10)])
array([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
```

### 根据`np.ndarray`创建`pd`数据（`Series`是一维，`DataFrame`是二维）

```python
>> data_np = np.array([i for i in range(5)])
# columns指定列索引，index指定行索引
>> pd.DataFrame(data_np, columns=['数据'], index=[i*2 for i in range(5)])  
	数据
0	0
2	1
4	2
6	3
8	4
```

### 自由创建`DataFrame`数据

```python
>> pd.DataFrame({
..   'A': [random.randint(1, 10) for i in range(5)],
..   'B': [random.randint(1, 10) for i in range(5)]
.. })
	A	B
0	3	10
1	3	2
2	7	1
3	4	1
4	10	1
```

## （2）pandas读取/保存数据

### 读取数据：`pd.read_csv(path_or_buf, seq=',', header=’infer’, usecols=None, index_col=None, nrows=None)`

- 读取csv文件

- `path_or_buf`：读取的文件，可以为路径字符串，也可以是url字符串

- `seq`：csv文件的分隔符，默认为`,`

- `header`：指定第几行为列名，默认为0（即第0行为列名），如果数据集本身没有列名，应该指定`header=None`

- `usecols`：准备读取的列，默认为`None`，可以传一个列表，列表元素为要读取的列的名字

- `index_col`：列索引的选项，默认为`None`，一般有三种情况

  - `index_col=None`：默认情况，该情况下，会添加一列到最前面，该列从0开始，作为每一行的索引

  - `index_col=0`：该情况下，不会添加列

  - `index_col=False`：该情况下，和`index_col=None`类似，只是会忽略每一行行尾的分隔符，用于读取格式错误的文件，如

    ```
    index,a,b
    0,10,100,
    1,12,120,
    ```

    - 该csv文件格式有误，如果使用`index_csv=None`读取，则会多出一列`NaN`

- `nrows` 指定读取的数据行数

### 保存数据：`DataFrame.to_csv(path_or_buf, seq=',', columns=None, header=True, index=True, mode='w', encoding=None)`

- columns：列索引
- header：是否写进索引值，为布尔值或者字符串列表
- index：是否写进索引
- mode：w是重写，a是追加

## （3）numpy的ndarray数据的增删改查

### 索引规则：`data[start:stop:step]`

```python
>> data = np.array([i for i in range(10)])
>> data
array([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])

>> data[0]  # 取索引0
0

>> data[0:5]  # 从索引0开始，取到索引4
array([0, 1, 2, 3, 4])

>> data[0:5:2]  # 从索引0开始，到索引5，间隔为2
array([0, 2, 4])

>> data[5:0:-1]  # 逆序
array([5, 4, 3, 2, 1])

>> data[4::]  # 从索引4开始，一直到结束
array([4, 5, 6, 7, 8, 9])

>> data[::2]  # 从索引0到结束，间隔为2
array([0, 2, 4, 6, 8])
```

### 根据条件查询（`> >= < <= != == in notin`）

```python
>> data = np.array([i for i in range(10)])
>> data
array([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])

>> data > 3  # 获得的是一个长度一样的布尔值ndarray
array([False, False, False, False,  True,  True,  True,  True,  True, True])

>> data[data > 3]  # 筛选出大于3的
array([4, 5, 6, 7, 8, 9])

>> data[(data > 3) & (data < 7)]  # 筛选出大于3小于7的
array([4, 5, 6])

>> data[(data < 3) | (data > 7)]  # 筛选出小于3或大于7的
array([0, 1, 2, 8, 9])
```

### 根据条件修改

```python
>> data = np.array([i for i in range(10)])
>> data
array([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])

>> np.where(data > 5, 1, 0)  # 修改大于5的为1，其余为0
array([0, 0, 0, 0, 0, 0, 1, 1, 1, 1])
```

## （4）pandas的DataFrame数据的增删改查

### 查看相关信息

```python
>> data = pd.DataFrame({
..   'A': [i*1 for i in range(10)],
..   'B': [i*2 for i in range(10)],
..   'C': [i*3 for i in range(10)]
.. })
>> data
	A	B	C
0	0	0	0
1	1	2	3
2	2	4	6
3	3	6	9
4	4	8	12
5	5	10	15
6	6	12	18
7	7	14	21
8	8	16	24
9	9	18	27

>> data.shape  # 查看数据形状，(10,3)表示10行3列
(10, 3)

>> data.head(3)  # 查看前三行，默认前五行
	A	B	C
0	0	0	0
1	1	2	3
2	2	4	6

>> data.tail(3)  # 查看后三行，默认后五行
	A	B	C
7	7	14	21
8	8	16	24
9	9	18	27

>> data.info()  # 打印相关信息
<class 'pandas.core.frame.DataFrame'>
RangeIndex: 10 entries, 0 to 9
Data columns (total 3 columns):
 #   Column  Non-Null Count  Dtype
---  ------  --------------  -----
 0   A       10 non-null     int64
 1   B       10 non-null     int64
 2   C       10 non-null     int64
dtypes: int64(3)
memory usage: 368.0 bytes

>> list(data.columns)  # 获取列名
['A', 'B', 'C']

>> str(data['A'].dtype)  # 查看数据类型
'int64'

>> data.describe()  # 查看数据的统计信息
			A			B			C
count	10.00000	10.000000	10.000000
mean	4.50000		9.000000	13.500000
std		3.02765		6.055301	9.082951
min		0.00000		0.000000	0.000000
25%		2.25000		4.500000	6.750000
50%		4.50000		9.000000	13.500000
75%		6.75000		13.500000	20.250000
max		9.00000		18.000000	27.000000
```

### 索引规则：先列后行

```python
>> data = pd.DataFrame({
..   'A': [i*1 for i in range(10)],
..   'B': [i*2 for i in range(10)],
..   'C': [i*3 for i in range(10)]
.. })
>> data
	A	B	C
0	0	0	0
1	1	2	3
2	2	4	6
3	3	6	9
4	4	8	12
5	5	10	15
6	6	12	18
7	7	14	21
8	8	16	24
9	9	18	27

>> data['A']  # 只取一列，得到的就是Series类型数据，类似于np.ndarray
0    0
1    1
2    2
3    3
4    4
5    5
6    6
7    7
8    8
9    9
Name: A, dtype: int64

>> data['A'][0:6:2]  # 取A列的从索引0开始到索引6，间隔为2
0    0
2    2
4    4
Name: A, dtype: int64

>> data[['A', 'B']]  # 取多列
	A	B
0	0	0
1	1	2
2	2	4
3	3	6
4	4	8
5	5	10
6	6	12
7	7	14
8	8	16
9	9	18

>> data[['A', 'B']][0:3]
	A	B
0	0	0
1	1	2
2	2	4
```

### 索引函数：`loc() iloc`

```python
>> data = pd.DataFrame({
..   'A': [i*1 for i in range(10)],
..   'B': [i*2 for i in range(10)],
..   'C': [i*3 for i in range(10)]
.. })
>> data
	A	B	C
0	0	0	0
1	1	2	3
2	2	4	6
3	3	6	9
4	4	8	12
5	5	10	15
6	6	12	18
7	7	14	21
8	8	16	24
9	9	18	27

>> data.loc[0:4, 'A':'C']  # 行索引从0开始，到4结束，列索引从'A'开始，到'C'结束
	A	B	C
0	0	0	0
1	1	2	3
2	2	4	6
3	3	6	9
4	4	8	12

>> data.iloc[0:4, 0::]  # 行索引从0开始，到4结束，列索引从第0个开始，到最后一个结束
	A	B	C
0	0	0	0
1	1	2	3
2	2	4	6
3	3	6	9
```

### 根据条件筛选数据，类似numpy

```python
>> data = pd.DataFrame({
..   'A': [i*1 for i in range(10)],
..   'B': [i*2 for i in range(10)],
..   'C': [i*3 for i in range(10)]
.. })
>> data
	A	B	C
0	0	0	0
1	1	2	3
2	2	4	6
3	3	6	9
4	4	8	12
5	5	10	15
6	6	12	18
7	7	14	21
8	8	16	24
9	9	18	27

>> data>8
	A		B		C
0	False	False	False
1	False	False	False
2	False	False	False
3	False	False	True
4	False	False	True
5	False	True	True
6	False	True	True
7	False	True	True
8	False	True	True
9	True	True	True

>> data['A'] > 5
0    False
1    False
2    False
3    False
4    False
5    False
6     True
7     True
8     True
9     True
Name: A, dtype: bool

>> data[data['A'] > 5]  # 筛选出A列大于5的数据
	A	B	C
6	6	12	18
7	7	14	21
8	8	16	24
9	9	18	27

>> data[['A', 'B']][data['A'] > 5]  # 筛选出A列大于5的数据，只需要A列和B列
	A	B
6	6	12
7	7	14
8	8	16
9	9	18

>> data[(data['A'] > 3) & (data['B'] < 10)]  # 筛选出A列大于3的，且B列小于10的
	A	B	C
4	4	8	12

>> data[data['A'].isin([1,3,5])]  # 筛选出A列为1，3，5的数据
	A	B	C
1	1	2	3
3	3	6	9
5	5	10	15
```

### 删除行/列

```python
>> data = pd.DataFrame({
  'A': [i*1 for i in range(5)],
  'B': [i*2 for i in range(5)],
  'C': [i*3 for i in range(5)]
})
>> data
	A	B	C
0	0	0	0
1	1	2	3
2	2	4	6
3	3	6	9
4	4	8	12

>> data.drop(columns=['A'])  # 删除A列（不改变原数据）
	B	C
0	0	0
1	2	3
2	4	6
3	6	9
4	8	12

>> data.drop(labels=list(range(2)))  # 等同于data.drop(labels=[0,1]) ，删除第0、1行（不改变原数据）
	A	B	C
2	2	4	6
3	3	6	9
4	4	8	12
```

### 增加行/列

```python
>> data = pd.DataFrame({
..  'A': [1,2,3]
..})
>> data
	A
0	1
1	2
2	3

>> data['B'] = [i**2 for i in range(1,4)]  # 增加一列
>> data
	A	B
0	1	1
1	2	4
2	3	9

>> data.loc[3] = [11, 12]  # 增加一行
>> data
	A	B
0	1	1
1	2	4
2	3	9
3	11	12
```

## （5）numpy的统计分析函数

### 可用的统计分析函数

- `np.min(array, axis)` 最小值，axis为0（行）或1（列）
- `np.max(array, axis)` 最大值
- `np.median(array, axis)` 中位数
- `np.mean(array, axis, dtype)` 平均值
- `np.std(array, axis, dtype)` 标准差
- `np.var(array, axis, dtype)` 方差
- `np.argmax(array, axis)` 获取最大值的索引
- `np.argmin(array, axis)` 获取最小值的索引
- `np.unique(array, axis)` 获取去重后的数据
- `np.sum(array, axis)` 求和

```python
>> data = np.array([[random.randint(1, 5) for i in range(10)], [random.randint(1, 5) for i in range(10)]])
>> data
array([[2, 3, 4, 4, 2, 3, 3, 3, 2, 3],
       [5, 2, 5, 3, 3, 3, 2, 1, 4, 2]])
  
>> np.argmin(data)  # 不指定axis表示先把数组拉平成一维，17这里表示行索引为1(=17%10)，列索引为7(=17-1*10)
17

>> np.argmin(data, axis=0)  # 列
array([0, 1, 0, 1, 0, 0, 1, 1, 0, 1])

>> np.argmin(data, axis=1)  # 行
array([0, 7])

>> data.argmin()  # 可以直接在ndarray对象上调用这个方法，用法一样
17
```

# 2、查看（非）缺失值 `isna` `notna`

- `DataFrame.isna() Series.isna()`

  - 获取数据中缺失值情况

  - `np.NaN`和`pd.NaT`会视为缺失值，但是空字符不会被视为缺失值，此外`np.inf`也不会被视为缺失值，除非设置语句`pandas.options.mode.use_inf_as_na = True`

    ```python
    >> data = pd.DataFrame()
    >> data['name'] = ['abc', 'cde', 'ace']
    >> data['age'] = [20, np.NaN, 21]
    >> data['hobby'] = ['', pd.NaT, 'study']
    >> data
    	name	age		hobby
    0	abc		20.0	
    1	cde		NaN		NaT
    2	ace		21.0	study
    >> data.isna()
    	name	age		hobby
    0	False	False	False
    1	False	True	True
    2	False	False	False
    ```

- 相关api

  - `isnull()`和`isna()`效果一样
  - `notna()`和`isna()`效果相反
  - `dropna()`是删除有缺失值的那一行数据

  ```python
  >> data
  	name	age		hobby
  0	abc		20.0	
  1	cde		NaN		NaT
  2	ace		21.0	study
  >> data.isnull()
  	name	age		hobby
  0	False	False	False
  1	False	True	True
  2	False	False	False
  >> data.notna()
  	name	age		hobby
  0	True	True	True
  1	True	False	False
  2	True	True	True
  >> data.dropna()
  	name	age		hobby
  0	abc		20.0	
  2	ace		21.0	study
  ```

# 3、求和 `sum`

- `DataFrame.sum(axis=0) Series.sum(axis=0)`

  - 计算总和，计算时默认会忽略缺失值

  - `axis`：指定行还是列，默认为0，表示指定列计算

    ```python
    >> data = pd.DataFrame()
    >> data['A'] = [1, 2, 3]
    >> data['B'] = [4, 5, 6]
    >> data['C'] = [7, 8, np.NaN]
    >> data
    	A	B	C
    0	1	4	7.0
    1	2	5	8.0
    2	3	6	NaN
    >> data.sum()  # 默认计算一列
    A     6.0
    B    15.0
    C    15.0
    dtype: float64
    >> data.sum(axis=1)  # 指定计算一行
    0    12.0
    1    15.0
    2     9.0
    dtype: float64
    >> data['A'].sum()
    6
    ```

  - 相关api

    - `pd.DataFrame.min() pd.Series.min()`
    - `pd.DataFrame.max() pd.Series.max()`
    - `pd.DataFrame.idxmin() pd.Series.idxmin()`返回每一列/行最小值对应的索引
    - `pd.DataFrame.idxmax() pd.Series.idxmax()`

    ```python
    >> data
    	A	B	C
    0	1	4	7.0
    1	2	5	8.0
    2	3	6	NaN
    >> data.min()  # 都可以指定axis
    A    1.0
    B    4.0
    C    7.0
    dtype: float64
    >> data.max()
    A    3.0
    B    6.0
    C    8.0
    dtype: float64
    >> data.idxmin()
    A    0
    B    0
    C    0
    dtype: int64
    >> data.idxmax()
    A    2
    B    2
    C    1
    dtype: int64
    >> data.idxmax(axis=1)
    0    C
    1    C
    2    B
    dtype: object
    ```

# 4、分组聚合 `groupby`，numpy中的统计函数和`agg`以及查看某列各种值个数 `value_counts`

- `DataFrame.groupby(key)`

  - 分组函数

  - `key`：将数据按照指定的`key`进行分组，`key`为数组，数组中应放分组的索引

    ```python
    >> data
    	color	price1	price2
    0	white	10		100
    1	black	15		150
    2	white	10		100
    3	white	10		100
    4	black	15		150
    >> data.groupby(['color']).mean()  # 分组再聚合，先按照color分组，再计算每种color下其他列的平均值
    		price1	price2
    color		
    black	15		150
    white	10		100
    >> data['price1'].groupby(data['color']).mean()  # 只计算每种color下price1的平均值
    color
    black    15
    white    10
    Name: price, dtype: int64
    ```

  - 常见聚合函数：`mean sum min max std（计算标准差） count（计数） nunique（去重后元素个数） ...`
  
- `DataFrame.agg(func)`

  - 对分组后的数据进行聚合

  - `func`：聚合函数，可为`str`或者`dict`

    ```python
    >> data
    	sex	smoker	age	weight
    0	F	Y		21	120
    1	F	N		30	100
    2	M	Y		17	132
    3	F	Y		37	140
    4	M	N		40	94
    5	M	Y		18	89
    6	F	Y		26	123
    >> data.groupby(['sex', 'smoker'])['age'].agg('mean')  # 按照sex和smoker分组，可分为4组，对age列使用聚合求平均
    sex  smoker
    F    N         30.0
         Y         28.0
    M    N         40.0
         Y         17.5
    Name: age, dtype: float64
    >> data.groupby(['sex', 'smoker']).agg('mean')  # 对多列聚合
    			age		weight
    sex	smoker		
    F	N		30.0	100.000000
    	Y		28.0	127.666667
    M	N		40.0	94.000000
    	Y		17.5	110.500000
    >> data.groupby(['sex', 'smoker'])['age'].agg(['min', 'max'])  # 对一列使用多个聚合
    			min	max
    sex	smoker		
    F	N		30	30
    	Y		21	37
    M	N		40	40
    	Y		17	18
    >> data.groupby(['sex', 'smoker'])['age'].agg([('min_age', 'min'), ('max_age','max')])  # 聚合并重命名索引
    			min_age	max_age
    sex	smoker		
    F	N		30		30
    	Y		21		37
    M	N		40		40
    	Y		17		18
    # 设置自定义的聚合函数，如age设为平均值*2，weight设为最大值减去最小值
    >> agg_dict = {
         'age': lambda group: 2 * group.mean(),
         'weight': lambda group: group.max() - group.min()
       }
    >> data.groupby(['sex', 'smoker']).agg(agg_dict)
    			age	weight
    sex	smoker		
    F	N		60	0
    	Y		56	20
    M	N		80	0
    	Y		35	43
    ```

- 补充：查看某列数据各种值的个数

  ```python
  >> data = pd.DataFrame({
  ..  'A': [random.randint(0,1) for i in range(10)],
  ..  'B': ['种类'+str(random.randint(0,1)) for i in range(10)]
  .. })
  >> data
  	A	B
  0	0	种类1
  1	1	种类1
  2	0	种类1
  3	1	种类0
  4	1	种类0
  5	1	种类0
  6	0	种类1
  7	0	种类1
  8	1	种类1
  9	1	种类1
  
  >> data['A'].value_counts()  # 1有6个，0有4个
  1    6
  0    4
  
  >> data.value_counts()
  	A 	   B  
  0  种类1    4
  1  种类1    3
     种类0    3
  ```

  

# 5、填充缺失值 `fillna`

- `DataFrame.fillna(value, inplace=True)`

  - 填充缺失值为指定的值

  - `value`：代替缺失值的值

  - `inplace`：inplace为True会修改原数据

  - 使用技巧：在进行填充前，先把非`np.NaN`和`pd.NaT`的缺失值转换为NaN（使用`DadaFrame.replace(to_replace='?', value=np.NaN)`将数据中的`?`转换为`np.NaN`）

    ```python
    >> data
    	A	B
    0	1.0	1
    1	2.0	NaT
    2	NaN	2
    >> data.fillna(0, inplace=True)
    >> data
    	A	B
    0	1.0	1
    1	2.0	0
    2	0.0	2
    ```

# 6、改变数据类型 `astype`

- `DataFrame.astype(dtype) Series.astype(dtype)`

  - 改变数据类型

  - `dtype`：期望的数据类型，常见可选的值有`int8 int16 int32 int64 uint8 uint16 uint32 uint64 float16 float32 float64`

    ```python
    >> np.iinfo(np.int8)
    iinfo(min=-128, max=127, dtype=int8)
    
    >> np.iinfo(np.uint8)
    iinfo(min=0, max=255, dtype=uint8)
    
    >> np.finfo(np.float16)
    finfo(resolution=0.001, min=-6.55040e+04, max=6.55040e+04, dtype=float16)
    ```

# 7、添加行和合并 `append` `concat`

- `DataFrame.append(other, ignore_index=False, verify_integrity=False)`

  - 向dataframe对象中添加新的行，如果添加的列名不在dataframe对象中，将会被当作新的列进行添加

  - `other`：可添加到数据类型为`DataFrame Series dict list`

  - `ignore_index`：默认值为`False`，如果为`True`，则不使用`index`

  - `verify_integrity`：默认值为`False`，如果为`True`，当创建相同的`index`时，会抛出`ValueError`的异常

    ```python
    >> data = pd.DataFrame()
    >> data.append([1,2,3])  # 添加一维list
    	0
    0	1
    1	2
    2	3
    >> data.append([[1,2,3], [4,5,6]])  # 添加二维list
    	0	1	2
    0	1	2	3
    1	4	5	6
    >> data.append([[1,2,3], [4,5,6]]).append([[1,2,3], [4,5,6]])  # 连续添加时，会创建相同（行）索引
    	0	1	2
    0	1	2	3
    1	4	5	6
    0	1	2	3
    1	4	5	6
    >> data.append([[1,2,3], [4,5,6]]).append([[1,2,3], [4,5,6]], ignore_index=True)  # 忽略索引
    	0	1	2
    0	1	2	3
    1	4	5	6
    2	1	2	3
    3	4	5	6
    >> data = pd.DataFrame({
         'A': [1,2,3],
         'B': [4,5,6]
       })
    >> data.append(data)
    	A	B
    0	1	4
    1	2	5
    2	3	6
    ```

- `pd.concat(objs, axis=0, join='outer', ignore_index=False, keys=None)`

  - 合并两个数据
  - `objs` 要合并的数据对象，为数组
  - `axis` 指明连接的轴向，默认为0
  - `join` 指明其他轴向上是按交集（`inner`）还是并集（`outer`）合并，默认为`outer`
  - `ignore_index` 是否忽略原索引并建立新索引
  - `keys` 建立层次化索引

  ```python
  >> data1
  	A	B
  0	1	4
  1	2	5
  2	3	6
  >> data2
  	A	B
  0	11	41
  1	21	51
  2	31	61
  >> pd.concat([data1, data2])
  	A	B
  0	1	4
  1	2	5
  2	3	6
  0	11	41
  1	21	51
  2	31	61
  >> pd.concat([data1, data2], ignore_index=True)
  	A	B
  0	1	4
  1	2	5
  2	3	6
  3	11	41
  4	21	51
  5	31	61
  >> pd.concat([data1, data2], axis=1)
  A	B	A	B
  0	1	4	11	41
  1	2	5	21	51
  2	3	6	31	61
  >> pd.concat([data1, data2], keys=['first', 'second'])
  			A	B
  first	0	1	4
          1	2	5
          2	3	6
  second	0	11	41
          1	21	51
          2	31	61
  ```

# 8、排序 `sort_values`

- `DataFrame.sort_values(by, ascending=True,  kind='quicksort', na_position='last', ignore_index=False)`

  - 排序函数，根据给定的关键字排序

  - `by`：排序的关键字，为数组，数组内容是索引的值，将按照这些索引进行排序

  - `ascending`：是否为升序排序

  - `kind`：选择排序方法，可选的有`quicksort, mergesort, heapsort`，其中`quicksort`是稳定的

  - `na_position`：若有缺失值`NaN`，选择放到前面还是后面

  - `ignore_index`：是否忽略原索引，如果是，则会添加新的行标签（从0开始，到n-1）

    ```python
    >>> df
    	col1  col2  col3 col4
    0    A     2     0    a
    1    A     1     1    B
    2    B     9     9    c
    3  NaN     8     4    D
    4    D     7     2    e
    5    C     4     3    F
    >>> df.sort_values(by=['col1'])
    	col1  col2  col3 col4
    0    A     2     0    a
    1    A     1     1    B
    2    B     9     9    c
    5    C     4     3    F
    4    D     7     2    e
    3  NaN     8     4    D
    >>> df.sort_values(by=['col1', 'col2'])
    	col1  col2  col3 col4
    1    A     1     1    B
    0    A     2     0    a
    2    B     9     9    c
    5    C     4     3    F
    4    D     7     2    e
    3  NaN     8     4    D
    ```

# 9、连接两张表 `merge`

- `DataFrame.merge(left, right, how='rigth'|'left', on=[key])`

  - 连接两张表，分为左连接和右连接

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
    ```

# 10、重设索引和重设列名 `reset_index` `rename`

- `DataFrame.reset_index(drop=True)`

  - 重设索引，一般用于数据清洗后，原来的索引被打乱时重新设置索引

  - `drop`：是否保留原来的索引

    ```python
    >> data8
    	A	B
    0	1	11
    1	2	22
    2	3	33
    3	4	44
    4	5	55
    >> data8.drop(labels=[1,3])  # 删除第1、3行
    	A	B
    0	1	11
    2	3	33
    4	5	55
    >> data8.drop(labels=[1,3]).reset_index()
    	index	A	B
    0	0	1	11
    1	2	3	33
    2	4	5	55
    >> data8.drop(labels=[1,3]).reset_index(drop=True)  # 不保留原来的index
    	A	B
    0	1	11
    1	3	33
    2	5	55
    ```

- `pd.DataFrame.rename()`

  - 重设列名

    ```python
    >> data9
    	a	b	c
    0	1	4	7
    1	2	5	8
    2	3	6	9
    >> data9.rename(columns={'a': 'A'})
    	A	b	c
    0	1	4	7
    1	2	5	8
    2	3	6	9
    >> data9.rename(columns={'a': 'A', 'b': 'B'})
    	A	B	c
    0	1	4	7
    1	2	5	8
    2	3	6	9
    ```

# 11、抽样函数 `sample`

- `pd.DataFrame.sample(n=None, frac=None, replace=False, random_state=None, axis=None)`

  - 抽样函数
  - `n` 要抽取的样本数量（即n行/列数据）
  - `frac` 要抽取的数据比例，如0.8即抽取80%的数据
  - `replace` 是否有放回抽取
  - `random_state` 抽取的数据是否可重复，为`None`不重复，为1可重复
  - `axis` 抽取行数据还是列数据，为0抽取行数据，为1抽取列数据

# 12、数据类型转换 `to_datetime` `as_type`

- `pd.to_datetime()`

  - 将给定的数据按照一定格式转换为日期格式

  ```python
  # 转换时间格式
  >> pd.to_datetime('2021/6/19 12:00:00', format='%Y/%m/%d %H:%M:%S')
  Timestamp('2021-06-19 12:00:00')
  
  >> pd.to_datetime('2021.6.19 12:00:00', format='%Y.%m.%d')
  Timestamp('2021-06-19 12:00:00')
  
  # 不指定具体时间，默认为0:0:0
  >> pd.to_datetime('2021.6.19', format='%Y.%m.%d')
  Timestamp('2021-06-19 00:00:00')
  
  # 把时间戳转换为日期
  >> pd.to_datetime(1624077527796, unit='ms')
  Timestamp('2021-06-19 04:38:47.796000')
  
  >> pd.to_datetime(1624077527, unit='s')
  Timestamp('2021-06-19 04:38:47')
  
  # 根据标准时间戳获得北京时间（东8区）
  >> pd.to_datetime(1624077527796 + 8*60*60*1000, unit='ms')
  Timestamp('2021-06-19 12:38:47.796000')
  ```

- `DataFrame.astype()`

  ```python
  >> data = pd.DataFrame({
  ..   'A': [1,2,3],
  ..   'B': [4,5,6]
  .. })
  >> data.info()
  <class 'pandas.core.frame.DataFrame'>
  RangeIndex: 3 entries, 0 to 2
  Data columns (total 2 columns):
   #   Column  Non-Null Count  Dtype
  ---  ------  --------------  -----
   0   A       3 non-null      int64
   1   B       3 non-null      int64
  dtypes: int64(2)
  memory usage: 176.0 bytes
  
  >> data.astype('int32').info()
  <class 'pandas.core.frame.DataFrame'>
  RangeIndex: 3 entries, 0 to 2
  Data columns (total 2 columns):
   #   Column  Non-Null Count  Dtype
  ---  ------  --------------  -----
   0   A       3 non-null      int32
   1   B       3 non-null      int32
  dtypes: int32(2)
  memory usage: 152.0 bytes
  
  >> data.astype({'A': 'float32', 'B': 'float64'}).info()
  <class 'pandas.core.frame.DataFrame'>
  RangeIndex: 3 entries, 0 to 2
  Data columns (total 2 columns):
   #   Column  Non-Null Count  Dtype  
  ---  ------  --------------  -----  
   0   A       3 non-null      float32
   1   B       3 non-null      float64
  dtypes: float32(1), float64(1)
  memory usage: 164.0 bytes
  ```

# 13、one-hot编码 `get_dummies`

- `pd.get_dummies(data, prefix=None, prefix_sep='_'`

  - 将数据中指定的列的值使用one-hot编码
  - `data` 要转换的数据
  - `prefix` 转换后列名的前缀
  - `prefix_sep` 转换后列名的分隔符

  ```python
  >> data = pd.DataFrame({'color': ['r', 'r', 'g', 'g', 'b'], 'depth': ['h', 'h', 'l', 'l', 'h']})
  
  >> data
    color depth
  0     r     h
  1     r     h
  2     g     l
  3     g     l
  4     b     h
  
  >> pd.get_dummies(data)
     color_b  color_g  color_r  depth_h  depth_l
  0        0        0        1        1        0
  1        0        0        1        1        0
  2        0        1        0        0        1
  3        0        1        0        0        1
  4        1        0        0        1        0
  
  >> pd.get_dummies(data['color'])
     b  g  r
  0  0  0  1
  1  0  0  1
  2  0  1  0
  3  0  1  0
  4  1  0  0
  
  >> pd.get_dummies(data['color'], prefix='color', prefix_sep='-')
     color-b  color-g  color-r
  0        0        0        1
  1        0        0        1
  2        0        1        0
  3        0        1        0
  4        1        0        0
  ```

# 14、升维 `np.newaxis`

```python
>> data = np.array([1,2,3])
>> data
array([1, 2, 3])

>> data[:, np.newaxis]  # 原本是一维的，增加一维变成二维的
array([[1],
       [2],
       [3]])
       
>> data[:, np.newaxis] + np.array([[10,10,10], [10,10,10], [10,10,10]])  # 运算的时候会自动填充值
array([[11, 11, 11],
       [12, 12, 12],
       [13, 13, 13]])
```

# 15、映射操作 `apply`

- `DataFrame.apply(func, axis=0)`

  - 将数据的每一行/列送入`func`中做相同的映射操作，放回一个新的数据

  - `func`：映射操作的函数，`func`中需要返回值

  - `axis`：指定对列还是行进行映射，默认为0，0表示对列操作，1表示对行操作

    ```python
    >> data
    	A	B
    0	1	2
    1	2	4
    2	3	6
    
    >> data.apply(np.sum, axis=0)  
    A     6
    B    12
    dtype: int64
    
    >> data.apply(np.sum, axis=1)
    0    3
    1    6
    2    9
    dtype: int64
    ```

# 16、遍历DF数据 `itertuples` `iterrows`

- `pd.DataFrame.itertuples()`

  - 用于遍历df数据类型，会生成一个可迭代数据（元组），其中每个元素包含了df数据中一行数据的信息

    ```python
    >> data
    	A	B
    0	1	10
    1	2	20
    2	3	30
    3	4	40
    
    >> for line in data.itertuples():
           print(line)
           print('A: ', getattr(line, 'A'))
           print('B: ', getattr(line, 'B'))
    Pandas(Index=0, A=1, B=10)
    A:  1
    B:  10
    Pandas(Index=1, A=2, B=20)
    A:  2
    B:  20
    Pandas(Index=2, A=3, B=30)
    A:  3
    B:  30
    Pandas(Index=3, A=4, B=40)
    A:  4
    B:  40
    ```

- 扩展：另一个类似的api，即``pd.DataFrame.iterrows()`

  ```python
  >> for i, line in data.iterrows():
         print('第', str(i), '行')
         print('A、B的值：', line['A'], line['B'])
  第 0 行
  A、B的值： 1 10
  第 1 行
  A、B的值： 2 20
  第 2 行
  A、B的值： 3 30
  第 3 行
  A、B的值： 4 40
  ```

# 17、其它第三方包里的api

## （1）计算距离 `scipy.cdist`

- `scipy.spatial.distance.cdist(XA, XB, metric='euclidean')`

  - 计算两个数组（`XA`和`XB`）中元素之间的距离

  - `metric`：使用的距离，默认为`euclidean`，表示使用欧式距离

    ```python
    >> XA = np.array([[1,2], [2,3], [1,1]])
    >> XB = np.array([[2,4], [3,5]])
    >> cdist(XA, XB)
    array([[2.23606798, 3.60555128],
           [1.        , 2.23606798],
           [3.16227766, 4.47213595]])
    ```

    - 结果第一行分别表示`XA`中第一个点到`XB`中所有点的距离

## （2）划分数据集 `train_test_splits`

- `sklearn.model_selection.train_test_split(*arrays, test_size=None, trai_size=None)`

  - 划分训练集和测试集

  - `*arrays`：准备划分的数据集，可以传多个需要划分的数据集进去

  - `test_size`：测试集的大小，和`train_size`互补，如果都为`None`，则默认为0.25

    ```python
    >>> import numpy as np
    >>> from sklearn.model_selection import train_test_split
    >>> X, y = np.arange(10).reshape((5, 2)), range(5)
    >>> X
    array([[0, 1],
    [2, 3],
    [4, 5],
    [6, 7],
    [8, 9]])
    >>> list(y)
    [0, 1, 2, 3, 4]
    
    >>> X_train, X_test, y_train, y_test = train_test_split(
    ...     X, y, test_size=0.33, random_state=42)
    ...
    >>> X_train
    array([[4, 5],
    [0, 1],
    [6, 7]])
    >>> y_train
    [2, 0, 3]
    >>> X_test
    array([[2, 3],
    [8, 9]])
    >>> y_test
    [1, 4]
    ```

## （3）逻辑回归模型 `LogisticRegression`

- `from sklearn.linear_model import LogisticRegression`
- `LogisticRegression()` 返回一个逻辑回归的分类模型接受参数如下
  - `penalty : {'l1', 'l2', 'elasticnet', 'none'}, default='l2'` 选择正则化的类型
  - `tol : float, default=1e-4` 迭代精度
  - `C : float, default=1.0` 正则化系数的倒数，该值越小，防止过拟合效果越好
  - `fit_intercept : bool, default=True` 是否使用独立变量b
  - `class_weight : dict or 'balanced', default=None` 标示分类模型中各种类别的权重，不输入即不考虑权重
    - 选择balanced，那么类库会根据训练样本量来计算权重。某种类型样本量越多，则权重越低，样本量越少，则权重越高
    - 自己输入各个类型的权重，如`class_weight={0:0.9, 1:0.1}`，这样类别0的权重为90%，而类别1的权重为10%
    - 什么时候考虑该参数：误分类代价很大（如错分癌症病人为非癌症病人）或者训练样式类型严重失衡
  - `solver : {'newton-cg', 'lbfgs', 'liblinear', 'sag', 'saga'}, default='lbfgs'` 选择求解优化问题的方法
    -  liblinear：使用了开源的liblinear库实现，内部使用了坐标轴下降法来迭代优化损失函数。
    - lbfgs：拟牛顿法的一种，利用损失函数二阶导数矩阵即海森矩阵来迭代优化损失函数。
    - newton-cg：也是牛顿法家族的一种，利用损失函数二阶导数矩阵即海森矩阵来迭代优化损失函数。
    - sag：即随机平均梯度下降，是梯度下降法的变种，和普通梯度下降法的区别是每次迭代仅仅用一部分的样本来计算梯度，适合于样本数据多的时候
  - `multi_class : {'auto', 'ovr', 'multinomial'}, default='auto'` 多分类的方法
  - `max_iter : int, default=100` 最大迭代轮数
- 该分类器的一些方法
  - `fit()` 训练拟合数据
  - `predict` 预测数据，得到的结果是分类结果
  - `predict_proba` 预测数据，得到的结果是分类的可能性（每个预测样本分成各种类别的概率）