
This assumes an 8K blocksize.  But to go back in time you can use the TEMP_SPACE_ALLOCATED column of V$ACTIVE_SESSION_HISTORY or DBA_HIST_ACTIVE_SESS_HISTORY to identify a query that consumed a lot of temp space.

Here is an example:

select sql_id,max(TEMP_SPACE_ALLOCATED)/(1024*1024*1024) gig 
from DBA_HIST_ACTIVE_SESS_HISTORY 
where 
sample_time > sysdate-1 and 
TEMP_SPACE_ALLOCATED > (50*1024*1024*1024) 
group by sql_id 
order by 2 desc;

select sql_id,max(TEMP_SPACE_ALLOCATED)/(1024*1024*1024) gig 
from DBA_HIST_ACTIVE_SESS_HISTORY 
where 
sample_time > sysdate-2 and 
TEMP_SPACE_ALLOCATED > (10*1024*1024*1024) 
group by sql_id order by sql_id;


This gives the sql_id and maximum allocated temp space of any queries that ran in the past two days and exceeded 50 gigabytes of temp space.

This is a great feature of these ASH views.  Now we can go back in time and find the queries that were using all the temp space and tune them.

