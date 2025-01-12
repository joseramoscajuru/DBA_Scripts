###ENVIADO POR ARTHUR, TESTAR E ENTENDER.
set lines 180
set pages 200
break   on report
compute sum of bytes on report
compute sum of used on report
compute sum of free on report

col name format a35
col bytes format 9,999,999,999,999
col maxbytes format 9,999,999,999,999
col used format 9,999,999,999,999
col free format 9,999,999,999,999
col "% Used" format 999.99
col "% Used Max" format 999.99

select a.tablespace_name                                              name,
       sum(b.bytes)/count( distinct a.file_id||'.'||a.block_id )      bytes,
       sum(b.bytes)/count( distinct a.file_id||'.'||a.block_id ) - sum(a.bytes)/count( distinct b.file_id ) used,
       sum(b.maxbytes)/count( distinct a.file_id||'.'||a.block_id )      maxbytes,
       sum(a.bytes)/count( distinct b.file_id )                       free,
       100 * ( (sum(b.bytes)/count( distinct a.file_id||'.'||a.block_id )) - (sum(a.bytes)/count( distinct b.file_id ) )) / 
	                (sum(b.bytes)/count( distinct a.file_id||'.'||a.block_id )) "% Used",
	   100 * decode((sum(b.maxbytes)/count( distinct a.file_id||'.'||a.block_id )),
	                0,(sum(b.bytes)/count( distinct a.file_id||'.'||a.block_id ) - sum(a.bytes)/count( distinct b.file_id ))/
					(sum(b.bytes)/count( distinct a.file_id||'.'||a.block_id )),(sum(b.bytes)/count( distinct a.file_id||'.'||a.block_id ) - 
					sum(a.bytes)/count( distinct b.file_id ))/(sum(b.maxbytes)/count( distinct a.file_id||'.'||a.block_id ))) "% Used Max"
from dba_free_space a, dba_data_files b
where a.tablespace_name (+) = b.tablespace_name
group by a.tablespace_name, b.tablespace_name
order by a.tablespace_name;

generates tablespace usage trend/growth.

SET MARKUP HTML ON ENTMAP ON SPOOL ON PREFORMAT OFF; 
set linesize 125 
set numwidth 20 
set pagesize 50 
COL NAME FOR A30 
col SNAP_ID for 9999999 
set serveroutput off; 
SPOOL TBS_TREND.xls; 
set verify off; 
set echo off;

SELECT 
distinct DHSS.SNAP_ID,VTS.NAME, 
TO_CHAR(DHSS.END_INTERVAL_TIME, 'DD-MM HH:MI') AS SNAP_Time, 
ROUND((DHTS.TABLESPACE_USEDSIZE*8192)/1024/1024)/&&max_instance_num AS USED_MB, 
ROUND((DHTS.TABLESPACE_SIZE*8192)/1024/1024)/&&max_instance_num AS SIZE_MB 
FROM DBA_HIST_TBSPC_SPACE_USAGE DHTS,V$TABLESPACE VTS,DBA_HIST_SNAPSHOT DHSS 
WHERE VTS.TS#=DHTS.TABLESPACE_ID 
AND DHTS.SNAP_ID=DHSS.SNAP_ID 
AND DHSS.INSTANCE_NUMBER=1 
AND TABLESPACE_ID=&id 
ORDER BY 1; 
SPOOL OFF;