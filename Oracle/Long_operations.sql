set lines 350
col opname format a25
col target format a20
col sid format 99999
col serial# format 9999999
col username format a15
col osuser format a15
col status format a10
col terminal format a15
col secs format 99999
col progress_pct format 99999999.00
col elapsed format A10
col remaining format A10

select a.sid, 
       a.serial#, 
       b.status, 
--       b.osuser, 
--       b.terminal, 
       a.sql_hash_value, 
       b.prev_hash_value, 
       a.username, 
       a.opname, 
       a.target,
       TRUNC(a.elapsed_seconds/60) || ':' || MOD(a.elapsed_seconds,60) elapsed,
       TRUNC(a.time_remaining/60) || ':' || MOD(a.time_remaining,60) remaining,
       ROUND(a.sofar/a.totalwork*100, 2) progress_pct
  from v$session_longops a, v$session b
 where a.sid = b.sid
   and a.serial# = b.serial# 
   and b.status='ACTIVE'
 order by a.elapsed_seconds
/

################

set lines 100
set lines 200
col message for a50
col sid for 999999
col serial# for 9999999
col start for a8
col cliente_info for a15
COL CLIENT_INFO FORMAT A20
col state for a8
SELECT s.sid,s.serial#,s.sql_id,TO_CHAR(start_time,'HH24:MI:SS') AS "START",round((sofar/totalwork)*100,2) AS "%COMPLETE",sw.State, sw.SECONDS_IN_WAIT , l.message,s.event
from v$session_longops l, V$SESSION s, V$SESSION_WAIT sw
where s.SID=sw.SID
and s.SID=l.SID
--and s.sid=&sid
--and l.message like '%SANGRIA%'
--and (sofar/totalwork)*100 <> 100
and totalwork <> 0
order by sid;

################

col message format a70
select SID,SOFAR,TIME_REMAINING,ELAPSED_SECONDS,MESSAGE
from v$session_longops
where sid=&sid;

############### Aline ###########################
set lines 140
set pages 100
col SID format a15
col osuser format a10
col username format a10
col opname format a30
col spid format A8
col STARTED format a19
col PCT_COMPLETED format 999.99

select s.inst_id||'-'||CHR(39)||TO_CHAR(s.sid)||','||TO_CHAR(s.serial#)||CHR(39) SID, s.USERNAME, 
        s.OSUSER, p.spid, sl.opname, to_char(sl.start_time, 'dd/mm/yyyy HH24:MI:SS') AS Started, 
        (sl.SOFAR/sl.TOTALWORK)*100 AS Pct_completed, s.sql_address
FROM gV$SESSION_LONGOPS sl, gV$SESSION s, gv$process p
WHERE sl.SID= s.SID AND sl.SERIAL#=s.SERIAL#
AND (SOFAR/TOTALWORK)*100 < 100
AND TOTALWORK > 0
AND s.paddr = p.addr
and s.INST_ID = p.INST_ID;

