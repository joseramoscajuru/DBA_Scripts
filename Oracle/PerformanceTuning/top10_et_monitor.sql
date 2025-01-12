
----DESCRIPTION
	--Lista as top 10 query por ElapseTime do SQL_MONITOR 
	
--
set lines 1000 pages 300
col "SQL Texto" for a60

select * from  (select 	SQL_ID, round(avg(ELAPSED_TIME)/1000000,1) "Media ET(s)", count(1) "EXECS",
						round(sum(ELAPSED_TIME)/1000000,1) "Total ET(s)" ,substr(SQL_TEXT,1,200) "SQL Texto"
				from v$sql_monitor
				group by SQL_ID,SQL_TEXT
				order by 2 DESC)
where EXECS > 1 and 
rownum < 10;
