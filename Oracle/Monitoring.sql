while true
do

echo ' '
echo 'DATE'
echo '=============='
echo ' '

date

sqlplus -s "/ as sysdba" << EOF

PROMPT
PROMPT TABLESPACE ALLOCATION REPORT
PROMPT ============================


set pages 999
col tablespace_name format a40
col "size MB" format 999,999,999
col "free MB" format 99,999,999
col "% Used" format 999
select 	tsu.tablespace_name, ceil(tsu.used_mb) "size MB"
,	decode(ceil(tsf.free_mb), NULL,0,ceil(tsf.free_mb)) "free MB"
,	decode(100 - ceil(tsf.free_mb/tsu.used_mb*100), NULL, 100,
               100 - ceil(tsf.free_mb/tsu.used_mb*100)) "% used"
from	(select tablespace_name, sum(bytes)/1024/1024 used_mb
	from 	dba_data_files group by tablespace_name union all
	select 	tablespace_name || '  **TEMP**'
	,	sum(bytes)/1024/1024 used_mb
	from 	dba_temp_files group by tablespace_name) tsu
,	(select tablespace_name, sum(bytes)/1024/1024 free_mb
	from 	dba_free_space group by tablespace_name) tsf
where	tsu.tablespace_name = tsf.tablespace_name (+) 
and decode(100 - ceil(tsf.free_mb/tsu.used_mb*100), NULL, 100, 100 - ceil(tsf.free_mb/tsu.used_mb*100)) > 70
order by 4;

PROMPT 
PROMPT DATABASE LOCKS
PROMPT ==============

select sid, type, id1 "object_id", id2, request, decode(block, 1, 'Blocking', 'Waiting') "block", ctime "secs" 
  from v\$lock 
 where block = 1 or request > 0
/

exit
EOF

echo 'ARCHIVE LOG AREA USAGE'
echo '======================'
echo ' '

df -g /oracle/GXP/oraarch

echo ' '
echo 'ALERT LOG FILE'
echo '=============='
echo ' '

tail -50 /oracle/GXP/diag/rdbms/gxp/GXP/trace/alert_GXP.log

sleep 60
done