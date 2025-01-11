
SQL id consuming more CPU in Oracle

set lines 1000 pages 100
col program form a30 heading "Program"
col cpu_usage_sec form 99990 heading "CPU in Seconds"
col MODULE for a18
col OSUSER for a10
col USERNAME for a15
col OSPID for a06 heading "OS PID"
col SID for 99999
col SERIAL# for 999999
col SQL_ID for a15
select * from (
select p.spid "ospid",
(se.SID),ss.serial#,ss.SQL_ID,ss.username,substr(ss.program,1,30) "program",
ss.module,ss.osuser,ss.MACHINE,ss.status,
se.VALUE/100 cpu_usage_sec
from v$session ss,v$sesstat se,
v$statname sn,v$process p
where
se.STATISTIC# = sn.STATISTIC#
and NAME like '%CPU used by this session%'
and se.SID = ss.SID
and ss.username !='SYS'
and ss.status='ACTIVE'
and ss.username is not null
and ss.paddr=p.addr and value > 0
order by se.VALUE desc)
where rownum < 11;

Top 10 CPU consuming Session in Oracle

col program form a30 heading "Program"
col CPUMins form 99990 heading "CPU in Mins"
select rownum as rank, a.*
from (
SELECT sess.username, v.sid,sess.Serial# ,program, v.value / (100 * 60) CPUMins
FROM v$statname s , v$sesstat v, v$session sess
WHERE s.name = 'CPU used by this session'
and sess.sid = v.sid
and v.statistic#=s.statistic#
and v.value>0
ORDER BY v.value DESC) a
where rownum < 11;

Top CPU Consuming Session in last 10 min

select * from
(
select session_id, session_serial#, count(*)
from v$active_session_history
where session_state= 'ON CPU' and
sample_time >= sysdate - interval '10' minute
group by session_id, session_serial#
order by count(*) desc
);

SQL Text top consuming CPU in Oracle

col cpu_usage_sec form 99990 heading "CPU in Seconds"
select * from (
select
(se.SID),substr(q.sql_text,80),ss.module,ss.status,se.VALUE/100 cpu_usage_sec
from v$session ss,v$sesstat se,
v$statname sn, v$process p, v$sql q
where
se.STATISTIC# = sn.STATISTIC#
AND ss.sql_address = q.address
AND ss.sql_hash_value = q.hash_value
-- and NAME like '%CPU used by this session%'
and se.SID = ss.SID
and ss.username !='SYS'
and ss.status='ACTIVE'
and ss.username is not null
and ss.paddr=p.addr and value > 0
--and substr(q.sql_text,80) like '%SELECT MAX(PROD_2.VALID_INICIAL) FROM ESP_SP_PROD_ST PROD_2 WHERE PROD_2.COD_EMPRESA = PROD.CO%'
order by se.VALUE desc)
where rownum < 11;