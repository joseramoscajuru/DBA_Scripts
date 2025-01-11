
----TOP 10 intruções SQL por elapse timeset 

set pagesize 200
set linesize 1000
col elapsed_time for 999999999999999
col cpu_time     for 999999999999999
col sql_text for a80
select 
username,executions,rows_processed,round(cpu_time) "cpu_time(s)",round(elapsed_time) "elapsed_time(s)",
round(elapsed_time/executions,6) "et_por_exec(s)",sql_id,substr(sql_text,1,80) sql_text
from   (select b.username ,a.executions ,a.rows_processed ,cpu_time/1000000 cpu_time,elapsed_time/1000000 elapsed_time,
               a.sql_id,substr(sql_text,1,80) sql_text
               from sys.v_$sqlarea a,sys.all_users b
               where 
					a.parsing_user_id=b.user_id and 
					b.username not in ('SYS','SYSTEM','SYSMAN','ORACLE_OCM','DBSNMP','MDSYS','XDB','EXFSYS')
		order by 5 desc)
where rownum < 21;

=== ORDENADO POR CPU

set pagesize 200
set linesize 1000
col elapsed_time for 999999999999999
col cpu_time     for 999999999999999
col sql_text for a80
select 
username,executions,rows_processed,round(cpu_time) "cpu_time(s)",round(elapsed_time) "elapsed_time(s)",
-- round(elapsed_time/executions,2) "et_por_exec(s)",
sql_id,substr(sql_text,1,80) sql_text
from   (select b.username ,a.executions ,a.rows_processed ,
        -- cpu_time/1000000 cpu_time,elapsed_time/1000000 elapsed_time,
         cpu_time, elapsed_time,
               a.sql_id,substr(sql_text,1,80) sql_text
               from sys.v_$sqlarea a,sys.all_users b
               where 
					a.parsing_user_id=b.user_id and 
					b.username not in ('SYS','SYSTEM','SYSMAN','ORACLE_OCM','DBSNMP','MDSYS','XDB','EXFSYS')
		order by 4 desc)
where rownum < 31;

select * from (
SELECT s.sid,
       s.serial#,
       s.username,
       s.machine,
       s.program,
       s.status,
       s.last_call_et,
       q.sql_id,
       q.sql_text
FROM v$session s
LEFT JOIN v$sql q ON s.sql_id = q.sql_id
WHERE s.type != 'BACKGROUND'
and s.status='ACTIVE'
and s.username not in ('SYS','SYSTEM')
AND s.username is not null
ORDER BY q.cpu_time DESC)
where rownum < 11;
