
-- It reports only growth day for a identified tablespace.
SELECT *
FROM ( SELECT v.name,
v.ts#,
s.instance_number,
h.tablespace_size * p.VALUE / 1024 / 1024 ts_mb,
h.tablespace_maxsize * p.VALUE / 1024 / 1024 max_mb,
h.tablespace_usedsize * p.VALUE / 1024 / 1024 used_mb,
TO_DATE (h.rtime, 'MM/DD/YYYY HH24:MI:SS') resize_time,
LAG (h.tablespace_usedsize * p.VALUE / 1024 / 1024,
1,
h.tablespace_usedsize * p.VALUE / 1024 / 1024)
OVER (PARTITION BY v.ts# ORDER BY h.snap_id)
last_mb,
(h.tablespace_usedsize * p.VALUE / 1024 / 1024)
- LAG (h.tablespace_usedsize * p.VALUE / 1024 / 1024,
1,
h.tablespace_usedsize * p.VALUE / 1024 / 1024)
OVER (PARTITION BY v.ts# ORDER BY h.snap_id)
incr
FROM dba_hist_tbspc_space_usage h,
dba_hist_snapshot s,
v$tablespace v,
dba_tablespaces t,
v$parameter p
WHERE h.tablespace_id = v.ts#
AND v.name = t.tablespace_name
AND t.contents NOT IN ('UNDO', 'TEMPORARY')
AND p.name = 'db_block_size'
AND h.snap_id = s.snap_id
/* For a specific time */
AND s.begin_interval_time > SYSDATE - 1 / 12
/* For a specific tablespace */
--AND v.ts# = 19
AND v.NAME='BILARGE'
ORDER BY v.name, h.snap_id ASC)
WHERE incr > 0;
