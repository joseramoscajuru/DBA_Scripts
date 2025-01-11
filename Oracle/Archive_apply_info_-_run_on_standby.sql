
#Archive apply info - run on standby
 col name for a13
 col value for a20
 col unit for a30
 set lines 122
 SELECT NAME, VALUE, UNIT, TIME_COMPUTED
 FROM V$DATAGUARD_STATS
 WHERE NAME IN ('transport lag', 'apply lag');

 #Archive apply info - run on standby
 col type for a15
 set lines 122
 set pages 33
 col item for a20
 col units for a15
 select to_char(start_time, 'DD-MON-RR HH24:MI:SS') start_time,
 item, sofar, units
 from v$recovery_progress
 where (item='Active Apply Rate'
 or item='Average Apply Rate'
 or item='Redo Applied' or item='Apply Time per Log' )
 /