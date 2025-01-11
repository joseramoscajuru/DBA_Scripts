I use the below query to find out in day what is the max limit i reach in terms of process and sessions.

col metric_unit for a30
set pagesize 100
Select trunc(end_time),max(maxval)  as Maximum_Value,metric_unit
from dba_hist_sysmetric_summary 
where metric_id  in ( 2118,2119)  group by trunc(end_time),metric_unit order by 1;

###########################################################################################

####Mostrar resources do DB
select * from v$resource_limit;

set line 400
col instance_name for a20
col host_name for a20
col RESOURCE_NAME format a20
col INITIAL_ALLOCATION format a20
col CURRENT_UTILIZATION format a20
col MAX_UTILIZATION format a20
col LIMIT_VALUE format a12
SELECT gi.instance_name, gi.host_name, 
grl.RESOURCE_NAME, grl.CURRENT_UTILIZATION || '  (' || ROUND((grl.current_utilization/grl.limit_value) * 100,2) || '%)' as CURRENT_UTILIZATION, 
grl.MAX_UTILIZATION || '  (' || ROUND((grl.MAX_UTILIZATION/grl.limit_value) * 100,2) || '%)' as MAX_UTILIZATION, 
grl.INITIAL_ALLOCATION, grl.LIMIT_VALUE
FROM gv$resource_limit grl, gv$instance gi
WHERE grl.inst_id = gi.inst_id
AND grl.resource_name in  ('sessions','processes') 
ORDER BY gi.inst_id ;