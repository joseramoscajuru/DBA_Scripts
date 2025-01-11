
----TOP 10 intruções SQL por Buffer Gets

set pagesize 500
set linesize 1000
set tab off;
col elapsed_time for 999999999999999
col cpu_time     for 999999999999999
col sql_text for a60
select 	username,executions,rows_processed,round(cpu_time) "cpu_time(s)",buffer_gets,round(buffer_gets/executions) bg_por_exec,
		sql_id,substr(sql_text,1,60) sql_text
from   (select 	b.username ,a.executions ,a.rows_processed ,(cpu_time/1000000) cpu_time,
				a.buffer_gets buffer_gets,a.sql_id,substr(sql_text,1,60) sql_text
		from sys.v_$sqlarea a,sys.all_users b
		where a.parsing_user_id=b.user_id and 
		b.username not in ('SYS','SYSTEM','SYSMAN','ORACLE_OCM','DBSNMP','MDSYS','XDB','EXFSYS')
		order by 5 desc)
where rownum < 11;

----DESCRIPTION
--Lista as top 10 query por BUFFER_GETS do SQL_MONITOR 
set pages 300
set lines 1000

col "SQL Texto" for a60

select * from (select SQL_ID, round(avg(BUFFER_GETS)) "Media BufGets", count(1) "EXECS",
				round(sum(BUFFER_GETS)) "Total BufGets" ,substr(SQL_TEXT,1,60) "SQL Texto"
				from v$sql_monitor
				group by SQL_ID,SQL_TEXT
				order by 2 DESC)
where EXECS > 1
and rownum < 11;