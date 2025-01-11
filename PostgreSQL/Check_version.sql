
postgres=# SELECT version();
                                                 version                                                 
---------------------------------------------------------------------------------------------------------
 PostgreSQL 13.5 on x86_64-pc-linux-gnu, compiled by gcc (GCC) 4.8.5 20150623 (Red Hat 4.8.5-44), 64-bit
(1 row)

postgres=# SHOW server_version;
 server_version 
----------------
 13.5
(1 row)

[postgres@lsdbzab01 ~]$ psql --version
psql (PostgreSQL) 13.5

[postgres@lsdbzab01 ~]$ psql -V
psql (PostgreSQL) 13.5

