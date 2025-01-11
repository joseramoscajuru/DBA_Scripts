#This command may remove a TEMP segment, try:

alter tablespace <TBS_NAME> coalesce 

#The following query will display coalesce information:

SELECT
    tablespace_name,
    bytes_coalesced,
    extents_coalesced,
    percent_extents_coalesced,
    blocks_coalesced,
    percent_blocks_coalesced
FROM 
    sys.dba_free_space_coalesced
ORDER BY 
    tablespace_name;

############## MONITORAR QUEM ESTA CONSUMINDO A TEMP ########################################

SELECT b.TABLESPACE,
          ROUND(((b.blocks * p.VALUE) / 1024 / 1024), 2) used_size_mb,
          a.SID,
          a.serial#,
          a.username,
          a.osuser,
          a.program,
          a.status,
          s.SQL_TEXT
         FROM v$session a, v$sort_usage b, v$process c, v$parameter p,
V$SQL S
        WHERE p.NAME = 'db_block_size'
          AND a.saddr = b.session_addr
          AND a.paddr = c.addr
          AND a.sql_id = s.SQL_ID
     ORDER BY b.TABLESPACE, b.segfile#, b.segblk#, b.blocks;*