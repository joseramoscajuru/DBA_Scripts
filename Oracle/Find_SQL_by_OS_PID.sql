prompt "Please Enter The UNIX Process ID"
set pagesize 1000
set linesize 1000
set long 500000
set head on
col su format a30
col txt format a50
col status for a20
select
s.username su,
s.sid,
sa.sql_id,
substr(sa.sql_text,1,50) txt,
s.status
from v$process p,
v$session s,
v$sqlarea sa
where p.addr=s.paddr
and s.username is not null
--and s.status = 'ACTIVE'
and s.sql_address=sa.address(+)
and s.sql_hash_value=sa.hash_value(+)
and spid=16253326;
