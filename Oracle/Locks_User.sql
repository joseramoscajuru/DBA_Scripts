****3. Verificar o usurio*****
set linesize 500
set pagesize 1000
column conn format a25
column username format a15
column lockwait format a10
column SessionWait format a80
col logon format a20
column sql format a20
select
sid || ',' || serial# || ' - ' || username Conn,
coalesce(LOCKWAIT,status) LOCKWAIT, to_char(logon_time,'MM/DD/YYYY - HH24:MI') LOGON,
(select event|| ' - Seconds waiting: '|| SECONDS_IN_WAIT || ' - '|| p1 || ' ' || p1text from v$session_wait where sid = vs.sid) SessionWait,
(SELECT substr(sql_text,1,60) FROM v$sql WHERE hash_value = vs.sql_hash_value AND child_number = 0) SQL
from v$session vs where status in('ACTIVE','KILLED','INACTIVE') and type <> 'BACKGROUND' and username is not null 
and username != 'SYS' and vs.sid = 752;

- trocar o ultimo numero 617 pelo PID
- aparece na primeira parte, o PID e em 3o, o nome do user

