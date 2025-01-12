========formata output=============
set linesize 180
col sid format 99999
col opname format a35
col target format a10
col units format a15
col time_remaining format 999990 heading Remaining[s]
col bps format 99990.99 heading [Units/s]
col fertig format 90.99 heading "complete[%]"
col endat heading "Fisnish at"

col "User" format a15
col program format a30
col module format a30
col action format a20


------ verifica alocaao de fita=======

select sid, seconds_in_wait as secs, event
from v$session_wait
where wait_time = 0
and event like '%sbt%'
order by sid
/


------ ETA do refresh==============

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
-- and opname like '%rman%'
/

