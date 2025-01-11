Check if any NOLOGGING activity occurred on the primary database in the last day

select file#, name, unrecoverable_change#, unrecoverable_time
 from v$datafile
 where unrecoverable_time > (sysdate - 1);
 
Good health = no rows returned

If the query returns rows, then the standby database is vulnerable, and the files listed in the output must be refreshed on the standby.
