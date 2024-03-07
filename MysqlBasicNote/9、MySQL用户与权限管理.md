[TOC]

# 一、权限表

- MySQL服务器通过权限表来控制用户对数据库的访问
- 权限表存储在`mysql`数据库中

## 1、user表

- user表记录了允许连接到服务器的账号信息
- user表的字段分为4类，分别是用户列、权限列、安全列和资源控制列
- user表里的权限是全局级的

### （1）用户列

|        字段名         |  含义  |
| :-------------------: | :----: |
|         User          | 用户名 |
|         Host          | 主机名 |
| authentication_string |  密码  |

### （2）权限列

- user表的权限列是全局权限，是针对所有数据库的
- 权限列的字段的值都为ENUM值，只有Y和N值

|   字段名    |    含义    | 默认值 |
| :---------: | :--------: | :----: |
| Select_priv | SELECT权限 |   N    |
| Insert_priv | INSERT权限 |   N    |
|   ......    |   ......   | ...... |
|  Drop_priv  |  DROP权限  |   N    |

### （3）安全列

| 字段名                | 类型     | 默认值 |
| --------------------- | -------- | ------ |
| ssl_type              | ENUM     |        |
| ssl_chiper            | BLOB     | NULL   |
| x509_issuer           | BLOB     | NULL   |
| x509_subject          | BLOB     | NULL   |
| plugin                | char(64) |        |
| authentication_string | text     | NULL   |

### （4）资源控制列

| 字段名               | 含义                             | 默认值 |
| -------------------- | -------------------------------- | ------ |
| max_question         | 用户每小时允许执行的查询操作次数 | 0      |
| max_updates          | ～更新操作次数                   | 0      |
| max_connections      | ～连接操作次数                   | 0      |
| max_user_connections | 用户允许同时建立的连接次数       | 0      |

- 当操作超过权限时，用户将被锁定，直到下一个小时

## 2、db表

- db表存储了用户对某个数据库的操作权限
- db表的字段同样分为用户列和权限列，和user表一样
- 注意user表的权限是全局的，db表的权限是针对某一个数据库的

## 3、tables_priv表

- tables_priv表用来对表设置权限，其字段（User、Host略）如下

| 字段名      | 含义                                              |
| ----------- | ------------------------------------------------- |
| Db          | 表所在数据库                                      |
| Table_name  | 权限所属的表                                      |
| Grantor     | 修改该记录的用户                                  |
| Timestamp   | 修改纪录的时间                                    |
| Table_priv  | 表的操作权限（SELECT、INSERT······）              |
| Column_priv | 列的操作权限（SELECT、INSERT、UPDATE、REFERANCE） |

## 4、columns_priv表

- columns_priv表用于对表的某一列设置权限

- 表的字段和table_priv一样，多了个column_name列

## 5、procs_priv表

- props_priv表可以对存储过程和存储函数设置权限

# 二、账户管理

## 1、登入mysql服务器

```shell
mysql [-h 主机名] -u <用户名> -p[密码] [-P 端口号] [-e 命令] [数据库名]  
```

- 密码可以选择明文输入
- -e选项后面的命令会在登入服务器后直接执行
- 登入时可以选择数据库

## 2、新建普通用户

### （1）使用CREATE USER语句

- 使用CREATE USER语句要求有全局权限或者MySQL数据库的INSERT权限
- 使用CREATE USER语句创建的用户没有任何权限

```mysql
CREATE USER <user@host> 
[IDENTIFIED BY [PASSWORD] 'password' 
| IDENTIFIED WITH auth_plugin [AS 'auth_string']];
```

- `user、host`分别为用户名和主机名
- `[PASSWORD]`表示使用哈希值设置密码
- `password`为明文密码
- `IDENTIFIED WITH`表示为用户指定一个身份验证插件
- `auth_string`为传递给身份验证插件的参数

```mysql
mysql> CREATE USER 
			 "dream"@"localhost" 
			 IDENTIFIED BY "sicn2h8f";
Query OK, 0 rows affected (0.04 sec)

mysql> USE mysql;
Database changed
mysql> SELECT User, Host FROM user;
+---------------+-----------+
| User          | Host      |
+---------------+-----------+
| dream         | localhost |
| mysql.session | localhost |
| mysql.sys     | localhost |
| root          | localhost |
+---------------+-----------+
4 rows in set (0.00 sec)
```

### （2）使用GRANT语句

- 使用GRANT语句可以在创建用户的同时给用户赋予权限

```mysql
GRANT <priv1, priv2, ...> 
ON <database.table>
TO <user@host> [IDENTIFIED BY "password"];
```

```mysql
mysql> DROP USER "dream"@"localhost";
Query OK, 0 rows affected (0.02 sec)

mysql> SELECT User, Host FROM user;
+---------------+-----------+
| User          | Host      |
+---------------+-----------+
| mysql.session | localhost |
| mysql.sys     | localhost |
| root          | localhost |
+---------------+-----------+
3 rows in set (0.00 sec)

mysql> GRANT SELECT, UPDATE 
			 ON *.* 
			 TO "dream"@"localhost" 
			 IDENTIFIED BY "sicn2h8f";
Query OK, 0 rows affected, 1 warning (0.02 sec)

mysql> SELECT User, Host, Select_priv, Update_priv 
       FROM user 
       WHERE User="dream" AND Host="localhost";
+-------+-----------+-------------+-------------+
| User  | Host      | Select_priv | Update_priv |
+-------+-----------+-------------+-------------+
| dream | localhost | Y           | Y           |
+-------+-----------+-------------+-------------+
1 row in set (0.00 sec)
```

### （3）直接操作mysql.user表

- CREATE  USER语句和GRANT语句本质上都是操作user表来创建用户的

## 3、删除普通用户

- 使用DROP USER语句可以删除用户
- 也可以使用DELETE语句直接操作mysql.user表来删除用户

## 4、修改root用户密码

**（1）使用mysqladmin修改**

```mysql
mysqladmin -h <主机名> -u <用户名> -p <当前密码> "nswpassword"
```

**（2）使用SET语句修改当前账户密码**

```mysql
SET PASSWORD = "newpassword" | PASSWORD(newpassword);
```

- PASSWORD()是密码加密函数
- 为使修改生效，需要重启mysql或者使用FLUSH PRIVILEGES语句刷新

**（3）直接修改mysql.user表**

## 5、root用户修改普通用户密码

**（1）使用SET语句修改**

```mysql
SET PASSWORD FOR "user"@"host" = "newpassword";
```

- 普通用户也可以使用SET语句修改自己密码

（2）使用GRANT USAGE语句修改**

```mysql
GRANT USAGE ON *.* TO user@host INDENTIFIED BY "newpassword";
```

**（3）直接修改mysql.user表**

## 6、root用户密码丢失的解决办法





# 三、权限管理

## 1、MySQL中的各种权限

`CREATE: Create_priv`    `DROP: Drop_priv`    `GRANT OPTION: Grant_priv`  
`REFERANCES: Referances_priv`  `EVENT: Event_priv`    `ALTER: Alter_priv` 
`DELETE: Delete_priv`    `INDEX: Index_priv`    `INSERT: Insert_priv`   
`SELECT: Slect_priv`    `UPDATE: Update_priv`    `CREATE TEMPORARY TABLES: Create_temp_table_priv`    `LOCK TABLES: Lock_tables_priv`    `TRIGGE: Trigger_priv`    `CREATE VIEW: Create_view_priv`   
`SHOW VIEW: Show_view_priv`    `ALTER ROUTINE: Alter_routine_priv`    `CREATE ROUTINE: Create_rouinte_priv`    `EXECUTE: Excute_priv`    `FILE: File_priv`  
`CREATE TABLESPACE: Create_tablespace_priv`    `CREATE USER: Create_user_priv`  
`PROCESS: Process_priv`    `RELOAD: Reload_priv`    `REPLICATION CLIENT: Repl_client_priv`   
`SHOW DATABASES: Show_db_priv`    `SHUTDOWN: Shotdown_priv`    `SUPER: Super_priv`

- SELECT、INSERT、UPDATE、DELETE权限允许在一个数据库中现有的表上操作
- CREATE ROUTINE用来创建程序；ALTER ROUTINE用来更改和删除程序；EXCUTE用来执行程序
- GRANT权限允许授权给其他用户
- FILE权限允许用户读或写MySQL服务器上的所有文件（可创建新文件，但不能覆盖原文件）
- RELOAD权限允许用户使用flush-hosts，flush-logs，flush-privileges，flush-status，flush-tables，flush-threads，refresh，reload命令
  - reload：服务器重新将授权表读入内存
  - refresh：清空所有表打开/关闭纪录
  - flush-xxx：类似于refresh命令，只是范围更有限，如flush-logs用来清空记录文件
- SHUTDOWN权限允许用户使用shutdown命令用来关闭服务器
- PROCESS权限允许用户使用processlist命令用来显示服务器内执行的线程的信息
- SUPER权限允许用户执行kill命令

```mysql
mysql> SHOW PROCESSLIST;
+----+------+-----------+-------+---------+------+----------+------------------+
| Id | User | Host      | db    | Command | Time | State    | Info             |
+----+------+-----------+-------+---------+------+----------+------------------+
|  7 | root | localhost | mysql | Query   |    0 | starting | SHOW PROCESSLIST |
+----+------+-----------+-------+---------+------+----------+------------------+
1 row in set (0.00 sec)
```

## 2、权限的层级

- 全局级别：全局级别的权限存储在mysql.user表中，适用于一个给定服务器的所有数据库
- 数据库级别：数据库级别的权限存储在mysql.db和mysql.host表中，适用于一个给定数据库的所有目标
- 表级别：表级别的权限存储在mysql.tables_priv表中，适用于一个给定表的所有列
- 列级别：列级别的权限存储在mysql.columns_priv表中，适用于一个给定表的单一列
- 子程序级别：子程序级别的权限存储在mysql.procs_priv表中，适用于已存储的子程序

## 3、授权操作命令GRANT

- 使用GRANT命令必须要有`GRANT OPTION`权限

```mysql
GRANT <权限类型> [字段名]
ON [object_type] <数据库名.表名>
TO <用户名>@<主机名>
[IDENTIFIED BY [PASSWORD] "password"]
[WITH GRANT OPTION | MAX_QUERIES_PRE_HOUR count | MAX_UPDATES_PRE_HOUR count | 
MAX_CONNECTIONS_PRE_HOUR count | MAX_USER_CONNECTIONS count];
```

- 忽略字段名则该权限作用于整个表上
- object_type指定授权作用的对象，包括表、函数和存储过程
- WITH后面跟的参数的含义分别是：
  - 被授权的用户可以将这些权限授予给其他用户
  - 每小时可以执行的查询操作次数
  - 每小时可以执行的更新操作次数
  - 每小时可以执行的连接操作次数
  - 设置单个用户可以同时建立的连接个数

```mysql
mysql> SELECT User, Host, Drop_priv, Grant_priv, max_user_connections 
			 FROM user 
			 WHERE User="dream" AND Host="localhost";
+-------+-----------+-----------+------------+----------------------+
| User  | Host      | Drop_priv | Grant_priv | max_user_connections |
+-------+-----------+-----------+------------+----------------------+
| dream | localhost | N         | N          |                    0 |
+-------+-----------+-----------+------------+----------------------+
1 row in set (0.00 sec)

mysql> GRANT DROP 
			 ON *.* 
			 TO "dream"@"localhost" 
			 WITH GRANT OPTION;
Query OK, 0 rows affected (0.02 sec)

mysql> GRANT DROP 
			 ON *.* 
			 TO "dream"@"localhost" 
			 WITH MAX_USER_CONNECTIONS 10;
Query OK, 0 rows affected, 1 warning (0.01 sec)

mysql> SELECT User, Host, Drop_priv, Grant_priv, max_user_connections FROM user WHERE User="dream" AND Host="localhost";
+-------+-----------+-----------+------------+----------------------+
| User  | Host      | Drop_priv | Grant_priv | max_user_connections |
+-------+-----------+-----------+------------+----------------------+
| dream | localhost | Y         | Y          |                   10 |
+-------+-----------+-----------+------------+----------------------+
1 row in set (0.00 sec)
```

- WITH后面的参数一次只能跟一个

## 4、收回权限命令REVOKE

- 使用REVOKE权限必须要有`GRANT OPTION`权限
- 使用REVOKE收回权限后，用户的纪录会从db表、host表、ttables_priv表和columns_priv表中删除，但是用户账户纪录仍在user表中

```mysql
# 收回所有权限
REVOKE ALL PRIVILEGES, GRANT OPTION
FROM "user"@"host";

# REVOKE语句格式
REVOKE <权限类型> [字段名]
ON [object_type] <数据库名.表名>
FROM <用户名>@<主机名>;
```

## 5、查看权限SHOW GRANTS

```mysql
mysql> SHOW GRANTS FOR "dream"@"localhost";
+----------------------------------------------------------------------------+
| Grants for dream@localhost                                                 |
+----------------------------------------------------------------------------+
| GRANT SELECT, UPDATE, DROP ON *.* TO 'dream'@'localhost' WITH GRANT OPTION |
+----------------------------------------------------------------------------+
1 row in set (0.00 sec)
```

- 或者查看权限表

# 四、访问控制

- MySQL的访问控制分为两个阶段
  - 第一阶段：连接核实阶段，该阶段服务器核实连接的用户的身份信息（用户名、主机名、密码）
  - 第二阶段：请求核实阶段，服务器等待用户的请求（如SELECT操作），服务器开始从全局级别往下查找用户的权限，直到找到，如用户没有该操作权限，则返回错误