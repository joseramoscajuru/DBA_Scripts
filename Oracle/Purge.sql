Display retention period:
select dbms_stats.get_stats_history_retention from dual;

SELECT SNAP_INTERVAL, RETENTION FROM DBA_HIST_WR_CONTROL;

More Details via below query:

select
extract( day from snap_interval) *24*60+
extract( hour from snap_interval) *60+
extract( minute from snap_interval ) “Snapshot Interval˝,
extract( day from retention) *24*60+
extract( hour from retention) *60+
extract( minute from retention ) “Retention Interval”
from dba_hist_wr_control;

AWR Snapshot Purging Policy

DBMS_WORKLOAD_REPOSITORY.MODIFY_SNAPSHOT_SETTINGS
(retention IN NUMBER DEFAULT NULL,
interval IN NUMBER DEFAULT NULL,
topnsql IN NUMBER DEFAULT NULL);
retention = snapshot interval (1 hr ) X 24 X X 7 days