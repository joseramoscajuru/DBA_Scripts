
## ALERT LOG ##
set linesize 160 pagesize 0
col time for a20
col message_text for a120 head Message
SELECT to_char(originating_timestamp,'DD/MM/YYYY HH24:MI:SS') time, message_text 
FROM v$diag_alert_ext 
where originating_timestamp>sysdate-8/24
order by RECORD_ID ;

set linesize 160 pagesize 0
col time for a20
col message_text for a120 head Message
SELECT to_char(originating_timestamp,'DD/MM/YYYY HH24:MI:SS') time, message_text
FROM v$diag_alert_ext
where 
-- originating_timestamp>sysdate-90
message_text like '%ORA-15%'
order by RECORD_ID;



## ALERTS DATABASE ##
set lines 160 pages 1000
col Tipo for a8
col creation_time for a20
col reason for a120
select 'Alert' Tipo,to_char(creation_time,'DD/MM/YYYY HH24:MI:SS') creation_time, reason from dba_outstanding_alerts
union
select 'History' Tipo,to_char(creation_time,'DD/MM/YYYY HH24:MI:SS') creation_time, reason from dba_alert_history 
order by 2 desc,creation_time;

