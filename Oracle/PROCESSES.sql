
Set trimspool on;
set linesize 1000;
set pagesize 10000;

alter session set nls_date_format = 'DD-MON-YYYY HH24:MI:SS';

select count(*) from v$session;

col machine form a30
col sql_text form a1024
set lines 2000
set pagesize 1000
col osuser form a15
col username form a15
select 
-- distinct 
w.sid,se.serial#, se.status, se.logon_time, SE.SQL_ID, se.username, se.machine, se.module, se.program, substr(s.sql_text,1,1024) sql_text
from gv$session_wait w, gv$session se, gv$sqlarea s
where
se.sid     = w.sid
and se.sql_hash_value = s.hash_value
and w.inst_id = se.inst_id
and se.inst_id = w.inst_id
and se.sql_address    = s.address
and se.username is not null
-- and se.sid=929
-- and se.username = 'DATADOG'
--and se.username IN ('DBCSI_DSP','INTERFACE_DATAHUB','INTERFACE_P2K')
and se.status = 'ACTIVE'
--and se.sid in (629,11,1567,5711,3637,1907,2839,2339)
order by sid;
