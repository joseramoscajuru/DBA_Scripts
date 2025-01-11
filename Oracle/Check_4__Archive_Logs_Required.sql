

Query the controlfile to find the latest archivelog required fore recovery. 
Lets say the backup completed at  31-AUG-2011 23:20:14:

-- V$ARCHIVED_LOG
--
ALTER SESSION SET NLS_DATE_FORMAT='DD-MON-RR HH24:MI:SS';
SELECT THREAD#, SEQUENCE#, FIRST_TIME, NEXT_TIME 
FROM V$ARCHIVED_LOG
WHERE '31-AUG-11 23:20:14' BETWEEN FIRST_TIME AND NEXT_TIME;


If the above query does not return any rows, it may be that the information has aged out of the controlfile 
- run the following query against v$log_history.

-- V$LOG_HISTORY  view does not have a column NEXT_TIME
--
ALTER SESSION SET NLS_DATE_FORMAT='DD-MON-RR HH24:MI:SS';
select a.THREAD#, a.SEQUENCE#, a.FIRST_TIME
  from V$LOG_HISTORY a
where FIRST_TIME =
    ( SELECT MAX(b.FIRST_TIME)
        FROM V$LOG_HISTORY b
       WHERE b.FIRST_TIME < to_date('31-AUG-11 23:20:14', 'DD-MON-RR HH24:MI:SS')
    ) ;
 

The sequence# returned by the above query is the log sequence current at the time the backup ended 
- let say 530 thread 1. 

For minimum recovery use: (Sequence# as returned +1 )

RMAN> RUN
{
 SET UNTIL SEQUENCE 531 THREAD 1;
 RECOVER DATABASE;
}
 

If this is a RAC implementation the use this SQL instead to query the controlfile:

SELECT THREAD#, SEQUENCE#, FIRST_CHANGE#, NEXT_CHANGE# 
FROM V$ARCHIVED_LOG 
WHERE '31-AUG-11 23:20:14' BETWEEN FIRST_TIME AND NEXT_TIME;

For minimum recovery use the log sequence and thread that has the lowest NEXT_CHANGE# 
returned by the above query.

 
Check 4 can be considered PASSED when:

All archivelogs from the time of the backup to the end of the backup is available for use during recovery

