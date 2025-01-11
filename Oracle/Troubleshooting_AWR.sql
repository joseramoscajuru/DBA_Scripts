
Detecting Missing snapshots


col instance_number format 999 heading 'Inst'
col startup_time format a15 heading 'Startup'
col begin_interval_time format a15 heading 'Begin snap'
col end_interval_time format a15 heading 'End Snap'
col flush_elapsed format a20 heading 'flush elapsed'
col error_count format 9999 heading 'Err#'

SELECT *
FROM
  (SELECT instance_number, startup_time, begin_interval_time,
    end_interval_time, flush_elapsed, error_count
  FROM dba_hist_snapshot
  ORDER BY begin_interval_time DESC
  )
WHERE rownum < 5; 

Start out by verifying if snapshots are actually starting. You need to know the time of the last snapshot and the configured snapshot interval. You can find this with the following SQL:

col systimestamp form a35
col most_recent_snap_time form a25
col snap_interval form a17
select systimestamp, most_recent_snap_time, snap_interval 
from wrm$_wr_control 
where dbid = (select dbid from v$database);

Database Settings and Status
STATISTICS_LEVEL setting
If the parameter STATISTICS_LEVEL is set to BASIC then snapshots will not be taken automatically.

show parameter statistic

