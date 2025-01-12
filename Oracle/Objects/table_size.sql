Script #1 : script to display table size changes between two periods. 

column "Percent of Total Disk Usage" justify right format 999.99 
column "Space Used (MB)" justify right format 9,999,999.99 
column "Total Object Size (MB)" justify right format 9,999,999.99 
set linesize 150 
set pages 80 
set feedback off 
select * from (select to_char(end_interval_time, 'MM/DD/YY') mydate, sum(space_used_delta) / 1024 / 1024 "Space used (MB)", avg(c.bytes) / 1024 / 1024 "Total Object Size (MB)", 
round(sum(space_used_delta) / sum(c.bytes) * 100, 2) "Percent of Total Disk Usage" 
from 
   dba_hist_snapshot sn, 
   dba_hist_seg_stat a, 
   dba_objects b, 
   dba_segments c 
where begin_interval_time > trunc(sysdate) - &days_back 
and sn.snap_id = a.snap_id 
and b.object_id = a.obj# 
and b.owner = c.owner 
and b.object_name = c.segment_name 
and c.segment_name = '&segment_name' 
group by to_char(end_interval_time, 'MM/DD/YY')) 
order by to_date(mydate, 'MM/DD/YY');

SQL> column owner format a10;
SQL> column table_name format a30;
SQL> column "SIZE (GB)" format 99999.99;

SQL> select * from (select owner, segment_name table_name, bytes/1024/1024/1024 "SIZE (GB)" 
from dba_segments 
where segment_type = 'TABLE' 
and segment_name not like 'BIN%' order by 3 desc) 
where rownum <= 10;

OWNER      TABLE_NAME                     SIZE (GB)
---------- ------------------------------ ---------
ERP35      ERP35_GWRLTIRIVA                  133.03
ERP35      ERP35_SDLFGHJOEJ5DX                80.35
ERP35      ERP35_XLBERUZLR                    45.36
ERP35      ERP35_SDGKEJWLZC                   44.63
ERP35      ERP35_RTBVXGRLX                    18.35
ERP35      ERP35_ASBWEIR                      13.75
ERP35      ERP35_XBGRTUPQFL                   11.25
ERP35      ERP35_GFONVDEKGK                   10.63
ERP35      ERP35_CRKMGTHVZ                     9.38
ERP35      ERP35_UGVMKOFDEH                    8.42

10 rows selected.

	select owner, segment_name table_name, bytes/1024/1024/1024 "SIZE (GB)" 
	from dba_segments 
	where segment_type = 'TABLE' 
	and segment_name in (   )
