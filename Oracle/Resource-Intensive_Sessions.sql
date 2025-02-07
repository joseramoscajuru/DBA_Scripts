Selecting from V$SESSMETRIC to Find Current
Resource-Intensive Sessions

This query shows the sessions that are heaviest in physical reads, CPU usage, or logical reads over
a defined interval (15 seconds, by default). You may want to adjust the thresholds as appropriate for
your environment.

To find resource-intensive sessions:

select * from (
Select TO_CHAR(m.end_time,'DD-MON-YYYY HH24:MI:SS') e_dttm, -- Interval End Time
m.intsize_csec/100 ints, -- Interval size in sec
s.username usr,
m.session_id sid,
m.session_serial_num ssn,
ROUND(m.cpu) cpu100, -- CPU usage 100th sec
m.physical_reads prds, -- Number of physical reads
m.logical_reads lrds, -- Number of logical reads
m.pga_memory pga, -- PGA size at end of interval
m.hard_parses hp,
m.soft_parses sp,
m.physical_read_pct prp,
m.logical_read_pct lrp,
s.sql_id
from v$sessmetric m, v$session s
where (m.physical_reads > 100
or m.cpu > 100
or m.logical_reads > 100)
and m.session_id = s.sid
and m.session_serial_num = s.serial#
order by m.cpu DESC)
where rownum < 11;

--order by m.physical_reads DESC, m.cpu DESC, m.logical_reads DESC;
