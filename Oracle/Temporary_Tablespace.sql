

For dictionary managed temporary tablespace :
             
select (s.tot_used_blocks/f.total_blocks)*100 as "percent used" 
 from (select sum(used_blocks) tot_used_blocks from v$sort_segment where tablespace_name='PSAPTEMP') s, (select sum(blocks) total_blocks from dba_data_files where tablespace_name='PSAPTEMP') f;
             
             
For locally managed temporary tablespace
             
select (s.tot_used_blocks/f.total_blocks)*100 as "percent used"
 from (select sum(used_blocks) tot_used_blocks from v$sort_segment where tablespace_name='PSAPTEMP') s, (select sum(blocks) total_blocks from dba_temp_files where tablespace_name='TEMP') f;