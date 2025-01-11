col table_name format a20
col index_name format a20
col column_name format a20
set lines 1000 pages 100
select table_name, index_name, column_name, column_position
from dba_ind_columns
where table_name = 'ITEM_REGISTRADO'
and table_owner = 'DBCSI_DSP'
order by index_name, column_position;

