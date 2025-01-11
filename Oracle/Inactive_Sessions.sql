
col program for a30
col INACTIVE_PROGRAMS FOR A40
select s.program,count(s.program) Inactive_Sessions_from_1Hour
from gv$session s,v$process p
where p.addr=s.paddr 
-- AND s.status='INACTIVE'
and s.last_call_et > (7200)
group by s.program
order by 2 desc;
