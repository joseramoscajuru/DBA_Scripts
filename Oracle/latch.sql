Script para analise de LATCH HIT RATIO.

SELECT 'Latch Hit Ratio ' "Ratio"
, ROUND(
(SELECT SUM(gets) - SUM(misses) FROM V$LATCH)
/ (SELECT SUM(gets) FROM V$LATCH)
* 100, 2)||'%' "Percentage"
FROM DUAL;

A better approach to estimating the impact of latch contention is to consider the relative
amount of time being spent waiting for latches. The following query gives us some
indication of this:

SELECT event, time_waited,
round(time_waited*100/ SUM (time_waited) OVER(),2) wait_pct
FROM (SELECT event, time_waited
FROM v$system_event
WHERE event NOT IN
('Null event',
'client message',
'rdbms ipc reply',
'smon timer',
'rdbms ipc message',
'PX Idle Wait',
'PL/SQL lock timer',
'file open',
'pmon timer',
'WMON goes to sleep',
'virtual circuit status',
'dispatcher timer',
'SQL*Net message from client',
'parallel query dequeue wait',
'pipe get'
) UNION
(SELECT NAME, VALUE
FROM v$sysstat
WHERE NAME LIKE 'CPU used when call started'))
ORDER BY 2 DESC

Now we can look at the sleeps in v$latch to determine which latches are likely to be
contributing most to this problem:

select name, gets, sleeps,
sleeps*100/sum(sleeps) over() sleep_pct, sleeps*100/gets
sleep_rate
from v$latch where gets>0
order by sleeps desc;

