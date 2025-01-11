
select t.sql_id,
    t.sql_text,
    s.executions_total,
    s.elapsed_time_total
from DBA_HIST_SQLSTAT s, DBA_HIST_SQLTEXT t
where t.sql_id=s.sql_id 
and t.sql_id = '&sql_id';

select 
a.instance_number inst_id, a.snap_id,a.plan_hash_value, 
to_char(begin_interval_time,'dd-mon-yy hh24:mi') btime, abs(extract(minute 
from (end_interval_time-begin_interval_time)) + extract(hour from (end_interval_time-begin_interval_time))*60 
+ extract(day from (end_interval_time-begin_interval_time))*24*60) minutes,
executions_delta executions, round(ELAPSED_TIME_delta/1000000/greatest(executions_delta,1),4) "avg duration (sec)" 
from dba_hist_SQLSTAT a, dba_hist_snapshot b
where sql_id='129fw6qs88wxk' and a.snap_id=b.snap_id
and a.instance_number=b.instance_number
order by snap_id desc, a.instance_number;

select 
   s.begin_interval_time, 
   s.end_interval_time , 
   q.snap_id, 
   q.dbid,    
   q.sql_id, 
   q.plan_hash_value, 
   q.optimizer_cost, 
   q.optimizer_mode 
from 
   dba_hist_sqlstat q, 
   dba_hist_snapshot s
where 
   q.sql_id = '129fw6qs88wxk'
and q.snap_id = s.snap_id
and s.begin_interval_time between sysdate-7 and sysdate
order by s.snap_id desc;