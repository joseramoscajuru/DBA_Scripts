
-- Apply rate: To find out the speed of media recovery in a standby database, you can use this query:


set lines 200
col type format a30
col ITEM format a20
col comments format a20
select * from v$recovery_progress;

START_TIM TYPE             ITEM                 UNITS        SOFAR      TOTAL TIMESTAMP COMMENTS
--------- ---------------- -------------------- ------------------ ---------- --------- ----
20-JUN-13 Media Recovery   Log Files            Files         3363          0
20-JUN-13 Media Recovery   Active Apply Rate    KB/sec       21584          0
20-JUN-13 Media Recovery   Average Apply Rate   KB/sec        3239          0
20-JUN-13 Media Recovery   Maximum Apply Rate   KB/sec       48913          0
20-JUN-13 Media Recovery   Redo Applied         Megabytes  2953165          0
20-JUN-13 Media Recovery   Last Applied Redo    SCN+Time         0          0 01-JUL-13
20-JUN-13 Media Recovery   Active Time          Seconds     233822          0
20-JUN-13 Media Recovery   Apply Time per Log   Seconds         57          0
20-JUN-13 Media Recovery   Checkpoint Time per  Seconds         11          0
                           Log
20-JUN-13 Media Recovery   Elapsed Time         Seconds     933565          0
20-JUN-13 Media Recovery   Standby Apply Lag    Seconds        483          0

11 rows selected.

-- You can also use below before 11gR2. (Deprecated in 11gR2):

select APPLY_RATE from V$STANDBY_APPLY_SNAPSHOT;


