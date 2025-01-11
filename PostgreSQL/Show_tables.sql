
zabbix=# \dt
                  List of relations
 Schema |            Name            | Type  | Owner  
--------+----------------------------+-------+--------
 public | acknowledges               | table | zabbix
 public | actions                    | table | zabbix
 public | alerts                     | table | zabbix
 ...
 ...
 public | usrgrp                     | table | zabbix
 public | valuemaps                  | table | zabbix
 public | widget                     | table | zabbix
 public | widget_field               | table | zabbix
(166 rows)

-- describe table "users"

zabbix=# \dt users
        List of relations
 Schema | Name  | Type  | Owner  
--------+-------+-------+--------
 public | users | table | zabbix
(1 row)

-- describe table "users" with details

zabbix=# \dt+ users
                          List of relations
 Schema | Name  | Type  | Owner  | Persistence | Size  | Description 
--------+-------+-------+--------+-------------+-------+-------------
 public | users | table | zabbix | permanent   | 56 kB | 


If you’re using any other utility than psql, then these SQLs are probably the simplest to show tables in PostgreSQL:


timetable=> SELECT oid :: regclass AS table_name FROM pg_class WHERE relkind = 'r';