set lines 100
set lines 200 pagesize 1000
col message for a50
col username format 10
col sid for 999999
col serial# for 9999999
col start for a8
col cliente_info for a15
COL  CLIENT_INFO FORMAT A20
col state for a8
SELECT  s.sid, s.serial#,s.username,
	TO_CHAR(start_time,'HH24:MI:SS') AS "START",
	--round((sysdate-start_time)*24*60,2) minutos,
	--round((round((sofar/totalwork)*100,2) /((sysdate-start_time)*24*60)) *(100-round((sofar/totalwork)*100,2)),2) falta,
	round((sofar/totalwork)*100,2) AS "%COMPLETE",
	sw.State,
	sw.SECONDS_IN_WAIT SEC_WAIT,
	message, sw.EVENT
	from v$session_longops l, V$SESSION s, V$SESSION_WAIT sw
	where  s.SID=sw.SID
	and s.SID=l.SID
	and (sofar/totalwork)*100 <> 100
	and totalwork <> 0
	-- and message like '%PS_IN_DEMAND%'
	--AND L.USERNAME='SYS'
	order by 3 desc;
	
	SELECT s.sid,
       s.serial#,
       s.username,
       s.machine,
       s.program,
       s.last_call_et,
       s.sql_id,
       s.sql_child_number,
       q.sql_text
FROM v$session s
JOIN v$sql q ON s.sql_id = q.sql_id
WHERE s.sql_id IS NOT NULL
AND s.status = 'ACTIVE'
AND s.last_call_et > 60 -- filtro opcional para exibir apenas sessões ativas há mais de 60 segundos
AND (q.parsing_schema_name IS NULL OR q.parsing_schema_name NOT IN ('SYS', 'SYSTEM')) -- filtro opcional para excluir consultas do sistema
-- AND q.sql_text LIKE '%FULL%' -- filtro para identificar consultas que envolvem operações de full scan
ORDER BY s.last_call_et DESC;
