
-- Tables + Size MB
select owner, table_name, round((num_rows*avg_row_len)/(1024*1024)) MB 
from all_tables 
where owner not like 'SYS%'  -- Exclude system tables.
and num_rows > 0  -- Ignore empty Tables.
order by MB desc -- Biggest first.
;

select segment_name "Table", bytes/1024/1024/1024 "Size_Gbytes"
from dba_segments 
where segment_name = 'PRD_ODI_AUX'
/
	