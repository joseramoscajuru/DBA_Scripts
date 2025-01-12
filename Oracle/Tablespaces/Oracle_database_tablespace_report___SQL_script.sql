Oracle database tablespace report – SQL script

In this article I’ll share a SQL script that I probably use most often. The SQL will show Oracle database tablespace information. Many Oracle DBAs and developers use GUI tools nowadays and me also, but sometimes you need to see some extras. The SQL script will list Oracle database tablespaces including tablespace status and type, counts of files and segments per tablespace and the most important – display proper tablespace sizes.

UPDATE [Jun-2016]: the script is entirely rewritten to version 2.0

– New [2.0]: Tablespace (TS) type is extended to display UNIFORM / System Extend Management and ASSM
– New [2.0]: Display actual used space in UNDO and TEMP tablespaces (not HWM as before)
– New [2.0]: Runtime is considerably reduced
– New [2.0]: Compatible with OEM CC 12c/13c output
– Tested on Oracle database 10g, 11g, 12c
– Column: “Max Size” – maximum possible size of a tablespace as a result of Autoextention of database files
– Column: “TS Type” (Tablespace type):
-> LM/DM – Local/Dictionary Managed
-> SYS/UNI – SYStem/UNIform Extent Management (LM only)
-> ASSM/MSSM – Automatic/Manual Segment Space Management (ASSM -> LM only)


set pagesize 10000 linesize 300 tab off
 
col tablespace_name format A22              heading "Tablespace"
col ts_type         format A13              heading "TS Type"
col segments        format 999999           heading "Segments"
col files           format 9999
col allocated_mb    format 9,999,990.000    heading "Allocated Size|(Mb)"
col used_mb         format 9,999,990.000    heading "Used Space|(Mb)"
col Free_mb         format 999,990.000      heading "Free Space|(Mb)"
col used_pct        format 999              heading "Used|%"
col max_ext_mb      format 99,999,990.000   heading "Max Size|(Mb)"
col max_free_mb     format 9,999,990.000    heading "Max Free|(Mb)"
col max_used_pct    format 999              heading "Max Used|(%)"
 
BREAK ON REPORT
COMPUTE SUM LABEL "TOTAL SUM ==========>" AVG LABEL "AVERAGE   ==========>" OF segments files allocated_mb used_mb Free_MB max_ext_mb ON REPORT
 
WITH df AS (SELECT tablespace_name, SUM(bytes) bytes, COUNT(*) cnt, DECODE(SUM(DECODE(autoextensible,'NO',0,1)), 0, 'NO', 'YES') autoext, sum(DECODE(maxbytes,0,bytes,maxbytes)) maxbytes FROM dba_data_files GROUP BY tablespace_name), 
     tf AS (SELECT tablespace_name, SUM(bytes) bytes, COUNT(*) cnt, DECODE(SUM(DECODE(autoextensible,'NO',0,1)), 0, 'NO', 'YES') autoext, sum(DECODE(maxbytes,0,bytes,maxbytes)) maxbytes FROM dba_temp_files GROUP BY tablespace_name), 
     tm AS (SELECT tablespace_name, used_percent FROM dba_tablespace_usage_metrics),
     ts AS (SELECT tablespace_name, COUNT(*) segcnt FROM dba_segments GROUP BY tablespace_name)
SELECT d.tablespace_name, 
       d.status,
       DECODE(d.contents,'PERMANENT',DECODE(d.extent_management,'LOCAL','LM','DM'),'TEMPORARY','TEMP',d.contents)||'-'||DECODE(d.allocation_type,'UNIFORM','UNI','SYS')||'-'||decode(d.segment_space_management,'AUTO','ASSM','MSSM') ts_type,
       a.cnt files,  
       NVL(s.segcnt,0) segments,
       ROUND(NVL(a.bytes / 1024 / 1024, 0), 3) Allocated_MB, 
       ROUND(NVL(a.bytes - NVL(f.bytes, 0), 0)/1024/1024,3) Used_MB, 
       ROUND(NVL(f.bytes, 0) / 1024 / 1024, 3) Free_MB, 
       ROUND(NVL((a.bytes - NVL(f.bytes, 0)) / a.bytes * 100, 0), 2) Used_pct, 
       ROUND(a.maxbytes / 1024 / 1024, 3)  max_ext_mb,
       ROUND(NVL(m.used_percent,0), 2) Max_used_pct
  FROM dba_tablespaces d, df a, tm m, ts s, (SELECT tablespace_name, SUM(bytes) bytes FROM dba_free_space GROUP BY tablespace_name) f 
 WHERE d.tablespace_name = a.tablespace_name(+) 
   AND d.tablespace_name = f.tablespace_name(+) 
   AND d.tablespace_name = m.tablespace_name(+) 
   AND d.tablespace_name = s.tablespace_name(+)
   AND NOT d.contents = 'UNDO'
   AND NOT ( d.extent_management = 'LOCAL' AND d.contents = 'TEMPORARY' ) 
UNION ALL
-- TEMP TS
SELECT d.tablespace_name, 
       d.status, 
       DECODE(d.contents,'PERMANENT',DECODE(d.extent_management,'LOCAL','LM','DM'),'TEMPORARY','TEMP',d.contents)||'-'||DECODE(d.allocation_type,'UNIFORM','UNI','SYS')||'-'||decode(d.segment_space_management,'AUTO','ASSM','MSSM') ts_type, 
       a.cnt, 
       0,
       ROUND(NVL(a.bytes / 1024 / 1024, 0), 3) Allocated_MB, 
       ROUND(NVL(t.ub*d.block_size, 0)/1024/1024, 3) Used_MB, 
       ROUND((NVL(a.bytes ,0)/1024/1024 - NVL((t.ub*d.block_size), 0)/1024/1024), 3) Free_MB,
       ROUND(NVL((t.ub*d.block_size) / a.bytes * 100, 0), 2) Used_pct,
       ROUND(a.maxbytes / 1024 / 1024, 3)  max_size_mb, 
       ROUND(NVL(m.used_percent,0), 2) Max_used_pct
  FROM dba_tablespaces d, tf a, tm m, (SELECT ss.tablespace_name , sum(ss.used_blocks) ub FROM gv$sort_segment ss GROUP BY ss.tablespace_name) t 
 WHERE d.tablespace_name = a.tablespace_name(+) 
   AND d.tablespace_name = t.tablespace_name(+) 
   AND d.tablespace_name = m.tablespace_name(+) 
   AND d.extent_management = 'LOCAL'
   AND d.contents = 'TEMPORARY'  
UNION ALL
-- UNDO TS
SELECT d.tablespace_name, 
       d.status, 
       DECODE(d.contents,'PERMANENT',DECODE(d.extent_management,'LOCAL','LM','DM'),'TEMPORARY','TEMP',d.contents)||'-'||DECODE(d.allocation_type,'UNIFORM','UNI','SYS')||'-'||decode(d.segment_space_management,'AUTO','ASSM','MSSM') ts_type, 
       a.cnt, 
       NVL(s.segcnt,0) segments,
       ROUND(NVL(a.bytes / 1024 / 1024, 0), 3) Allocated_MB, 
       ROUND(NVL(u.bytes, 0) / 1024 / 1024, 3) Used_MB, 
       ROUND(NVL(a.bytes - NVL(u.bytes, 0), 0)/1024/1024, 3) Free_MB,
       ROUND(NVL(u.bytes / a.bytes * 100, 0), 2) Used_pct, 
       ROUND(a.maxbytes / 1024 / 1024, 3)  max_size_mb,
       ROUND(NVL(m.used_percent,0), 2) Max_used_pct
FROM dba_tablespaces d, df a, tm m, ts s, (SELECT tablespace_name, SUM(bytes) bytes FROM dba_undo_extents where status in ('ACTIVE','UNEXPIRED') GROUP BY tablespace_name) u 
WHERE d.tablespace_name = a.tablespace_name(+) 
AND d.tablespace_name = u.tablespace_name(+) 
AND d.tablespace_name = m.tablespace_name(+) 
AND d.tablespace_name = s.tablespace_name(+)
AND d.contents = 'UNDO'
ORDER BY 1 
/
 
prompt * Tablespace (TS) types: 
prompt .  - LM/DM     - Local/Dictionary Managed 
prompt .  - SYS/UNI   - SYStem/UNIform Extent Management (LM only)
prompt .  - ASSM/MSSM - Automatic/Manual Segment Space Management (ASSM -> LM only)