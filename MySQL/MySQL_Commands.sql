


mysql> SHOW VARIABLES LIKE '%innodb_data_file_path%';
+-----------------------+------------------------+
| Variable_name         | Value                  |
+-----------------------+------------------------+
| innodb_data_file_path | ibdata1:12M:autoextend |
+-----------------------+------------------------+

mysql> SELECT VERSION(), CURRENT_DATE;
+------------+--------------+
| VERSION()  | CURRENT_DATE |
+------------+--------------+
| 5.7.33-log | 2021-06-22   |
+------------+--------------+

mysql> select sin(pi()/2);
+-------------+
| sin(pi()/2) |
+-------------+
|           1 |

mysql> SELECT VERSION(); SELECT NOW();
+------------+
| VERSION()  |
+------------+
| 5.7.33-log |
+------------+
1 row in set (0.00 sec)

+---------------------+
| NOW()               |
+---------------------+
| 2021-06-22 11:38:48 |
+---------------------+

mysql> SELECT USER();
+----------------+
| USER()         |
+----------------+
| root@localhost |
+----------------+

mysql> use scm;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> select database();
+------------+
| database() |
+------------+
| scm        |
+------------+

mysql> CREATE DATABASE menagerie;
Query OK, 1 row affected (0.01 sec)

mysql> use menagerie;
Database changed

CREATE TABLE pet (name VARCHAR(20), owner VARCHAR(20),
       species VARCHAR(20), sex CHAR(1), birth DATE, death DATE);
       
CREATE TABLE book (name VARCHAR(100), author VARCHAR(50), format VARCHAR(20), year_publish DATE, 
       publisher VARCHAR(20), subject VARCHAR(20), description VARCHAR(200));

mysql> show tables;
+---------------------+
| Tables_in_menagerie |
+---------------------+
| book                |
+---------------------+

mysql> describe book;
+--------------+--------------+------+-----+---------+-------+
| Field        | Type         | Null | Key | Default | Extra |
+--------------+--------------+------+-----+---------+-------+
| name         | varchar(100) | YES  |     | NULL    |       |
| author       | varchar(50)  | YES  |     | NULL    |       |
| format       | varchar(20)  | YES  |     | NULL    |       |
| year_publish | date         | YES  |     | NULL    |       |
| publisher    | varchar(20)  | YES  |     | NULL    |       |
| subject      | varchar(20)  | YES  |     | NULL    |       |
| description  | varchar(200) | YES  |     | NULL    |       |
+--------------+--------------+------+-----+---------+-------+
7 rows in set (0.00 sec)

INSERT INTO pet
       VALUES ('Puffball','Diane','hamster','f','1999-03-30',NULL);

INSERT INTO book 
		VALUES ('Um Estudo em vermelho','Arthur Conan Doyle','Book','2013','Zahar','Roamance Polical','Primeira aparicao publica de Sherlock e primeiro encontro com Watson');

INSERT INTO book 
		VALUES ('The Fall of the House of Usher and Other Writtings','Edgar Allan Poe','Pocket Book','2019','Penguin','Roamance Polical','Varias contos classicos do autor');
		
INSERT INTO book 
		VALUES ('A Terra Inabitavel','David Wallace-Wells','Book','2019','Companhia das Letras','Aquecimento Global','Analise jornalistica sobre fatos e pesquisas relativos a aquecimento global');
		
INSERT INTO book 
		VALUES ('Atrofisica para Apressados','Neil de Grasse Tyson','Book','2017','Planeta','Astrofisica','Noces basicas de astrofisica');

INSERT INTO book 
		VALUES ('A Cabra Vadia, Novas Confissoes','Nelson Rodrigues','Book','2016','Nova Fronteira','Roamance Brasileiro','Nelson explica ontem o Brasil de hoje, cronicas sobre plitica, cultura e sociedade');

BINARY LOGS:

show variables like '%log%' ;

mysql> show variables like '%log%' ;
+--------------------------------------------+--------------------------------------------+
| Variable_name                              | Value                                      |
+--------------------------------------------+--------------------------------------------+
| back_log                                   | 160                                        |
| binlog_cache_size                          | 32768                                      |
| binlog_checksum                            | CRC32                                      |
| binlog_direct_non_transactional_updates    | OFF                                        |
| binlog_error_action                        | ABORT_SERVER                               |
| binlog_format                              | MIXED                                      |
| binlog_group_commit_sync_delay             | 0                                          |
| binlog_group_commit_sync_no_delay_count    | 0                                          |
| binlog_gtid_simple_recovery                | ON                                         |
| binlog_max_flush_queue_time                | 0                                          |
| binlog_order_commits                       | ON                                         |
| binlog_row_image                           | FULL                                       |
| binlog_rows_query_log_events               | OFF                                        |
| binlog_stmt_cache_size                     | 32768                                      |
| binlog_transaction_dependency_history_size | 25000                                      |
| binlog_transaction_dependency_tracking     | COMMIT_ORDER                               |
| expire_logs_days                           | 0                                          |
| general_log                                | OFF                                        |
| general_log_file                           | /data/mysql/rrpvsao01a0401.log             |
| innodb_api_enable_binlog                   | OFF                                        |
| innodb_flush_log_at_timeout                | 1                                          |
| innodb_flush_log_at_trx_commit             | 2                                          |
| innodb_locks_unsafe_for_binlog             | OFF                                        |
| innodb_log_buffer_size                     | 67108864                                   |
| innodb_log_checksums                       | ON                                         |
| innodb_log_compressed_pages                | ON                                         |
| innodb_log_file_size                       | 536870912                                  |
| innodb_log_files_in_group                  | 2                                          |
| innodb_log_group_home_dir                  | ./                                         |
| innodb_log_write_ahead_size                | 8192                                       |
| innodb_max_undo_log_size                   | 1073741824                                 |
| innodb_online_alter_log_max_size           | 134217728                                  |
| innodb_undo_log_truncate                   | OFF                                        |
| innodb_undo_logs                           | 128                                        |
| log_bin                                    | ON                                         |
| log_bin_basename                           | /data/mysql/mysql_binary_log               |
| log_bin_index                              | /data/mysql/mysql_binary_log.index         |
| log_bin_trust_function_creators            | OFF                                        |
| log_bin_use_v1_row_events                  | OFF                                        |
| log_builtin_as_identified_by_password      | OFF                                        |
| log_error                                  | stderr                                     |
| log_error_verbosity                        | 3                                          |
| log_output                                 | FILE                                       |
| log_queries_not_using_indexes              | OFF                                        |
| log_slave_updates                          | OFF                                        |
| log_slow_admin_statements                  | OFF                                        |
| log_slow_slave_statements                  | OFF                                        |
| log_statements_unsafe_for_binlog           | ON                                         |
| log_syslog                                 | OFF                                        |
| log_syslog_facility                        | daemon                                     |
| log_syslog_include_pid                     | ON                                         |
| log_syslog_tag                             |                                            |
| log_throttle_queries_not_using_indexes     | 0                                          |
| log_timestamps                             | UTC                                        |
| log_warnings                               | 2                                          |
| max_binlog_cache_size                      | 18446744073709547520                       |
| max_binlog_size                            | 1073741824                                 |
| max_binlog_stmt_cache_size                 | 18446744073709547520                       |
| max_relay_log_size                         | 0                                          |
| relay_log                                  |                                            |
| relay_log_basename                         | /data/mysql/rrpvsao01a0401-relay-bin       |
| relay_log_index                            | /data/mysql/rrpvsao01a0401-relay-bin.index |
| relay_log_info_file                        | relay-log.info                             |
| relay_log_info_repository                  | FILE                                       |
| relay_log_purge                            | ON                                         |
| relay_log_recovery                         | OFF                                        |
| relay_log_space_limit                      | 0                                          |
| slow_query_log                             | OFF                                        |
| slow_query_log_file                        | /data/mysql/rrpvsao01a0401-slow.log        |
| sql_log_bin                                | ON                                         |
| sql_log_off                                | OFF                                        |
| sync_binlog                                | 1                                          |
| sync_relay_log                             | 10000                                      |
| sync_relay_log_info                        | 10000                                      |
+--------------------------------------------+--------------------------------------------+
74 rows in set (0.00 sec)

mysql> 
mysql> quit
Bye
[root@rrpvsao01a0401 mysql]# pwd
/data/mysql
[root@rrpvsao01a0401 mysql]# ls -ltr
total 3765596
-rw-r-----. 1 mysql mysql        569 Mar 12 09:09 mysql_binary_log.000003
-rw-r-----. 1 mysql mysql        177 Mar 12 09:09 mysql_binary_log.000006
-rw-r-----. 1 mysql mysql       1742 Mar 12 09:09 mysql_binary_log.000004
-rw-r-----. 1 mysql mysql       1318 Mar 12 09:09 mysql_binary_log.000001
-rw-r-----. 1 mysql mysql       2407 Mar 12 09:09 mysql_binary_log.000005
-rw-r-----. 1 mysql mysql        177 Mar 12 09:09 mysql_binary_log.000002
-rw-r-----. 1 mysql mysql        177 Mar 12 09:13 mysql_binary_log.000007
-rw-r-----. 1 mysql mysql  649345791 Apr 20 09:06 mysql_binary_log.000008
-rw-r-----. 1 mysql mysql 1073742097 Jun 19 16:38 mysql_binary_log.000009
-rw-r-----. 1 mysql mysql  862834786 Aug  6 00:03 mysql_binary_log.000010

-rw-r-----. 1 mysql mysql  536870912 Aug 11 16:14 ib_logfile0
-rw-r-----. 1 mysql mysql   79691776 Aug 11 16:14 ibdata1
-rw-r-----. 1 mysql mysql   95523893 Aug 11 16:14 mysql_binary_log.000011
-rw-r-----. 1 mysql mysql  536870912 Aug 11 16:14 ib_logfile1


SELECT host,user,authentication_string FROM mysql.user;

Mentioning a query that can be helpful for listing database names in descending order by creation date time. This query can be helpful.

select distinct table_schema as database_name,
-- table_name,
create_time
from information_schema.tables
where 
-- create_time > adddate(current_date,INTERVAL -2 DAY)
table_schema not in('information_schema', 'mysql','performance_schema','activity_monitor','sys')
and table_type ='BASE TABLE'
-- and table_schema = 'your database name' 
order by create_time desc;

=======

PERMISSOES DE USUARIO

RRPFSAO01A6502
RRPVSAO01A0401


mysql> SELECT host,user,authentication_string FROM mysql.user;
+-----------------------------+------------------+-------------------------------------------+
| host                        | user             | authentication_string                     |
+-----------------------------+------------------+-------------------------------------------+
| localhost                   | root             | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| localhost                   | mysql.session    | *THISISNOTAVALIDPASSWORDTHATCANBEUSEDHERE |
| localhost                   | mysql.sys        | *THISISNOTAVALIDPASSWORDTHATCANBEUSEDHERE |
| %                           | amon_user        | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| rrpfsao01a6502.record.cloud | amon_user        | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| %                           | activity_monitor | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| rrpfsao01a6502.record.cloud | activity_monitor | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| %                           | report_manager   | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| rrpfsao01a6502.record.cloud | report_manager   | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| %                           | hive             | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| %                           | hue              | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| %                           | oozie            | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| %                           | smm              | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| %                           | veeam_bkp        | *D81778CA0A1E3CC6DDFB8020F8F3D3EDF8640628 |
| %                           | IBMITMSE         | *208B5899B048F4796DDDFB97477FCA42BE53DFD9 |
+-----------------------------+------------------+-------------------------------------------+
15 rows in set (0.07 sec)


GRANT ALL PRIVILEGES ON `veeam_bkp`.* TO 'veeam_bkp'@'%'

erro backup:

9/23/2021 3:02:17 AM :: [MySQL] Error 2002 (HY000): Can’t connect to local MySQL server through socket ‘/var/lib/mysql/mysql.sock’ (2)

The following command creates a backup file in the directory d:\Temp\EnterpriseBackup.

mysqlbackup --user=root --password --backup-image=backup.mbi \ --backup-dir=D:\Temp\EnterpriseBackup backup-to-image

–backup-image  – Backup file name

–backup-dir –  Directory in which backup will be created

/* To restore data from backups, you will need to perform preparatory steps, namely to stop the MySQL Service and clear the MySQL Server data directory. 
Then you need to use the same utility to restore data but with different parameters. */

mysqlbackup --datadir=C:\ProgramData\MySQL\MySQL Server 8.0\Data\ --backup-image=backup.mbi --backup-dir=D:\Temp\EnterpriseBackup copy-back-and-apply-log

# Information about data files can be retrieved through the database connection.
# Specify connection options on the command line.

mysqlbackup --user=dba --password --port=3306 --with-timestamp --backup-dir=/export/backups backup
  
  
mysqlbackup --user=root --password --port=3306 --with-timestamp --backup-dir=/data/export/mysqlbackups backup

https://phoenixnap.com/kb/how-to-backup-restore-a-mysql-database

To back up your MySQL database, the general syntax is:

sudo mysqldump -u [user] -p [database_name] > [filename].sql

Replace [user] with your username and password (if needed).

The [database_name] is the path and filename of the database.

The > command specifies the output.

[filename] is the path and filename you want to save the dump file as.

Other examples:

To back up of an entire Database Management System:

mysqldump --all-databases --single-transaction --quick --lock-tables=false > /data/export/mysqlbackups/full-backup-$(date +%F).sql -u root -p YMMP-2VZzqqscBUj@xLh

To include more than one database in the backup dump file:

sudo mysqldump -u [user] -p [database_1] [database_2] [database_etc] > [filename].sql



RODOU COM SUCESSO DESSA FORMA:

mysqldump --all-databases > /data/export/mysqlbackups/mysql_all_databases.sql -u root -p

For point-in-time recovery (also known as “roll-forward,” when you need to restore an old backup and replay the changes that happened since that backup), 
it is often useful to rotate the binary log (see Section 5.4.4, “The Binary Log”) or at least know the binary log coordinates to which the dump corresponds:


mysqldump --all-databases --master-data=2 > /data/export/mysqlbackups/mysql_all_databases_master.sql -u root -p

To load the dump file back into the server:

mysql db_name < backup-file.sql

Another way to reload the dump file:

mysql -e "source /path-to-backup/backup-file.sql" db_name

mysqldump is also very useful for populating databases by copying data from one MySQL server to another:

mysqldump --opt db_name | mysql --host=remote_host -C db_name



"mysql> SELECT host,user,authentication_string FROM mysql.user;
+-----------------------------+------------------+-------------------------------------------+
| host                        | user             | authentication_string                     |
+-----------------------------+------------------+-------------------------------------------+
| localhost                   | root             | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| localhost                   | mysql.session    | *THISISNOTAVALIDPASSWORDTHATCANBEUSEDHERE |
| localhost                   | mysql.sys        | *THISISNOTAVALIDPASSWORDTHATCANBEUSEDHERE |
| %                           | amon_user        | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| rrpfsao01a6502.record.cloud | amon_user        | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| %                           | activity_monitor | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| rrpfsao01a6502.record.cloud | activity_monitor | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| %                           | report_manager   | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| rrpfsao01a6502.record.cloud | report_manager   | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| %                           | hive             | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| %                           | hue              | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| %                           | oozie            | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| %                           | smm              | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| %                           | veeam_bkp        | *D81778CA0A1E3CC6DDFB8020F8F3D3EDF8640628 |
| %                           | IBMITMSE         | *208B5899B048F4796DDDFB97477FCA42BE53DFD9 |
+-----------------------------+------------------+-------------------------------------------+
15 rows in set (0.07 sec)"

#log_bin should be on a disk with enough free space.
#Replace '/var/lib/mysql/mysql_binary_log' with an appropriate path for your
#system and chown the specified folder to the mysql user.
log_bin=/data/mysql/mysql_binary_log

LOGS

mysql> set global general_log = 1;
mysql> show variables where variable_name = 'general_log';
mysql> show variables where variable_name like '%log%';


LOG ROTATE

[root@rrpvsao01a0401 ~]# ls -al  /usr/share/mysql/mysql-log-rotate 
-rw-r--r--. 1 root root 844 Dec 10  2020 /usr/share/mysql/mysql-log-rotate
[root@rrpvsao01a0401 ~]# ls -al /etc/logrotate.d/mysql
-rw-r--r--. 1 root root 972 Dec 10  2020 /etc/logrotate.d/mysql

/etc/logrotate.d/mysql:

# The log file name and location can be set in
# /etc/my.cnf by setting the "log-error" option
# in [mysqld]  section as follows:
#
# [mysqld]
# log-error=/var/log/mysqld.log
#
# For the mysqladmin commands below to work, root account
# password is required. Use mysql_config_editor(1) to store
# authentication credentials in the encrypted login path file
# ~/.mylogin.cnf
#
# Example usage:
#

mysql_config_editor set --login-path=client --user=root --host=localhost --password

#
# When these actions has been done, un-comment the following to
# enable rotation of mysqld's log error.
#

#/var/log/mysqld.log {
#        create 640 mysql mysql
#        notifempty
#        daily
#        rotate 5
#        missingok
#        compress
#    postrotate
#       # just if mysqld is really running
#       if test -x /usr/bin/mysqladmin && \
#          /usr/bin/mysqladmin ping &>/dev/null
#       then
#          /usr/bin/mysqladmin flush-logs
#       fi
#    endscript
#}
























