
Daily Archive Log Generation

select trunc(COMPLETION_TIME,'DD') Day, thread#, 
round(sum(BLOCKS*BLOCK_SIZE)/1024/1024/1024) GB,
count(*) Archives_Generated from v$archived_log 
group by trunc(COMPLETION_TIME,'DD'),thread# order by 1;

Hourly Archive Log Generation

set pages 1000
alter session set nls_date_format = 'DD-MON-YYYY HH24:MI:SS';

select trunc(COMPLETION_TIME,'HH') Hour,thread# , 
round(sum(BLOCKS*BLOCK_SIZE)/1024/1024/1024) GB,
count(*) Archives from v$archived_log 
group by trunc(COMPLETION_TIME,'HH'),thread#  order by 1 ;


Monthly Archive Log Generation

select trunc(COMPLETION_TIME,'MON') Day, thread#, 
round(sum(BLOCKS*BLOCK_SIZE)/1024/1024/1024) GB,
count(*) Archives_Generated from v$archived_log 
group by trunc(COMPLETION_TIME,'MON'),thread# order by 1;