## Determina o RATIO usado so buffer cache na SGA

Select
 AVG(
 Round(Decode (Sum(Decode(sn.name, 'consistent gets',t.value,0)) +
               Sum(Decode(sn.name, 'db block gets',t.value,0)),
               0,
               0,
               (Sum(Decode(sn.name, 'consistent gets',t.value,0)) +
                Sum(Decode(sn.name, 'db block gets',t.value,0)) -
                Sum(Decode(sn.name, 'physical reads',t.value,0))) /
               (Sum(Decode(sn.name, 'consistent gets',t.value,0)) +
                Sum(Decode(sn.name, 'db block gets',t.value,0)) )
       * 100), 2)
 )
 as "B Hit Ratio SVREPLIC"
from V$session s, V$sesstat t, V$statname sn
where s.sid = t.sid
and  sn.statistic# = t.statistic#
group by  s.sid, s.username, s.Program, s.machine
order by 1
/

