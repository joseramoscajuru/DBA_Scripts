To check RMAN restore progress in Oracle Database, you can use the following query: 

set pages 100
set lines 1000
col sid format 999999
col serial format 999999
col filename format a80
col status format a20
select 	sid,
		serial,
		filename,
		status,
		bytes/total_bytes*100 "Completed",
		EFFECTIVE_BYTES_PER_SECOND/1024/1024 "MB/S" 
from V$BACKUP_ASYNC_IO 
where type = 'OUTPUT' 
order by status;

set line 190 pages 190
column FILENAME format a70
select 	sid,
		serial,
		filename,
		status,
		bytes/total_bytes*100 "Completed",
		EFFECTIVE_BYTES_PER_SECOND/1024/1024 "MB/S" 
from	V$BACKUP_ASYNC_IO 
where type = 'OUTPUT' 
and bytes <> 0 
order by status;