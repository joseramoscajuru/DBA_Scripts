######## Lista o usage de todas as tablespaces ############
set pages 999
col tablespace_name format a40
col "size MB" format 999,999,999
col "free MB" format 99,999,999
col "% Used" format 999
select 	tsu.tablespace_name, ceil(tsu.used_mb) "size MB"
,	decode(ceil(tsf.free_mb), NULL,0,ceil(tsf.free_mb)) "free MB"
,	decode(100 - ceil(tsf.free_mb/tsu.used_mb*100), NULL, 100,
               100 - ceil(tsf.free_mb/tsu.used_mb*100)) "% used"
from	(select tablespace_name, sum(bytes)/1024/1024 used_mb
	from 	dba_data_files group by tablespace_name union all
	select 	tablespace_name || '  **TEMP**'
	,	sum(bytes)/1024/1024 used_mb
	from 	dba_temp_files group by tablespace_name) tsu
,	(select tablespace_name, sum(bytes)/1024/1024 free_mb
	from 	dba_free_space group by tablespace_name) tsf
where	tsu.tablespace_name = tsf.tablespace_name (+) 
order by 4
/

set pages 999
col tablespace_name format a40
col "size MB" format 999,999,999
col "free MB" format 99,999,999
col "% Used" format 999
select 	tsu.tablespace_name, ceil(tsu.used_mb) "size MB"
,	decode(ceil(tsf.free_mb), NULL,0,ceil(tsf.free_mb)) "free MB"
,	decode(100 - ceil(tsf.free_mb/tsu.used_mb*100), NULL, 100,
               100 - ceil(tsf.free_mb/tsu.used_mb*100)) "% used"
from	(select tablespace_name, sum(bytes)/1024/1024/1024 used_mb
	from 	dba_data_files group by tablespace_name union all
	select 	tablespace_name || '  **TEMP**'
	,	sum(bytes)/1024/1024/1024 used_mb
	from 	dba_temp_files group by tablespace_name) tsu
,	(select tablespace_name, sum(bytes)/1024/1024/1024 free_mb
	from 	dba_free_space group by tablespace_name) tsf
where	tsu.tablespace_name = tsf.tablespace_name (+) 
order by 4
/


set pages 999
col tablespace_name format a40
col "size MB" format 999,999,999
col "free MB" format 99,999,999
col "% Used" format 999
select 	tsu.tablespace_name, ceil(tsu.used_mb) "size MB"
,	decode(ceil(tsf.free_mb), NULL,0,ceil(tsf.free_mb)) "free MB"
,	decode(100 - ceil(tsf.free_mb/tsu.used_mb*100), NULL, 100,
               100 - ceil(tsf.free_mb/tsu.used_mb*100)) "% used"
from	(select tablespace_name, sum(bytes)/1024/1024 used_mb
	from 	dba_data_files group by tablespace_name union all
	select 	tablespace_name || '  **TEMP**'
	,	sum(bytes)/1024/1024 used_mb
	from 	dba_temp_files group by tablespace_name) tsu
,	(select tablespace_name, sum(bytes)/1024/1024 free_mb
	from 	dba_free_space group by tablespace_name) tsf
where	tsu.tablespace_name = tsf.tablespace_name (+) 
        and tsu.tablespace_name not like '%UNDO%'
        and tsu.tablespace_name not like '%TEMP%'
order by 4
/

set lines 1000
set pages 1000
col instance_name format a20
col host_name format a30
col "Startup time" format a20
col database_status format a20
col status format a10
select instance_name, host_name, status, database_status, to_char(startup_time, 'HH24:MI DD-MON-YY') "Startup time" from gv$instance;

select to_char(sysdate,'dd-mon-yyyy hh24:mi:ss') from dual;




