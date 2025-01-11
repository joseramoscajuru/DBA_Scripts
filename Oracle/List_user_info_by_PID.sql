select	s.username
,	s.sid
,	s.serial#
,	p.spid
,	last_call_et
,	status
from 	V$SESSION s
,	V$PROCESS p
where	s.PADDR = p.ADDR
and	p.spid='&pid';

