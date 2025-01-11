select
  username,
  osuser,
  terminal,
  utl_inaddr.get_host_address(terminal) IP_ADDRESS
from
  v$session
where
  username is not null
order by
  username,
  osuser;
  


-- sessoes ativas ---

col username format a20
col machine format a15
col status format a10
set lines 1000 pages 100
select s.sid as "Sid", s.serial# as "Serial#", nvl(s.username, ' ') as "Username", 
       s.machine as "Machine", s.schemaname as "Schema name", s.logon_time as "Login time", 
       s.program as "Program", s.osuser as "Os user", s.status as "Status", nvl(s.process, ' ') 
       as "OS Process id"
from v$session s
where nvl(s.username, 'a') not like 'a' 
--and status like 'ACTIVE'
order by 1,2;


-- sessoes ativas ---

select
       substr(a.spid,1,9) pid,
       substr(b.sid,1,5) sid,
       substr(b.serial#,1,5) ser#,
       substr(b.machine,1,6) box,
       substr(b.username,1,20) username,
--       b.server,
       substr(b.osuser,1,8) os_user,
       substr(b.program,1,30) program
from v$session b, v$process a
where
b.paddr = a.addr
and b.status='ACTIVE'
-- and type='USER'
-- and b.username <> 'SYS'
order by spid;


-- Verificar Sesses Ativas

col username format a10
col osuser format a10
col server format a10
col program format a50
col machine format a10
SELECT
--   ''''||TO_CHAR(s.sid)||','||to_char(s.serial#)||'''' "SID,SERIAL#",
s.sid, s.serial#,
         p.spid,
         s.username,
         s.osuser,
         s.server,
         NVL(s.module,s.program) program,
         NVL(s.machine,s.terminal) machine,
         s.last_call_et
    FROM v$session s,
         v$process p
   WHERE s.paddr       = p.addr
     AND s.username    IS NOT NULL
     AND s.username = 'SYS'
     AND s.status      = 'ACTIVE'
ORDER BY s.last_call_et DESC
/

-- Verificar SQL's

select v.sid,
       v.serial#,
       v.username,
       s.sql_text
  from v$sql s,
       v$session v
 where s.address = v.sql_address  
   and v.status = 'ACTIVE'
   and v.username is not null
/

-- Verificar Bloqueios

select substr(o.object_name,1,25)       objeto,
       l.session_id                     session_id,
       l.oracle_username                ora_user,
       l.os_user_name                   os_user
from   dba_objects o, v$locked_object l
where  l.object_id = o.object_id
order by 1,3,4
/

-- Total de I/O por datafile

SELECT Substr(d.name,1,50) "File Name",
       f.phyblkrd "Blocks Read",
       f.phyblkwrt "Blocks Writen",
       f.phyblkrd + f.phyblkwrt "Total I/O"
FROM   v$filestat f,
       v$datafile d
WHERE  d.file# = f.file#
ORDER BY f.phyblkrd + f.phyblkwrt DESC;

-- Top 10 query's com mais leitura em disco

SELECT sql_text, disk_reads
  FROM (SELECT sql_text, disk_reads,
        DENSE_RANK() OVER
          (ORDER BY disk_reads DESC) DiSk_READS_RANK
       FROM v$sql)
 WHERE disk_reads_rank <= 10;

-- Eventos em espera

  SELECT s.sid,
         s.serial#,
         s.username,
         sw.event,
         sw.p1text||'='||sw.p1 p1,
         sw.p2text||'='||sw.p2 p2,
         sw.p3text||'='||sw.p3 p3
    FROM v$session_wait sw,
         v$session s
   WHERE sw.sid in (SELECT sid
                      FROM v$session
                     WHERE status   ='ACTIVE'
                       AND USERNAME IS NOT NULL)
     AND sw.sid = s.sid
ORDER BY sw.event
/

