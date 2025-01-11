#ONLY ACTIVE

[10:50] Ricardo Ferro

SELECT * FROM V$SQLSTATS WHERE SQL_ID='b6smcnhm5kd0a';

set lines 100 pages 999
col ID format a15
select username
,      sid || ',' || serial# "ID", INST_ID
,      status
,      last_call_et "Last Activity"
from   gv$session
where  username is not null
and status = 'ACTIVE'
order by status desc
,        last_call_et desc
/



#ACTIVE e INACTIVE

set lines 100 pages 999
col ID format a15
select username
,      sid || ',' || serial# "ID"
,      status
,      last_call_et "Last Activity"
from   v$session
where  username is not null and sid=408
order by ID;
and username = 'TAXRULES_DATA'
order by status desc last_call_et desc
/


###simples
select * from v$instance;

#######RAC########
set lines 170
set pages 100
col SID format a15
col osuser format a13
col username format a10
col program format a37
col logon format a20
col status format a9
col spid format A8
col machine format a15

select s.inst_ID||'-'||CHR(39)||TO_CHAR(s.sid)||','||TO_CHAR(s.serial#)||CHR(39) SID,s.username, 
s.status, decode(s.program,NULL,machine,s.program) program, s.machine,
p.spid, to_char(s.logon_time,'DD/MM/YY hh24:mi:ss') Logon, s.sql_address
from gv$session s, 
gv$process p
where s.paddr = p.addr
--and s.sid=280;
-- and s.username is not null
order by 1,status, logon;

