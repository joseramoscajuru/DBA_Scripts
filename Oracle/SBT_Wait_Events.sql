select sid, seconds_in_wait as secs, event
from v$session_wait
where wait_time = 0
and event like '%sbt%'
order by sid
/