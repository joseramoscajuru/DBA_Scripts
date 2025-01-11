
http://scriptsfororacle.blogspot.ca/2013/01/historical-blocking-locks.html

set pagesize 50
set linesize 120
col sql_id format a15
col inst_id format '9'
col sql_text format a50
col module format a10
col blocker_ses format '999999'
col blocker_ser format '999999'
SELECT distinct
       a.sql_id ,
       a.inst_id,
       a.blocking_session blocker_ses,
       a.blocking_session_serial# blocker_ser,
       a.user_id,
       s.sql_text,
       a.module
FROM  GV$ACTIVE_SESSION_HISTORY a,
      gv$sql s
where a.sql_id=s.sql_id
  and blocking_session is not null
  and a.user_id <> 0 --  exclude SYS user
  and a.sample_time > sysdate - 1
/