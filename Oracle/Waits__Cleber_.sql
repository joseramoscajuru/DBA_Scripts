
PROMPT wait

set linesize 1000
set pagesize 1000
select e.EVENT, avg(AVERAGE_WAIT)*10, max(AVERAGE_WAIT)*10
  from v$session_event e, v$session s where s.sid = e.sid and s.STATUS='ACTIVE' and 
  e.EVENT ='db file sequential read' group by e.EVENT;

set linesize 1000
set pagesize 1000
col event format a60
select e.EVENT, avg(AVERAGE_WAIT)*10, max(AVERAGE_WAIT)*10
  from v$session_event e, v$session s 
  where s.sid = e.sid and 
  s.STATUS='ACTIVE' 
  group by e.EVENT
  order by 2 desc;
  
set linesize 1000
set pagesize 1000
col event format a30
col machine format a32
col username format a20
col logon format a20
col module format a40
select s.inst_id,w.sid,s.serial#, s.username, w.event,s.machine,to_char(s.logon_time,'dd/mm/yy hh24:mi') logon,w.WAIT_TIME, 
s.last_call_et, s.module
from gv$session_wait w, gv$session s
where s.sid=w.sid and   
--s.sid=5072 and
s.status='ACTIVE'and 
username is not null and w.event<>'Streams AQ: waiting for messages in the queue';

set lines 1000
set pagesize 1000
col message for a80
col username format a8
col sid for 999999
col serial# for 9999999
col start for a8
col cliente_info for a15
COL  CLIENT_INFO FORMAT A20
col state for a20
SELECT  s.sid, s.serial#,s.username,
	TO_CHAR(start_time,'HH24:MI:SS') AS "START",
	round((sysdate-start_time)*24*60,2) minutos,
	round((round((sofar/totalwork)*100,2) /((sysdate-start_time)*24*60)) *(100-round((sofar/totalwork)*100,2)),2) falta,
	round((sofar/totalwork)*100,2) AS "%COMPLETE",
	sw.State,
	sw.SECONDS_IN_WAIT SEC_WAIT,
	message, sw.EVENT
	from v$session_longops l, V$SESSION s, V$SESSION_WAIT sw
	where  s.SID=sw.SID
	and s.SID=l.SID
	and (sofar/totalwork)*100 <> 100
	and totalwork <> 0
	--AND L.USERNAME='SYS'
	order by 3 desc;


