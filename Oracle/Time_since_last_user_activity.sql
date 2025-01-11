set lines 100 pages 999
select username
,      floor(last_call_et / 60) "Minutes"
,      status
from   v$session
where  username is not null
order by last_call_et
/

