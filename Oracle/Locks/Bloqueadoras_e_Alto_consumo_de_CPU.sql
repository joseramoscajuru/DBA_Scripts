# SESSES BLOQUEADORAS
set lines 100 pages 999
col "SID,SERIAL#" format a17
col DB_USER    format a15
col OSUSER format a10
select TO_CHAR(s.SID)||','||TO_CHAR(s.SERIAL#) "SID,SERIAL#", s.USERNAME DB_USER, s.OSUSER OS_USER, p.PID, q.sql_text " "
from V$SESSION s, V$PROCESS p, V$SQL q
where s.PADDR = p.ADDR and s.prev_hash_value = q.hash_value
and s.SID in
(select BLOCKING_SESSION from V$SESSION);

**************************************************************

# SESSES COM ALTO CONSUMO DE CPU IDENTIFICADAS NO SO
set lines 100 pages 999
col "SID,SERIAL#" format a17
col DB_USER    format a15
col OSUSER format a10
select TO_CHAR(s.SID)||','||TO_CHAR(s.SERIAL#) "SID,SERIAL#", s.USERNAME DB_USER, s.OSUSER OS_USER, p.PID, p.PROGRAM, q.sql_text " "
from V$SESSION s, V$PROCESS p, V$SQL q
where s.PADDR = p.ADDR and s.prev_hash_value = q.hash_value
and p.spid=&spid;

***************************************************************
#para um usuario

set lines 100 pages 999
col "SID,SERIAL#" format a17
col DB_USER    format a15
col OSUSER format a10
select TO_CHAR(s.SID)||','||TO_CHAR(s.SERIAL#) "SID,SERIAL#", s.USERNAME DB_USER, s.OSUSER OS_USER, p.PID, q.sql_text " "
from V$SESSION s, V$PROCESS p, V$SQL q
where s.PADDR = p.ADDR and s.prev_hash_value = q.hash_value
and s.USERNAME='&user';

