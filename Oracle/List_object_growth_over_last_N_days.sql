List object growth over last N days, sorted by growth desc 

set feedback on 
select * from (select c.TABLESPACE_NAME,c.segment_name “Object Name”,b.object_type, 
sum(space_used_delta) / 1024 / 1024 “Growth (MB)” 
from dba_hist_snapshot sn, 
dba_hist_seg_stat a, 
dba_objects b, 
dba_segments c 
where begin_interval_time > trunc(sysdate) – &days_back 
and sn.snap_id = a.snap_id 
and b.object_id = a.obj# 
and b.owner = c.owner 
and b.object_name = c.segment_name 
and c.owner =’SIEBEL’ 
group by c.TABLESPACE_NAME,c.segment_name,b.object_type) 
order by 3 asc;

