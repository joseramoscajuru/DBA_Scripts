
Detect gaps on the standby database

select sysdate,database_mode,recovery_mode, gap_status
 from v$archive_dest_status
 where type='PHYSICAL'
 and gap_status !='NO GAP'; 
Good health = no rows returned

If the query returns rows, then theres an existing gap between the primary and the standby database, 
and you must run the same query on the standby database.

If the output from the primary and standby is identical, then no action is required.

If the output on the standby does not match the output from the primary, then the datafile 
on the standby should be refreshed.

