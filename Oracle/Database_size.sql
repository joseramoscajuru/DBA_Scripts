select sum(bytes / (1024*1024)) "DB Size in MB" from dba_data_files; 

1 - The size of the Oracle database files can be computed several ways:

-- get database size from v$datafile:

select round((sum(bytes)/1048576/1024),2) from v$datafile;

-- get Oracle database size from dba_data_files:
select
"Reserved_Space(MB)", "Reserved_Space(MB)" - "Free_Space(MB)" "Used_Space(MB)","Free_Space(MB)"
from(
select
(select sum(bytes/(1014*1024)) from dba_data_files) "Reserved_Space(MB)",
(select sum(bytes/(1024*1024)) from dba_free_space) "Free_Space(MB)"
from dual
);


	select
	"Reserved_Space(GB)", "Reserved_Space(GB)" - "Free_Space(GB)" "Used_Space(GB)","Free_Space(GB)"
	from(
	select
	(select sum(bytes/(1024*1024*1024)) from dba_data_files) "Reserved_Space(GB)",
	(select sum(bytes/(1024*1024*1024)) from dba_free_space) "Free_Space(GB)"
	from dual
	);



2 - The size of the sum of table extents

select
   segment_name table_name,
   sum(bytes)/(1024*1024) table_size_meg
from
   user_extents
where
   segment_type='TABLE'
and
   segment_name = 'MYTAB'
group
See code depot for full scripts.

3 - The sum of the size of the data within the tables

You can also compute the size of an Oracle database over time.  In Oracle 10g and beyond we have the dba_hist_seg_stat table with a wealth of information about all active segments within the database, including the space usage in the space_allocated_total and space_used_total columns.

This script will show "spaced used total" (total size) for a specific Oracle table, essentially computing the Oracle table size over time:
col c1 format a15 heading 'snapshot|date'
col c2 format a25 heading 'table|name'
col c3 format 999,999,999 heading 'space|used|total'
select
to_char(begin_interval_time,'yy/mm/dd hh24:mm') c1,
object_name c2,
space_used_total c3
from
dba_hist_seg_stat s,
dba_hist_seg_stat_obj o,
dba_hist_snapshot sn
where
o.owner = 'SCHEMA_07'
and
s.obj# = o.obj#
and
sn.snap_id = s.snap_id
and
object_name like 'XIF2%'
order by
begin_interval_time;

Select instance_name from v$instance;
set serveroutput on
declare
dbf number;  
tmpdbf number;  
lgf number;
ctl number;
soma number;
begin
	   select trunc(sum(bytes/1024/1024),2) into dbf from v$datafile;
	   select trunc(sum(bytes/1024/1024),2) into tmpdbf from v$tempfile;
	  select trunc(sum(bytes/1024/1024),2) into lgf from v$log l, v$logfile lf where l.group# = lf.group#;
	 select trunc(sum(block_size*file_size_blks/1024/1024),2) into ctl from v$controlfile;
	  select trunc((dbf+tmpdbf+lgf+ctl)/1024,2) into soma from dual;
   DBMS_OUTPUT.PUT_LINE(chr(10));
   DBMS_OUTPUT.PUT_LINE('Datafiles: '|| dbf ||' MB');
   DBMS_OUTPUT.PUT_LINE(chr(0));
   DBMS_OUTPUT.PUT_LINE('Tempfiles: '|| tmpdbf ||' MB');
   DBMS_OUTPUT.PUT_LINE(chr(0));
   DBMS_OUTPUT.PUT_LINE('Logfiles: '|| lgf ||' MB');
   DBMS_OUTPUT.PUT_LINE(chr(0));
   DBMS_OUTPUT.PUT_LINE('Controlfiles: '|| ctl ||' MB');
   DBMS_OUTPUT.PUT_LINE(chr(0));
   DBMS_OUTPUT.PUT_LINE('Total Tamanho: '|| soma ||' GB');
   end;
   /