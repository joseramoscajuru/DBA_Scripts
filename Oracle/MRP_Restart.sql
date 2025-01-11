
set lines 1000 pages 200
SELECT NAME, VALUE FROM V$DATAGUARD_STATS;
select message from v$DATAGUARD_STATUS;
select process, status, sequence# from v$managed_standby;

select process, status, sequence# 
from v$managed_standby 
where process in ('RFS','MRP0') 
order by 1 desc;

select * from v$managed_standby where process in ('RFS','MRP0') order by 1 desc;

select process, status, sequence# 
from v$managed_standby 
order by 1 desc;

select max(sequence#) from  v$archived_log where applied='YES';

SELECT RECOVERY_MODE FROM V$ARCHIVE_DEST_STATUS;

SEM RESTART DO BANCO:

ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;

ALTER DATABASE RECOVER MANAGED STANDBY DATABASE DISCONNECT FROM SESSION;

COM RESTART DO BANCO:
======================

Data Guard Shutdown Sequence

Stop log apply service or MRP and shutdown the standby

ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;

SQL> SHUT IMMEDIATE;

Data Guard Startup Sequence

Startup standby and enable log apply service or MRP

SQL> startup nomount;

SQL> alter database mount standby database;

ALTER DATABASE RECOVER MANAGED STANDBY DATABASE DISCONNECT FROM SESSION;

set lines 1000 pages 100
col dest_name format a30
col type format a15
col destination format a20
col error format a20
select dest_id,dest_name, type,ARCHIVED_SEQ# ,APPLIED_SEQ#, DESTINATION, status, error,
		SYNCHRONIZATION_STATUS, GAP_STATUS
 from gv$archive_dest_status
 where dest_name in ('LOG_ARCHIVE_DEST_1','LOG_ARCHIVE_DEST_2','LOG_ARCHIVE_DEST_3');