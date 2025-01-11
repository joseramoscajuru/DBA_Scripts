
https://tinky2jed.wordpress.com/technical-stuff/oracle-stuff/oracle-blocking-locks-sessions-query/

select dbs.sid holding_sid, dbs.serial# holding_serial#, dbs.username holding_user, 
       (select count(sid) from v$session where blocking_session = dbs.sid) sessions_blocked,
       dbs.sql_id holding_sql_id, dbs.wait_class holding_class, dbs.event holding_event, dbs.seconds_in_wait holding_secs, 
       dws.sid waiting_sid, dws.serial# waiting_serial#, dws.username waiting_user, dws.sql_id waiting_sql_id, dws.wait_class waiting_class, dws.event waiting_event, dws.seconds_in_wait waiting_secs
from v$session dbs, v$session dws
where dws.blocking_session = dbs.sid
order by dbs.sid, dws.seconds_in_wait desc
/