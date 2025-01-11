===========================================================================
Utilizao dos datafiles da TEMP
===========================================================================
set echo off
set line 1000 pages 100 feed on serveroutput on define off verify off

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


########## Curso #########
SET LINESIZE 120
SET PAGESIZE 1000
COLUMN file_name FORMAT a50
SELECT
  t.tablespace_name,f.file_name, bytes/1024/1024 total_mbytes,
  (f.bytes-NVL(u.blocks,0)*t.block_size)/1024/1024 avail_mbytes
FROM
  dba_tablespaces t, dba_temp_files f,
  (SELECT SUM(s.blocks) blocks, s.segrfno#
    FROM v$tempseg_usage s
    GROUP BY s.segrfno#
  ) u
WHERE
  t.tablespace_name = f.tablespace_name AND
  f.file_id = u.segrfno# (+)
ORDER BY
  t.tablespace_name,
  f.file_name;