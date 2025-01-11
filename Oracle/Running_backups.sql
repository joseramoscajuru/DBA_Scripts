set linesize 180
col sid format 99999
col opname format a35
col target format a10
col units format a50
col time_remaining format 999990 heading Remaining[s]
col bps format 99990.99 heading [Units/s]
col fertig format 90.99 heading "complete[%]"
col endat heading "Fisnish at"
col "User" format a15
col program format a30
col module format a30
col action format a20


alter session set nls_date_format='dd-mm-yyyy hh24:mi';

select sid,
opname,/*
target,
sofar,
totalwork,
units, */
(totalwork-sofar)/time_remaining bps,
time_remaining,
sofar/totalwork*100 fertig,
sysdate + TIME_REMAINING/3600/24 endat
from v$session_longops
where time_remaining > 0
and opname like 'RMAN%'
/ 

=========================================================================================================================================

Pra checar a prgresso dos backups: 

set lines 120
set pages 100
col SID format a15
col osuser format a10
col username format a10
col opname format a30
col spid format A8
col STARTED format a10


select s.inst_id||'-'||CHR(39)||TO_CHAR(s.sid)||','||TO_CHAR(s.serial#)||CHR(39) SID, s.USERNAME, 
        s.OSUSER, p.spid, sl.opname, to_char(sl.start_time, 'HH24:MI:SS') AS Started, 
        (sl.SOFAR/sl.TOTALWORK)*100 AS Pct_completed, s.sql_address
FROM gV$SESSION_LONGOPS sl, gV$SESSION s, gv$process p
WHERE sl.SID= s.SID AND sl.SERIAL#=s.SERIAL#
AND (SOFAR/TOTALWORK)*100 < 100
AND TOTALWORK > 0
AND s.paddr = p.addr
AND s.USERNAME = 'SYS';


==========================================================================================================================================

select operation as "OPERACAO",
object_type as "TIPO",
status,
output_device_type as "MEDIA",
to_char(end_time,'DD-MM-RRRR HH24:MI:SS') as "DATA",
round(MBYTES_PROCESSED/1024,2) as "TAMANHO(MB)"
from
v$rman_status
where
operation <> 'CATALOG'
and trunc(end_time)>=trunc(sysdate-1)
order by
end_time
/
