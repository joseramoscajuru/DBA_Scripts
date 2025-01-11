
/data/mysql

/var/lib/mysql

/usr/lib64/mysql

/usr/bin/mysql

/usr/share/mysql

/etc/logrotate.d/mysql


CONFIGURATION FILE:

The mySql file can be found in multiple default locations and under various names. e.g.

etc/my.cnf,

/etc/mysql/my.cnf,

/usr/etc/my.cnf,

CURRENT LOCATION: 

/etc/my.cnf

[mysqld_safe]
log-error=/var/log/mysqld.log


[redo logs]

/data/mysql/ib_logfile0
/data/mysql/ib_logfile1
