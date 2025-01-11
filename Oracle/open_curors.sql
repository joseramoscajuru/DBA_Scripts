Just like the sessions and processes parameters, your application usage determines the value for open_cursors.

If you set open_cursors value too high, you risk having a task abort with the ORA-01000 error:

ORA-01000 maximum open cursors exceeded

 Whenever you get an ORA-01000 error you need to determine if the session has a bug or whether the cursor requests are legitimate.  You can change the open_cursors parameter dynamically while the database is running using an alter system statement:

 alter system set open_cursors = 400 scope=both;
You can monitor your high water mark for open cursors with a query like this:

col hwm_open_cur format 99,999
col max_open_cur format 99,999
select 
   max(a.value) as hwm_open_cur, 
   p.value      as max_open_cur
from 
   v$sesstat a, 
   v$statname b, 
   v$parameter p
where 
   a.statistic# = b.statistic# 
and 
   b.name = 'opened cursors current'
and 
   p.name= 'open_cursors'
group by p.value;


HWM_OPEN_CUR     MAX_OPEN_CUR
---------------- ------------
           2,350        4,096
 In sum, the open_cursors parameter default value is usually enough for any application, and it can be increased as-needed, depending upon your application.

 Monitoring open cursors

To monitor your open cursors, you have several views:

 

Â§  v$open_cursor

Â§  v$sesstat

select 
   stat.value, 
   sess.username, 
   sess.sid, 
   sess.serial#
from 
   v$sesstat  stat, 
   v$statname b, 
   v$session  sess
where 
   stat.statistic# = b.statistic#  
and 
   sess.sid=stat.sid
and 
   b.name = 'opened cursors current'; 


select 
   sum(stat.value) 
   total_cur, 
   avg(stat.value) avg_cur, 
   max(stat.value) max_cur, 
   sess.username, 
   sess.machine
from 
   v$sesstat   stat, 
   v$statname     b, 
   v$session    sess 
where 
   stat.statistic# = b.statistic#  
and 
   sess.sid=stat.sid
and 
   b.name = 'opened cursors current' 
group by 
   sess.username, 
   sess.machine
order by 1 desc;

