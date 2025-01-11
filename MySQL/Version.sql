How to check MySQL version number?

mysql> SELECT @@version;
+------------+
| @@version  |
+------------+
| 5.7.33-log |
+------------+
1 row in set (0.00 sec)


mysql> SELECT VERSION();
+------------+
| VERSION()  |
+------------+
| 5.7.33-log |
+------------+
1 row in set (0.00 sec)


You can also use the STATUS command in MySQL cli tool to find MySQL version number (output truncated)

mysql> SHOW GLOBAL VARIABLES LIKE '%version%';
+-------------------------+------------------------------+
| Variable_name           | Value                        |
+-------------------------+------------------------------+
| innodb_version          | 5.7.33                       |
| protocol_version        | 10                           |
| slave_type_conversions  |                              |
| tls_version             | TLSv1,TLSv1.1,TLSv1.2        |
| version                 | 5.7.33-log                   |
| version_comment         | MySQL Community Server (GPL) |
| version_compile_machine | x86_64                       |
| version_compile_os      | Linux                        |
+-------------------------+------------------------------+
8 rows in set (0.02 sec)


mysql> STATUS;
--------------
mysql  Ver 14.14 Distrib 5.7.33, for Linux (x86_64) using  EditLine wrapper

Connection id:		67
Current database:	
Current user:		root@localhost
SSL:			Not in use
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server version:		5.7.33-log MySQL Community Server (GPL)
Protocol version:	10
Connection:		Localhost via UNIX socket
Server characterset:	latin1
Db     characterset:	latin1
Client characterset:	utf8
Conn.  characterset:	utf8
UNIX socket:		/data/mysql/mysql.sock
Uptime:			49 days 22 hours 6 min 56 sec

Threads: 16  Questions: 86555185  Slow queries: 0  Opens: 1214  Flush tables: 1  Open tables: 1163  Queries per second avg: 20.067
--------------


Using mysqladmin to check MySQL version:

[root@rrpvsao01a0401 /]# mysqladmin -u root -p -hlocalhost version
Enter password: 
mysqladmin  Ver 8.42 Distrib 5.7.33, for Linux on x86_64
Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Server version		5.7.33-log
Protocol version	10
Connection		Localhost via UNIX socket
UNIX socket		/data/mysql/mysql.sock
Uptime:			4 days 1 hour 25 min 22 sec

Threads: 12  Questions: 7132675  Slow queries: 0  Opens: 1055  Flush tables: 1  Open tables: 1005  Queries per second avg: 20.337


[root@rrpvsao01a0401 /]# mysql --version
mysql  Ver 14.14 Distrib 5.7.33, for Linux (x86_64) using  EditLine wrapper

