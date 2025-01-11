
select t.sql_id,
    t.sql_text,
    s.executions_total,
    s.elapsed_time_total
from DBA_HIST_SQLSTAT s, DBA_HIST_SQLTEXT t
where t.sql_id=s.sql_id 
and t.sql_id = '&sql_id';
