
set linesize 1000
set pagesize 1000
col event format a30
col machine format a32
col username format a20
col logon format a20
col sid format 99999


select e.EVENT, avg(AVERAGE_WAIT)*10, max(AVERAGE_WAIT)*10
  from v$session_event e, v$session s where s.sid = e.sid and s.STATUS='ACTIVE' and 
  e.EVENT ='db file sequential read' group by e.EVENT;

select e.EVENT, avg(AVERAGE_WAIT)*10, max(AVERAGE_WAIT)*10
  from v$session_event e, v$session s 
  where s.sid = e.sid and 
  s.STATUS='ACTIVE' 
  group by e.EVENT
  order by 2 desc;

select s.inst_id,w.sid,s.serial#, s.username, w.event,s.machine,to_char(s.logon_time,'dd/mm/yy hh24:mi') logon,w.WAIT_TIME, 
s.last_call_et, s.module
from gv$session_wait w, gv$session s
where s.sid=w.sid and   
--s.sid=5072 and
s.username in ('DBCSI_DSP','INTERFACE_DATAHUB','INTERFACE_P2K') and
s.status='ACTIVE'and 
username is not null and w.event<>'Streams AQ: waiting for messages in the queue';