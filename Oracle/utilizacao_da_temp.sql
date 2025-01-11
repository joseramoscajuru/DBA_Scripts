set lines 300
col tablespace format a10
SELECT SysDate DIAH,
S.TableSpace_Name "TABLESPACE",
D.TBSPC_ALOC "Aloc_space",
(S.Total_Blocks*P.VALUE)/1024/1024 "TEMP_BLK_ALOC",
(S.Used_Blocks*P.VALUE)/1024/1024 "TEMP_BLK_USED",
(S.Free_Blocks*P.VALUE)/1024/1024 "TEMP_BLK_FREE"
FROM V$SORT_SEGMENT S, V$PARAMETER P,
(SELECT Tablespace_Name, Sum(Bytes/1024) TBSPC_ALOC
FROM DBA_DATA_FILES
GROUP BY Tablespace_Name
UNION
SELECT Tablespace_Name, Sum(Bytes/1024) TBSPC_ALOC
FROM DBA_TEMP_FILES
GROUP BY Tablespace_Name) D
WHERE S.Tablespace_Name = D.Tablespace_Name
AND P.NAME = 'db_block_size';
/

set echo off
set line 1000 pages 100 feed on serveroutput on define off verify off
col TNAME format a10
col file_name format a50
SELECT 
f.tablespace_name tname,
round(SUM(ROUND((f.bytes_free + f.bytes_used) / 1024 / 1024, 2)),0) allocated_mb,
round(SUM(ROUND(nvl(p.bytes_used, 0) / 1024 / 1024, 2)),0) Used_MB,
round(SUM(ROUND(((f.bytes_free + f.bytes_used) - nvl(p.bytes_used, 0)) / 1024 / 1024, 2)),0) Free_MB,
round((SUM(ROUND(nvl(p.bytes_used, 0) / 1024 / 1024, 2)) * 100) / (SUM(ROUND((f.bytes_free + f.bytes_used) / 1024 / 1024, 2))),2) "USED (%)",
(100-round((SUM(ROUND(nvl(p.bytes_used, 0)/1024/1024, 2)) * 100) / (SUM(ROUND((f.bytes_free + f.bytes_used)/1024/ 1024, 2))),2)) "FREE (%)",
round(SUM(maxbytes / 1024 / 1024),0) maxsize_mb,
d.file_name file_name
FROM 
sys.v_$temp_space_header f,
dba_temp_files d,
sys.v_$temp_extent_pool p
WHERE f.tablespace_name(+) = d.tablespace_name
AND f.file_id(+) = d.file_id
AND p.file_id(+) = d.file_id 
GROUP BY f.tablespace_name, file_name
ORDER BY 5 DESC
/