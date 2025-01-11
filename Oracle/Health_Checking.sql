	- Healthcheck.

DBA performed a health check in the database and no errors nor abnormal behavior was found. 
See below evidences:

CPUperformance is good

no rows selected

No locks or any alert log errors
No locks, blocking session or any alert log errors.

Ticket will be routed to Network for investigation.

===============================================================
select * from  V$DATABASE_BLOCK_CORRUPTION;

SELECT FILE#, STATUS,ERROR, RECOVER, TABLESPACE_NAME, NAME  FROM   V$DATAFILE_HEADER  WHERE  RECOVER = 'YES'  ;
select distinct recover from v$datafile_header;
alter system switch logfile;
alter system checkpoint;

sqlplus teste/tests@
LOCKS:
SELECT DECODE(request,0,'Holder: ','Waiter: ')||sid sess,
id1, id2, lmode, request, type
FROM V$LOCK
WHERE (id1, id2, type) IN
(SELECT id1, id2, type FROM V$LOCK WHERE request>0)
ORDER BY id1, request;


there is no blocking session anymore 

SQL> select s1.username || '@' || s1.machine 
     || ' ( SID=' || s1.sid || ' )  is blocking ' 
     || s2.username || '@' || s2.machine || ' ( SID=' || s2.sid || ' ) ' AS blocking_status 
     from gv$lock l1, gv$session s1, gv$lock l2, gv$session s2 
     where s1.sid=l1.sid and s2.sid=l2.sid 
     and l1.BLOCK=1 and l2.request > 0 
     and l1.id1 = l2.id1 
     and l2.id2 = l2.id2; 


#############SCRIPT##########################
# ver se esta open
select HOST_NAME, INSTANCE_NAME, to_char(startup_time, 'mm/dd/yyyy hh24:mi:ss'), STATUS from v$instance;

/*
STATUS VARCHAR2(12) Status of the instance:
STARTED - After STARTUP NOMOUNT
MOUNTED - After STARTUP MOUNT or ALTER DATABASE CLOSE
OPEN - After STARTUP or ALTER DATABASE OPEN
OPEN MIGRATE - After ALTER DATABASE OPEN { UPGRADE | DOWNGRADE }
*/

set lines 60
set heading oFF
col host_name form a40 heading "Host" newline
col instance_name form a40 heading "Instance" newline
col version form a40 heading "Version" newline
col status form a40 heading "Status" newline
col stime form a60 heading "Database Started At" newline
col uptime form a100 heading "Uptime" newline

select 'Server Name...........: ' || host_name, 
'Instance Name.........: ' || instance_name,
'Database Version......: ' || version,
'Database Status.......: ' || decode(status,'STARTED','Database STARTED but not OPEN',
decode(status,'MOUNTED','Database MOUNTED but not OPEN'),
decode(status,'OPEN MIGRATE','Database OPEN to MIGRATE'),
'Database OPEN') status,
'Database Startup......: ' || to_char(startup_time,'DD/MM/YYYY HH24:MI:SS') stime,
'Uptime................: ' || floor(sysdate - startup_time) || ' day ' ||
trunc( 24*((sysdate-startup_time) - 
trunc(sysdate-startup_time))) || ' hour ' ||
mod(trunc(1440*((sysdate-startup_time) - 
trunc(sysdate-startup_time))), 60) ||' minutes ' ||
mod(trunc(86400*((sysdate-startup_time) - 
trunc(sysdate-startup_time))), 60) ||' seconds' uptime
from v$instance
/
############################################
ps -ef |grep pmon
sqlplus "/ as sysdba"
===============================================================

col object_name format a40
col comp_name format a40
set lines 120

spool check_list.log

select * from v$instance;
select * from v$database;
select distinct status,error from v$datafile_header;
select distinct fuzzy from v$datafile_header;
select distinct recover from v$datafile_header;
select distinct status from v$datafile;
select distinct enabled from v$datafile;
select distinct status from dba_data_files;
select distinct status from dba_tablespaces;
select distinct status from v$backup;
select distinct status from v$logfile;
select distinct status from v$tempfile;
show parameter dump
alter system switch logfile;
alter system checkpoint;
select count(*) from dba_objects where status<>'VALID';
select owner,object_name,object_type,status from dba_objects where status<>'VALID';
select comp_name,version,status from dba_registry;

spool off

===============================================================

verificar o listener
lsnrctl status <listener>

