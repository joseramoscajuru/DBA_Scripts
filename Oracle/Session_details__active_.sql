
select t.sql_text,s.sid, s.serial#,s.username,s.status
from v$session s, V$sql t
where t.hash_value=s.sql_hash_value
and s.status='ACTIVE'
-- and s.program like '%brspace%'
and status='ACTIVE';