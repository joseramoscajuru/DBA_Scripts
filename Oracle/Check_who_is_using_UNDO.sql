
set pages 1000
set lines 1000
set trims on
col OSPID for a10
col TABLESPACE_NAME for a15
col USERNAME for a15
col MACHINE for a15
col TERMINAL for a15

select
  p.spid OSPID, d.TABLESPACE_NAME, t.STATUS, t.START_TIME, s.SID, s.SERIAL#, s.USERNAME,
  s.SQL_EXEC_START, s.MACHINE, s.TERMINAL, s.SQL_ID, s.STATE, s.PROGRAM
from v$session s, v$transaction t, dba_data_files d, v$process p
where
 s.SADDR = t.SES_ADDR and
 s.paddr = p.addr and
 t.UBAFIL=d.FILE_ID and
 d.TABLESPACE_NAME = 'PSUNDOTS'
;

Select a.name,b.status
from v$rollname a,v$rollstat b
where a.name IN ( select segment_name
from dba_segments where tablespace_name = 'PSUNDOTS')
and a.usn = b.usn;

select s.sid, s.serial#, sql.sql_text, t.used_urec records, t.used_ublk blocks,
(t.used_ublk*8192/1024) kb from v$transaction t,
v$session s, v$sql sql
where t.addr=s.taddr
and s.sql_id = sql.sql_id;