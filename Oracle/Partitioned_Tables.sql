
http://www.dba-oracle.com/t_partition_statistics.htm

Dr. Tim Hall offers these examples of partition wise execution of dbms_stats:

EXEC DBMS_STATS.set_table_prefs('MY_SCHEMA', 'MY_TABLE', 'INCREMENTAL', 'TRUE');

-- Resetting to defaults values if you've changed the global/database preferences.
EXEC DBMS_STATS.set_table_prefs('MY_SCHEMA', 'MY_TABLE', 'GRANULARITY', 'AUTO');
EXEC DBMS_STATS.set_table_prefs('MY_SCHEMA', 'MY_TABLE', 'ESTIMATE_PERCENT', DBMS_STATS.AUTO_SAMPLE_SIZE);

The stats will now be gathered incrementally for the partitioned table by issuing the basic gather command.

-- Using default preferences.
EXEC DBMS_STATS.gather_table_stats('MY_SCHEMA', 'MY_TABLE');

-- Overriding preferences.
EXEC DBMS_STATS.gather_table_stats('MY_SCHEMA', 'MY_TABLE', granularity => 'AUTO', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);