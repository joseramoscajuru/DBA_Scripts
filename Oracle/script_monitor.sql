set pagesize 32767
set linesize 32767
column sid format 9999999
column inicio format a21 head "Start"
column Username format a10 head "Owner"
column Previsao_Termino format a25 head "ETF"
column opname format a30 head "Operation"
column Pct_Complete format 999.99
column client_info format a27
column MB_PER_S format 9999.99
--column processado format a25 head "Processed"
column sofar format 999999999 head "Processed"
set timi off
cl scr

select instance_name, to_char(sysdate, 'DD/MM/RRRR HH24:MI:SS') "Current time" from v$instance;

prompt "RMAN and Longops Sessions"
select vs.sid, vs.serial#, vs.username Username, vs.status, vsl.opname,
       to_char(Start_Time,'DD/MM/YYYY HH24:MI:SS') Inicio,
       case (totalwork*sofar) when 0
       then ''
       else to_char(start_time+(sysdate-Start_Time)/(sofar/totalwork),'DD/MM/YYYY HH24:MI:SS')
       end Previsao_Termino,
       TotalWork Total, Sofar,
       case (totalwork*sofar) when 0
       then 0
       else round(sofar/totalwork*100,2)
       end Perc_Processado
from gv$session_longops vsl
join gv$session vs on vsl.sid = vs.sid and vs.inst_id = vsl.inst_id
where totalwork <> sofar
order by Start_Time asc, 7
/
select s.client_info, l.sid, l.serial#, l.sofar, l.totalwork,
       round (l.sofar / l.totalwork*100,2) "Pct_Complete",
       aio.MB_PER_S, aio.LONG_WAIT_PCT
from gv$session_longops l,
gv$session s,
(select sid,
serial,
100* sum (long_waits) / sum (io_count) as "LONG_WAIT_PCT",
sum (effective_bytes_per_second)/1024/1024 as "MB_PER_S"
from gv$backup_async_io
group by sid, serial) aio
where aio.sid = s.sid
and aio.serial = s.serial#
and upper(l.opname) like 'RMAN%'
-- and l.opname not like '%aggregate%'
and l.totalwork != 0
and l.sofar <> l.totalwork
and s.sid = l.sid
and s.serial# = l.serial#
and s.inst_id = l.inst_id
order by 1
/

col spid for a15
col client_info format a30
col event format a30

select sid, spid, client_info, event, seconds_in_wait, p1, p2, p3
from v$process p, v$session s
where p.addr = s.paddr
and client_info like 'rman channel=%'
/