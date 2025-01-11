

ARQUIVO DE CONFIGURACAO

/etc/my.cnf

[mysqld]
datadir=/data/mysql
socket=/data/mysql/mysql.sock
#datadir=/var/lib/mysql
#socket=/var/lib/mysql/mysql.sock
transaction-isolation = READ-COMMITTED

# InnoDB settings
innodb_file_per_table = 1
innodb_flush_log_at_trx_commit  = 2
innodb_log_buffer_size = 64M
innodb_buffer_pool_size = 4G
innodb_thread_concurrency = 8
innodb_flush_method = O_DIRECT
innodb_log_file_size = 512M

[client]
port=3306
socket=/data/mysql/mysql.sock

[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid

sql_mode=STRICT_ALL_TABLES

===================================