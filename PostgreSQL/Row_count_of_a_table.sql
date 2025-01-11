
Exact count

Slow for big tables. With concurrent write operations, it may be outdated the moment you get it.

SELECT count(*) AS exact_count FROM zabbix.history;

Estimate - Extremely fast:

zabbix=# SELECT reltuples AS estimate FROM pg_class where relname = 'history';
   estimate    
---------------
 2.3667034e+09
(1 row)

Typically, the estimate is very close. How close, depends on whether ANALYZE or VACUUM are run enough - where "enough" is defined by the level of write activity to your table.

Safer estimate

The above ignores the possibility of multiple tables with the same name in one database - in different schemas.

To account for that:

SELECT c.reltuples::bigint AS estimate
FROM   pg_class c
JOIN   pg_namespace n ON n.oid = c.relnamespace
WHERE  c.relname = 'hosts'
AND    n.nspname = 'zabbix';

The cast to bigint formats the real number nicely, especially for big counts - Better estimate

SELECT reltuples::bigint AS estimate
FROM   pg_class
WHERE  oid = 'hosts'::regclass;



