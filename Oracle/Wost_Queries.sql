To find the worst queries:

select b.username username, a.disk_reads reads,
a.executions exec, a.disk_reads /decode
(a.executions, 0, 1,a.executions) rds_exec_ratio,
a.sql_text Statement
from V$sqlarea a, dba_users b
where a.parsing_user_id = b.user_id
and a.disk_reads > 100000
order by a.disk_reads desc;

Selecting from the V$SQL View to Find the Worst Queries
Querying V$SQL allows you to see the shared SQL area statements individually versus grouped
together (as V$SQLAREA does). Here is a faster query to get the top statements from V$SQL (this
query can also access V$SQLAREA by only changing the view name):

select *
from (select address,
rank() over ( order by buffer_gets desc ) as rank_bufgets,
to_char(100 * ratio_to_report(buffer_gets) over (), '999.99') pct_bufgets
from v$sql )
where rank_bufgets < 11;

You can alternatively select SQL_TEXT instead of ADDRESS if you want to see the SQL:

COL SQL_TEXT FOR A50
select *
from (select sql_text,
rank() over ( order by buffer_gets desc ) as rank_bufgets,
to_char(100 * ratio_to_report(buffer_gets) over (), '999.99') pct_bufgets
from v$sql )
where rank_bufgets < 11;

Selecting from the DBA_HIST_SQLSTAT
View to Find the Worst Queries
SQL statements that have exceeded predefined thresholds are kept in the AWR for a predefined
time (seven days, by default). You can query the DBA_HIST_SQLSTAT view to find the worst
queries. The following is the equivalent statement to the V$SQLAREA query earlier in this chapter.
To query DBA_HIST_SQLSTAT view to find the worst queries:

select snap_id, disk_reads_delta reads_delta,
executions_delta exec_delta, disk_reads_delta /decode
(executions_delta, 0, 1,executions_delta) rds_exec_ratio,
sql_id
from dba_hist_sqlstat
where disk_reads_delta > 100000
order by disk_reads_delta desc;

