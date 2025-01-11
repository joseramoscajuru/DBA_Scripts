Changing the Number or Size of InnoDB Redo Log Files

To change the number or the size of your InnoDB redo log files, perform the following steps:

1) Stop the MySQL server and make sure that it shuts down without errors. 
   
2) Edit my.cnf to change the log file configuration. 
 
To change the log file size, configure innodb_log_file_size

mysql> 	show variables like '%innodb_log_file_size%';
+----------------------+-----------+
| Variable_name        | Value     |
+----------------------+-----------+
| innodb_log_file_size | 536870912 |
+----------------------+-----------+

To increase the number of log files, configure innodb_log_files_in_group. 


mysql> show variables like '%innodb_log_files_in_group%';
+---------------------------+-------+
| Variable_name             | Value |
+---------------------------+-------+
| innodb_log_files_in_group | 2     |
+---------------------------+-------+


3) Start the MySQL server again. 


SET GLOBAL innodb_redo_log_archive_dirs = "redolog-archiving-for-backup:/data/mysql/redologs-arch/";

mysql> SET GLOBAL innodb_redo_log_archive_dirs = "redolog-archiving-for-backup:/data/mysql/redologs-arch/";
ERROR 1193 (HY000): Unknown system variable 'innodb_redo_log_archive_dirs'

