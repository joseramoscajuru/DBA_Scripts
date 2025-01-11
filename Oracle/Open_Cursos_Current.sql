select s.username, max(a.value)
 from v$sesstat a, v$statname b, v$session s
 where a.statistic# = b.statistic#
 and s.sid (+)= a.sid
 and b.name = 'opened cursors current'
 group by s.username