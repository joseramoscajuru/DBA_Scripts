select t.sql_text,s.sid,s.username,s.status
from v$session s, V$sql t
where t.hash_value=s.sql_hash_value 
and s.status='ACTIVE'
and t.sql_text not like '%SELECT%'
and t.sql_text not like '%select%';
--and s.status='ACTIVE';

