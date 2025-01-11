actual undo size

SELECT SUM(a.bytes)/1024/1024 "UNDO_SIZE"
  FROM v$datafile a,
  v$tablespace b,
  dba_tablespaces c
  WHERE c.contents = 'UNDO'
  AND c.status = 'ONLINE'
  AND b.name = c.tablespace_name
  AND a.ts# = b.ts#
/

 UNDO_SIZE
----------
     75060

set lines 1000 pages 200
col name format a60
 SELECT b.name, a.name, a.bytes/1024/1024/1024 size_GB, d.maxbytes/1024/1024/1024 MaxGB, d.AUTOEXTENSIBLE
  FROM v$datafile a,
  v$tablespace b,
  dba_tablespaces c,
  dba_data_files d
  WHERE c.contents = 'UNDO'
  AND c.status = 'ONLINE'
  AND b.name = c.tablespace_name
  AND a.ts# = b.ts#
  AND d.file_id = a.file#
 order by b.name
/


undo blocks per second

SELECT MAX(undoblks/((end_time-begin_time)*3600*24))
      "UNDO_BLOCK_PER_SEC"
  FROM v$undostat;   2    3  

UNDO_BLOCK_PER_SEC
------------------
        2350.84667

ACTUAL UNDO SIZE [MByte] UNDO RETENTION [Sec]                                                        OPTIMAL UNDO RETENTION [Sec]
------------------------ --------------------------------------------------------------------------- ----------------------------
                   75060 4087                                                                                                4087

SELECT d.undo_size/(1024*1024) "ACTUAL UNDO SIZE [MByte]",
       SUBSTR(e.value,1,25) "UNDO RETENTION [Sec]",
       (TO_NUMBER(e.value) * TO_NUMBER(f.value) *
       g.undo_block_per_sec) / (1024*1024)
       "NEEDED UNDO SIZE [MByte]"
  FROM (
       SELECT SUM(a.bytes) undo_size
         FROM v$datafile a,
              v$tablespace b,
              dba_tablespaces c
        WHERE c.contents = 'UNDO'
          AND c.status = 'ONLINE'
          AND b.name = c.tablespace_name
          AND a.ts# = b.ts#
       ) d,
       v$parameter e,
       v$parameter f,
       (
       SELECT MAX(undoblks/((end_time-begin_time)*3600*24))
          undo_block_per_sec
         FROM v$undostat
       ) g
 WHERE e.name = 'undo_retention'
  AND f.name = 'db_block_size'
/


