
set lines 1000 pages 500
col SECONDS_IN_WAIT format 999
col start format a20
col state format a15
SELECT s.sid,s.serial#,TO_CHAR(start_time,'dd-mon-yyyy HH24:MI:SS') AS "START",round((sofar/totalwork)*100,2) AS "%COMPLETE",sw.State, sw.SECONDS_IN_WAIT , l.message,s.event
from v$session_longops l, V$SESSION s, V$SESSION_WAIT sw
where s.SID=sw.SID
and s.SID=l.SID
and s.status='ACTIVE'
--and s.program like '%brspace%'
and totalwork <> 0
order by sid;

