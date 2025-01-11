set lines 100 pages 999
col ID		format a15
col osuser	format a15
col login_time	format a14
select 	username
,	osuser
,	sid || ',' || serial# "ID"
,	status
,	to_char(logon_time, 'hh24:mi dd/mm/yy') login_time
,	last_call_et
from	v$session
where	username is not null
order	by login_time
/

