
set pages 50000 lines 32767
col SQL_TEXT format a100
SELECT t.inst_id,s.username, s.sid, s.serial#, s.status, t.sql_id, t.sql_text 
FROM gv$session s, gv$sqlarea t
WHERE s.sql_address =t.address AND
s.sql_hash_value =t.hash_value AND
t.sql_text like '%PS_IN_DEMAND%'
/
s.sid = &SID
/

select 	sql_id ,
		prev_sql_id ,
		sql_address ,
		sid,
		serial#,
		username 
from v$session 
where 
-- sql_id='a28dg5939m18w'
sid = 3626
/

set linesize 1000
set pagesize 1000
col event format a30
col machine format a32
col username format a20
col logon format a20
select s.inst_id,w.sid,s.serial#, s.username, w.event,s.machine,to_char(s.logon_time,'dd/mm/yy hh24:mi') logon,w.WAIT_TIME, 
s.last_call_et, s.module
from gv$session_wait w, gv$session s
where s.sid=w.sid and   
--s.sid=5072 and
s.status='ACTIVE'and 
-- machine='DPSP\DPSPSPPS008' and
username is not null and w.event<>'Streams AQ: waiting for messages in the queue';