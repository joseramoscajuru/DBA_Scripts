select a.value, s.username, s.sid, s.serial#
from v$sesstat a, v$statname b, v$session s
where a.statistic# = b.statistic#  and s.sid=a.sid
and b.name = 'opened cursors current';

SELECT       
sid,user_name, COUNT(*) "Cursors per session"         
FROM v$open_cursor         
GROUP BY sid,user_name;

select a.value, b.name 
            from v$mystat a, v$statname b 
           where a.statistic# = b.statistic# 
             and a.statistic#= 3;

select sum(a.value), b.name
      from v$sesstat a, v$statname b
     where a.statistic# = b.statistic#
       and b.name = 'opened cursors current'
     group by b.name
/