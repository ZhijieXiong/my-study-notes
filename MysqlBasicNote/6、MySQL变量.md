[TOC]

# 1、变量的类别

- 系统变量
  - 全局变量：对所有连接均有效
  - 会话变量：仅对本次连接有效

- 自定义变量
  - 用户变量：仅对本次连接有效
  - 局部变量：仅在定义改变量的BEGIN···END语句中有效

# 2、系统变量

- 系统变量由系统提供，属于服务器层面使用的语法

## （1）查看系统变量

- 查看所有系统变量

```mysql
SHOW GLOBAL|[SESSION] VARIABLES [LIKE '匹配的表达式'];
```

```mysql
mysql> SHOW GLOBAL VARIABLES\G;
*************************** 1. row ***************************
Variable_name: auto_generate_certs
        Value: ON
*************************** 2. row ***************************
Variable_name: auto_increment_increment
        Value: 1
...
*************************** 502. row ***************************
Variable_name: wait_timeout
        Value: 28800
502 rows in set (0.04 sec)

mysql> SHOW SESSION VARIABLES\G;
*************************** 1. row ***************************
Variable_name: auto_generate_certs
        Value: ON
*************************** 2. row ***************************
Variable_name: auto_increment_increment
        Value: 1
...
*************************** 516. row ***************************
Variable_name: warning_count
        Value: 0
516 rows in set (0.00 sec)

mysql> SHOW GLOBAL VARIABLES LIKE "auto%"\G;
*************************** 1. row ***************************
Variable_name: auto_generate_certs
        Value: ON
*************************** 2. row ***************************
Variable_name: auto_increment_increment
        Value: 1
*************************** 3. row ***************************
Variable_name: auto_increment_offset
        Value: 1
*************************** 4. row ***************************
Variable_name: autocommit
        Value: ON
*************************** 5. row ***************************
Variable_name: automatic_sp_privileges
        Value: ON
5 rows in set (0.00 sec)
```

- 查看指定系统变量（必须加上@@表示为系统变量）

```mysql
mysql> SELECT @@GLOBAL.auto_increment_increment;
+-----------------------------------+
| @@GLOBAL.auto_increment_increment |
+-----------------------------------+
|                                 1 |
+-----------------------------------+
1 row in set (0.00 sec)

mysql> SELECT @@SESSION.auto_increment_increment;
+------------------------------------+
| @@SESSION.auto_increment_increment |
+------------------------------------+
|                                  1 |
+------------------------------------+
1 row in set (0.00 sec)
```

## （2）为系统变量赋值

```mysql
SET GLOBAL|[SESSION] <变量名> = <值>;
SET @@GLOBAL|[SESSION].<变量名> = <值>;
```

```mysql
mysql> SET @@SESSION.auto_increment_increment = 2;
Query OK, 0 rows affected (0.00 sec)

mysql> SELECT @@SESSION.auto_increment_increment;
+------------------------------------+
| @@SESSION.auto_increment_increment |
+------------------------------------+
|                                  2 |
+------------------------------------+
1 row in set (0.00 sec)
```

# 3、自定义变量

- 自定义变量由用户自己定义，步骤为声明、赋值、使用

## （1）用户变量

- 声明并赋值，不必知道类型

```mysql
SET @<变量名> = <值>;
SET @<变量名> := <值>;
SELECT @<变量名> := <值>;
```

```mysql
mysql> SET @test = 1;
Query OK, 0 rows affected (0.00 sec)

mysql> SELECT @test;
+-------+
| @test |
+-------+
|     1 |
+-------+
1 row in set (0.00 sec)

mysql> SELECT @test := "test";
+-----------------+
| @test := "test" |
+-----------------+
| test            |
+-----------------+
1 row in set (0.00 sec)
```

- 另一种赋值方式，通过SELECT INTO把表里的值赋给变量 

```mysql
mysql> SELECT User INTO @test 
			 FROM user 
			 WHERE User="root";
Query OK, 1 row affected (0.00 sec)

mysql> SELECT @test;
+-------+
| @test |
+-------+
| root  |
+-------+
1 row in set (0.00 sec)
```

## （2）局部变量

- 局部变量仅在BEGIN···END中有效
- 局部变量的声明使用DECLARE语句，赋值方法和用户变量一样

```mysql
DECLARE <变量名> <类型> [DEFAULT 默认值]
```

