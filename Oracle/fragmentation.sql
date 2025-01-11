COLUMN TABLE_NAME HEADING 'Table Name' ENTMAP OFF
COLUMN OWNER HEADING 'User' ENTMAP OFF
set lines 1000 pages 200
col owner format a15
col "Actual size" format a20
col "Reclaimable space MB" format a20
col table_name format a20
col "Fragmented size" format a20

TTITLE CENTER -
"FRAGMENTATION REPORT (reclaimable space > 10gB) - PEOPLESOFT"

select  owner,
        table_name,
        round((blocks*8),2)/1024 ||'Mb' "Fragmented size", 
        round((num_rows*avg_row_len/1024/1024),2)||'Mb' "Actual size", 
        round((blocks*8),2)/1024 - round((num_rows*avg_row_len/1024/1024),2)||'Mb' "Reclaimable space MB",
        ((round((blocks*8),2)-round((num_rows*avg_row_len/1024),2))/round((blocks*8),2))*100 -10 "reclaimable space % "
from dba_tables 
where 
        num_rows is not null
        and avg_row_len is not null
        and blocks is not null
        and round(blocks*8,2) <> 0
--      AND owner='SAPSR3'
        and round((blocks*8),2)/1024 - round((num_rows*avg_row_len/1024/1024),2) > 10000	
order by round((blocks*8),2)/1024 - round((num_rows*avg_row_len/1024/1024),2) desc;