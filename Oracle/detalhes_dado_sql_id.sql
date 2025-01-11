SELECT s.inst_id, s.sid, s.SERIAL#, s.STATUS, s.USERNAME, s.MACHINE, s.sql_id 
FROM gv$session s 
where 
--s.sid = &sid
s.sql_id='&sql_id'
/

SELECT PREV_SQL_ID FROM V$SESSION WHERE SID = &sid;
/