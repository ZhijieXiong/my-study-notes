[TOC]

# 1、创建数组

```python
import numpy as np
```

- 常规

```python
# 创建数组：dtype指定类型
x1 = np.array([1, 2, 3], dtype=np.int8)  # 一维
x2 = np.array([[1, 2, 3], [4, 5, 6]])  # 二维
x3 = np.array([[[1, 2, 3], [4, 5, 6]], [[7, 8, 9], [10, 11, 12]]])  # 三维
print(x1.shape)  # 形状
print(x1.ndim)  # 维度
print(x1.size)  # 元素个数
print(x1.itemsize)  # 元素长度（字节）
print(x1.dtype)  # 元素类型

>> (3,)
>> 1
>> 3
>> 1
>> int8
```

- 创建0数组和1数组

```python
# 生成0数组：第一个参数是形状，第二个参数是类型
# np.ones同理
np.zeros((2, 5), np.int8)
>> array([[0, 0, 0, 0, 0],
       [0, 0, 0, 0, 0]], dtype=int8)
       
# 生成一个相同类型的1数组
# np.zeros_like同理
x = np.zeros((2, 5), np.int8)
np.ones_like(x, np.float32)
>> array([[1., 1., 1., 1., 1.],
       [1., 1., 1., 1., 1.]], dtype=float32)
```

- 拷贝数组

```python
# 拷贝数组
x = np.array([1, 2, 3])
x1 = np.array(x)  # 深拷贝
x2 = np.asarray(x)  # 浅拷贝
x[0] = 10
print(x)
print(x1)
print(x2)
>> [10  2  3]
>> [1 2 3]
>> [10  2  3]
```

- 创建数组api
  - np.linspace(start, stop, num, endpoint)
    - 创建等差数组：num为生成元素的数量，默认为50，endpoint为序列中是否包含stop，默认为true
  - np.arange(start, stop, step, dtype)
  - np.logspace(start, stop, num)
    - 创建等比数组：第一个是10的start次方，最后一个是10的stop次方，总共num个

```python
np.linspace(10, 20, 5, False)
>> array([10., 12., 14., 16., 18.])
np.arange(10, 20, 2, np.int8)
>> array([10, 12, 14, 16, 18], dtype=int8)
np.logspace(1, 2, 4)
>> array([ 10.        ,  21.5443469 ,  46.41588834, 100.        ])
```

- 创建正态分布和均匀分布
  - np.random.normal(loc=0.0, scale=1.0, size=None)
    - 生成正态分布数组：loc为均值，scale为标准差，size为生成的数组的形状
  - np.random.uniform(low=0.0, high=1.0, size=None)
    - 生成均匀分布数组

```python
x1 = np.random.normal(0, 1, 10)
x2 = np.random.normal(0, 1, (2, 10))
print(x1)
print(x2)
>> [ 0.3117672  -2.0058746   0.16069516 -0.10982544 -0.9256688   0.36018661
 -0.79429677  0.70706611 -0.67733649  1.35057207]
>> [[-1.12753503 -0.25411446  0.84986503 -0.12683571 -0.25178885 -2.92816742
   1.16781789 -0.67780322  0.09296055 -0.04374906]
 [ 0.5447254   0.5887397  -0.66465345 -1.7832509  -0.21001679  0.92932282
  -1.03997949 -1.01719389  0.22616312  0.60929088]]

x1 = np.random.uniform(0, 1, 10)
x2 = np.random.uniform(0, 1, (2, 10))
print(x1)
print(x2)
>> [0.35316555 0.5670841  0.96635363 0.98976281 0.04747395 0.01745273
 0.3022033  0.30207236 0.97780878 0.34818569]
>> [[0.85216057 0.17237434 0.02904573 0.05872522 0.33996028 0.56408388
  0.33893083 0.40123852 0.36307191 0.22547218]
 [0.49288663 0.71012096 0.05366941 0.08197763 0.33880603 0.25347163
  0.88224077 0.47408987 0.49167697 0.6301454 ]]
```

# 2、数组索引和切片

- 数组索引和切片
  - 中括号第几个参数就表示第几维度
  - 每一维度：[start:stop:step]

```python
x = np.array([[1, 2, 3], [4, 5, 6]])
print(x[0, 1])  # 第1行第2列
print(x[0, ::])  # 第1行
print(x[0, 0:3:2])  # 第1行，索引从0开始，到2结束，以2为步长
print(x[0, ::-1])  # 步长为-1表示逆序
print(x[0, 1::-1])
>> 2
>> [1 2 3]
>> [1 3]
>> [3 2 1]
>> [2 1]
```

- 改变形状和类型

```python
# 改变形状
# ndarray.reshape(shape, order)，注意数组元素个数要符合形状，返回新数组
# ndarray.resize(new_shape)，改变原数组
# ndarray.T，矩阵置换
x = np.array([[1, 2, 3], [4, 5, 6]])
x1 = x.reshape((3, 2))
x2 = x.reshape((-1, 6))  # -1表示待计算
print(x1)
print(x2)
>> [[1 2]
 [3 4]
 [5 6]]
>> [[1 2 3 4 5 6]]
# ndarray.astype(type)，返回修改了类型之后的数组
# ndarray.tostring([order])/ndarray.tobytes([order])，构造包含数组中原始数据字节的python字节
# np.unique()，去重
x = np.array([[1, 2, 1], [2, 3, 4]])
np.unique(x)
>> array([1, 2, 3, 4])
```

# 3、数组运算

- 逻辑运算

```python
score = np.random.randint(40, 100, (10, 5))
test_score = score[6:, :]
test_score
>> array([[57, 93, 88, 50, 81],
       [85, 74, 54, 45, 78],
       [59, 81, 55, 51, 62],
       [47, 42, 91, 71, 59]])
test_score >= 60
>> array([[False,  True,  True, False,  True],
       [ True,  True, False, False,  True],
       [False,  True, False, False,  True],
       [False, False,  True,  True, False]])
test_score[test_score >= 60] = 1  # 大于等于60置为1
test_score[test_score != 1] = 0
test_score
array([[0, 1, 1, 0, 1],
       [1, 1, 0, 0, 1],
       [0, 1, 0, 0, 1],
       [0, 0, 1, 1, 0]])
```

- 通用判断函数

```python
score = np.random.randint(40, 100, (10, 5))
score
>> array([[89, 84, 41, 55, 93],
       [83, 48, 40, 86, 65],
       [94, 97, 80, 59, 94],
       [75, 98, 95, 78, 86],
       [44, 48, 62, 59, 40],
       [58, 51, 74, 43, 75],
       [40, 49, 55, 60, 94],
       [95, 65, 97, 78, 62],
       [43, 80, 64, 69, 46],
       [72, 65, 67, 84, 91]])
np.all(score[0:2, :] >= 60)  # 所有都要大于60
>> False
np.any(score[0:2, :] >= 60)  # 只要有一个大于60
>> True
```

- 三元运算符：np.where()

```python
score = np.random.randint(40, 100, (10, 5))
tmp1 = score[:4, :]
tmp2 = score[4:, :]
tmp1
>> array([[89, 84, 41, 55, 93],
       [83, 48, 40, 86, 65],
       [94, 97, 80, 59, 94],
       [75, 98, 95, 78, 86]])
tmp2
>> array([[44, 48, 62, 59, 40],
       [58, 51, 74, 43, 75],
       [40, 49, 55, 60, 94],
       [95, 65, 97, 78, 62],
       [43, 80, 64, 69, 46],
       [72, 65, 67, 84, 91]])
np.where(tmp1 >= 60, "P", "F")  # 大于等于60的置为'P'，其余置为'F'
>> array([['P', 'P', 'F', 'F', 'P'],
       ['P', 'F', 'F', 'P', 'P'],
       ['P', 'P', 'P', 'F', 'P'],
       ['P', 'P', 'P', 'P', 'P']], dtype='<U1')
np.where(np.logical_and(tmp2 >= 60, tmp2 <= 100), 'P', 'F')  
>> array([['F', 'F', 'P', 'F', 'F'],
       ['F', 'F', 'P', 'F', 'P'],
       ['F', 'F', 'F', 'P', 'P'],
       ['P', 'P', 'P', 'P', 'P'],
       ['F', 'P', 'P', 'P', 'F'],
       ['P', 'P', 'P', 'P', 'P']], dtype='<U1')
```

- 统计运算api
  - np.min(array, axis)，axis为0或1，指定行或者列
  - np.max(array, axis)
  - np.median(array, axis)
  - np.mean(array, axis, dtype)，平均值
  - np.std(array, axis, dtype)，标准差
  - np.var(array, axis, dtype)，方差
  - np.argmax(array, axis)，获取最大值的索引
  - np.argmin(array, axis)

```python
score = np.random.randint(40, 100, (5, 5))
score
>> array([[62, 71, 87, 81, 97],
       [50, 92, 49, 68, 64],
       [79, 78, 63, 65, 73],
       [55, 68, 92, 41, 86],
       [48, 61, 68, 58, 81]])
np.mean(score, axis=0)
>> array([58.8, 74. , 71.8, 62.6, 80.2])
np.std(score, axis=0)
>> array([11.196428  , 10.52615789, 15.81644714, 13.12402377, 11.23209687])
np.var(score, axis=0)
>> array([125.36, 110.8 , 250.16, 172.24, 126.16])
np.argmax(np.mean(score, axis=0), axis=0)
>> 4
```

- 数组间运算

```python
arr = np.array([[1, 2, 3], [4, 5, 6]])
arr + 1
>> array([[2, 3, 4],
       [5, 6, 7]])
arr * 2
>> array([[ 2,  4,  6],
       [ 8, 10, 12]])
(arr + 1) + (arr + 2)
>> array([[ 5,  7,  9],
       [11, 13, 15]])
```

- 矩阵运算

```python
a = np.array([[1, 2], [3, 4]])
b = np.array(a)
a
>> array([[1, 2],
       [3, 4]])
b
>> array([[1, 2],
       [3, 4]])
np.matmul(a, b)  # 禁止矩阵与标量的运算
>> array([[ 7, 10],
       [15, 22]])
np.dot(a, b)
>> array([[ 7, 10],
       [15, 22]])
```

