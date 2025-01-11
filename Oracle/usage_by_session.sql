#Hint: one session can have multiple temp segment types, so you may want to summ the blocks of a session to get the correct temp usage
#Use something like this to start, then you can get as detailed as you want:

set lines 180
set pages 999
column username format a12
column machine format a25
column sql_text format a50 wrap
select t.username, se.sid,
       sum(blocks*(select value from v$parameter where name = 'db_block_size')/1024/1024) MB,
       se.machine, to_char(se.logon_time,'YY-MM-DD; HH24:MI:SS') Logon_Time,
       to_char(s.sql_fulltext) SQL_text
from v$tempseg_usage t, v$session se, v$sql s
where t.session_num=se.serial#
  and t.session_addr=se.saddr
  and se.sql_hash_value=s.hash_value(+)
  and se.sql_address=s.address(+)
group by t.username, se.machine, to_char(se.logon_time,'YY-MM-DD; HH24:MI:SS'), 
to_char(s.sql_fulltext)
--order by t.username, logon_time;
order by 3;

