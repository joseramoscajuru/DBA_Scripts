set lines 200
col instance_name for a50
select * from
( select STARTUP_TIME 
FROM dba_hist_database_instance 
ORDER BY startup_time DESC)
WHERE rownum < 20;

set lines 200
col host_name for a20
col instance_name for a15
SELECT host_name, instance_name,
TO_CHAR(startup_time, 'DD-MM-YYYY HH24:MI:SS') startup_time,
FLOOR(sysdate-startup_time) days
FROM sys.v_$instance;

set lines 200
col instance_name for a50
select * from
( select STARTUP_TIME FROM dba_hist_database_instance ORDER BY startup_time DESC)
WHERE rownum < 10;