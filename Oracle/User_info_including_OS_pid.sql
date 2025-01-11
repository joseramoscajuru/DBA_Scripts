col "SID/SERIAL" format a10
col username format a15
col osuser format a15
col program format a40
select	s.sid || ',' || s.serial# "SID/SERIAL"
,	s.username
,	s.osuser
,	p.spid "OS PID"
,	s.program
from	v$session s
,	v$process p
Where	s.paddr = p.addr and p.spid=&pid
order 	by to_number(p.spid)
/

