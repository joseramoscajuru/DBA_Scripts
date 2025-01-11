PostgreSQL Log Location

Debian-based system:e /var/log/postgresql/postgresql-x.x.main. log. X.x.
Red Hat-based system: /var/lib/pgsql/data/pg_log.
Windows: C:\Program Files\PostgreSQL\9.3\data\pg_log

postgres=# SELECT  pg_current_logfile();
                   pg_current_logfile                   
--------------------------------------------------------
 /backup/zabbix/pg_log/postgresql-2024-01-21_000000.log
(1 row)



Verify that the logging collector is started:

SHOW logging_collector;

If not, the location of the log depends on how PostgreSQL was started.

If yes, the log will be in log_directory:

SHOW log_directory;