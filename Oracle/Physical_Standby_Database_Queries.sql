-----
-- Determine if there is a transport lag
-----

select name,value,time_computed,datum_time
 from v$dataguard_stats
 where name='transport lag'
 and value > '+00 00:01:00';
 
-- Good health = no rows returned

-- If no rows are returned, then this implies that there is no transport lag

-----
-- Determine if there is an apply lag
-----

select name,value,time_computed,datum_time
 from v$dataguard_stats
 where name='apply lag'
 and value > '+00 00:01:00';
 
-- Good health = no rows returned

-- If no rows are returned, then this implies that there is no apply lag

-----
--Standby data file check (offline files or files that are not accessible)
-----

select *
 from v$datafile_header
 where status ='OFFLINE'
 or ERROR is not null;
 
-- Good health = no rows returned

-- Any rows returned list the files that have I/O or recovery issues

-----
-- Verify that the Media Recovery Process is currently running
-----

select *
 from v$managed_standby
 where process like 'MRP%';

--Good health = rows returned

-- If no rows are returned, then the MRP process is not running

-----
-- Assess whether any severe Data Guard event occurred in the last day
-----

select *
 from v$dataguard_status
 where severity in ('Error','Fatal')
 and timestamp > (sysdate -1);

-- Good health = no rows returned

-- If the query returns rows, then raise an alert with the returned output