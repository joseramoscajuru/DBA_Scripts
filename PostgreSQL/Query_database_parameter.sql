
To see all settings:

SHOW ALL;

SELECT *
FROM   pg_settings
WHERE  name = 'seq_page_cost';

SELECT current_setting('max_parallel_maintenance_workers');
