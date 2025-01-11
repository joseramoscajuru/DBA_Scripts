===========================================================================
Utilizao da TEMP e se est em Autoextend
===========================================================================
SET LINESIZE 300
SET PAGESIZE 1000
COLUMN file_name FORMAT a70
col TABLESPACE_NAME for a20
SELECT
  t.tablespace_name,f.file_name, f.file_id, AUTOEXTENSIBLE, bytes/1024/1024 total_mbytes,
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
  f.file_name
/