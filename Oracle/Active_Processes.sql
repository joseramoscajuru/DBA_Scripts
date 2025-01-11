prompt *******************************************************
prompt Relatorio para o seguinte:
prompt Processos ativos, inativos com transacoes abertas,
prompt bloqueados e bloqueadores com a identificacao do
prompt processo servidor
prompt *******************************************************
column username format a15
column terminal format a15
column osuser format a15
column status format a15
column blk_obj format a30
column cmd format a30
column status format a10
column STATUS2 format a10
set linesize 480
select s.status, s.sid, s.serial#, 
p.spid SRV_SPID,
s.username,
decode(ws.holding_session,NULL,'NULL','BLOCKED') STATUS2,
ws.holding_session BLOCKER,
s.process CLI_SPID,
s.osuser,
s.terminal,
s.machine,
s.program,
to_char(logon_time,'YYYY/MM/DD HH24:MI:SS') LOGON_TIME,
a.name CMD,
w.seconds_in_wait,
w.event,
decode(ws.holding_session,NULL,'NULL',o.object_name) BLK_OBJ, s.row_wait_obj# BLK_OBJ#
from v$session s, audit_actions a, dba_objects o, v$session_wait w, v$process p, dba_waiters ws
where s.command = a.action
and p.addr = s.paddr
and w.sid (+) = s.sid
and o.object_id (+) = s.row_wait_obj#
and ws.waiting_session (+) = s.sid
and s.audsid != decode(user,'SYS',-1,sys_context('userenv','sessionid'))
and s.username is not null
and (s.status != 'INACTIVE' or exists(select 1 from v$locked_object l where l.session_id = s.sid))
order by s.sid;

