
--It report daily growth for all tablespaces.
with ts_history as (
select * from (
select v.name
, v.ts#
, s.instance_number
, h.tablespace_size
* p.value/1024/1024 ts_mb
, h.tablespace_maxsize
* p.value/1024/1024 max_mb
, h.tablespace_usedsize
* p.value/1024/1024 used_mb
, to_date(h.rtime, 'MM/DD/YYYY HH24:MI:SS') resize_time
, lag(h.tablespace_usedsize * p.value/1024/1024, 1, h.tablespace_usedsize * p.value/1024/1024)
over (partition by v.ts# order by h.snap_id) last
, (h.tablespace_usedsize * p.value/1024/1024)
- lag(h.tablespace_usedsize * p.value/1024/1024, 1, h.tablespace_usedsize * p.value/1024/1024)
over (partition by v.ts# order by h.snap_id) incr
from dba_hist_tbspc_space_usage h
, dba_hist_snapshot s
, v$tablespace v
, dba_tablespaces t
, v$parameter p
where h.tablespace_id = v.ts#
and v.name = t.tablespace_name
and t.contents not in ('UNDO', 'TEMPORARY')
and p.name = 'db_block_size'
and h.snap_id = s.snap_id
order by v.name, h.snap_id asc)
where incr > 0)
select to_char(resize_time, 'YYYY-MM-DD') as resized
, name
, sum(incr) incr
from ts_history
group by name
, to_char(resize_time, 'YYYY-MM-DD')
/


