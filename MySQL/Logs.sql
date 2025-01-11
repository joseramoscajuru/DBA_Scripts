
[mysqld]
log = /var/log/mysql/mysql.log 

general_log_file        = /var/log/mysql/mysql.log
general_log             = 1



[mysqld_safe]
log-error=/var/log/mysqld.log

SHOW VARIABLES LIKE '%log%';

General log - all queries - see VARIABLE general_log
Slow log - queries slower than long_query_time - slow_query_log_file
Binlog - for replication and backup - log_bin_basename
Relay log - also for replication
general errors - mysqld.err
start/stop - mysql.log (not very interesting) - log_error
InnoDB redo log - iblog*
See the variable basedir and datadir for default location for many logs

Some logs are turned on/off by other VARIABLES. Some are either written to a file or to a table.

mysql> SHOW VARIABLES LIKE '%general_log%';
+------------------+--------------------------------+
| Variable_name    | Value                          |
+------------------+--------------------------------+
| general_log      | OFF                            |
| general_log_file | /data/mysql/rrpvsao01a0401.log |
+------------------+--------------------------------+
2 rows in set (0.00 sec)

mysql> SHOW VARIABLES LIKE '%slow_query%';
+---------------------+-------------------------------------+
| Variable_name       | Value                               |
+---------------------+-------------------------------------+
| slow_query_log      | OFF                                 |
| slow_query_log_file | /data/mysql/rrpvsao01a0401-slow.log |
+---------------------+-------------------------------------+
2 rows in set (0.00 sec)

SET GLOBAL general_log = 'ON'; 

SET GLOBAL log_error= '/var/log/mysql/mysql.log';

[root@rrpvsao01a0401 log]# cat /etc/my.cnf |grep general
general_log = 1
general_log=/data/mysql/rrpvsao01a0401.log
[root@rrpvsao01a0401 log]# cat /etc/my.cnf |grep err
log_error=/var/log/mysqld.log
