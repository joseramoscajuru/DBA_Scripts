select t.sql_text,s.sid, s.serial#,s.username,s.status, s.process osprocess
from v$session s, V$sql t
where t.hash_value=s.sql_hash_value 
and s.username='HR';



select t.sql_text,s.sid,s.sql_id, s.serial#,s.username,s.status
from v$session s, V$sql t
where t.hash_value=s.sql_hash_value 
and s.SID=&SID;




select t.sql_text,s.sid, s.serial#, s.process osprocess, s.username,s.status
from v$session s, v$sql t
where t.hash_value=s.sql_hash_value 
and s.username='&username';




select t.sql_text,s.sid, t.hash_value, s.serial#,s.username,s.status
from v$session s, V$sql t
where t.hash_value=s.sql_hash_value 
and s.sid=&sid;


select sql_text from v$sqltext where hash_value = (
select s.prev_hash_value from
v$session s, v$process p where s.PADDR = p.ADDR
and s.sid = <SID Number>
)
order by piece;


select piece, sql_text 
   from sys.v_$sqltext 
   where hash_value =&hash_value    
   order by piece;

select s.sid, s.serial#, p.spid, p.pid from v$session s, v$process p where p.addr = s.paddr and p.spid = 6481;

