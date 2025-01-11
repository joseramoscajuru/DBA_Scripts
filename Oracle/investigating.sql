select tablespace_name,STATUS,count(*),ceil(sum(bytes/1024/1024)) MB_SZ from dba_undo_extents group by tablespace_name,status;

TABLESPACE_NAME STATUS COUNT(*) MB_SZ
------------------------------ --------- ---------- ----------
UNDOTBS1 UNEXPIRED 1814 1504
UNDOTBS1 EXPIRED 706 493

select ceil(sum(RSSIZE)/1024/1024) "UNDO Current Used Size (MB)" from v$rollstat a;

UNDO Current Used Size (MB)
---------------------------
1397

select (sum(c.bytes)/1024/1024) "UNDO Tblspce Total Size (MB)" from dba_tablespaces b , dba_data_files c
where b.tablespace_name = c.tablespace_name and b.contents = 'UNDO' ;

UNDO Tblspce Total Size (MB)
----------------------------
2000

Tablespace Size (MB) Free (MB) % Free % Used
------------------------------ ---------- ---------- ---------- ----------
UNDOTBS1 2000 3 0 100 

===========================================================================================================================================================

This sql suggests the optimal value of the undo retention based on the size of the Undo Tablespace and undo traffic 

SELECT us.undo_size/(1024*1024) "ACTUAL UNDO SIZE in Megs",SUBSTR(param1.value,1,25) "UNDO RETENTION in Sec", 
       ROUND((us.undo_size / (to_number(param2.value) * g.undo_block_per_sec))) "OPTIMAL UNDO RETENTION in Sec" 
FROM ( SELECT SUM(df.bytes) undo_size 
       FROM v$datafile df,v$tablespace ts,dba_tablespaces tbs 
       WHERE tbs.contents = 'UNDO'  AND tbs.status = 'ONLINE'   AND ts.name = tbs.tablespace_name 
       AND df.ts# = ts.ts#) us,v$parameter param1,v$parameter param2, 
     ( SELECT MAX(undoblks/((end_time-begin_time)*3600*24)) undo_block_per_sec 
       FROM v$undostat ) g 
WHERE param1.name = 'undo_retention' AND param2.name = 'db_block_size';

This sql suggests the optimal size of the undo tablespace based on the value of the Undo Retention and undo traffic 

SELECT sz.undo_size/(1024*1024) "ACTUAL UNDO SIZE in Megs",SUBSTR(param1.value,1,25) "UNDO RETENTION in Sec", 
       (TO_NUMBER(param1.value) * TO_NUMBER(param2.value) * us.undo_block_per_sec) / (1024*1024)"NEEDED UNDO SIZE in Megs" 
FROM  (SELECT SUM(df.bytes) undo_size 
       FROM v$datafile df,v$tablespace tbs1,dba_tablespaces tbs2 
       WHERE tbs2.contents = 'UNDO' AND tbs2.status = 'ONLINE' AND tbs1.name = tbs2.tablespace_name 
       AND df.ts# = tbs1.ts# )sz,v$parameter param1,v$parameter param2, 
      (SELECT MAX(undoblks/((end_time-begin_time)*3600*24)) undo_block_per_sec 
       FROM v$undostat ) us
WHERE param1.name = 'undo_retention'  AND param2.name = 'db_block_size';
