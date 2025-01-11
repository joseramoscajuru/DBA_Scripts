

-- Get a list of databases:

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| scm                |
| sys                |
+--------------------+
5 rows in set (0.00 sec)


-- Create a database

create database test;

-- Select the database you want to use

mysql> use scm
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
