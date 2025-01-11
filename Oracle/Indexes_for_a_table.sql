column INDEX_owner format a15
column table_name format a30
column index_name format a30
column column_name format a20
set lines 1000 pages 200
 
Select index_owner, table_name, index_name, column_name, COLUMN_POSITION
FROM dba_ind_columns
Where index_owner='SYS'
AND table_name='WRH$_ACTIVE_SESSION_HISTORY'
order by 1,2,3,5;