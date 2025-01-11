
Scripts for resize the data files in oracle
Resize query give us the output of space free at database level. How much space we released backup to Operating system from Oracle database files. It help us to shrink the size of database.

Resize query:

select /*+ rule */
a.tablespace_name,
a.file_name,
a.bytes/1024/1024 file_size_MB,
(b.maximum+c.blocks-1)*d.db_block_size/1024/1024 highwater
from dba_data_files a        ,
(select file_id,max(block_id) maximum       
from dba_extents       
group by file_id) b,
  dba_extents c,
     (select value db_block_size       
      from v$parameter       
      where name='db_block_size') d
where a.file_id=  b.file_id
and   c.file_id  = b.file_id
and   c.block_id = b.maximum
order by a.tablespace_name,a.file_name;

Resize query with total space released format:

set linesize 400
col tablespace_name format a15
col file_size format 99999
col file_name format a50
col hwm format 99999
col can_save format 99999
SELECT tablespace_name, file_name, file_size, hwm, file_size-hwm can_save
FROM (SELECT /*+ RULE */ ddf.tablespace_name, ddf.file_name file_name,
ddf.bytes/1048576 file_size,(ebf.maximum + de.blocks-1)*dbs.db_block_size/1048576 hwm
FROM dba_data_files ddf,(SELECT file_id, MAX(block_id) maximum FROM dba_extents GROUP BY file_id) ebf,dba_extents de,
(SELECT value db_block_size FROM v$parameter WHERE name='db_block_size') dbs
WHERE ddf.file_id = ebf.file_id
AND de.file_id = ebf.file_id
AND de.block_id = ebf.maximum
ORDER BY 1,2);

Resize query for data file in alter command format:

select 'alter database datafile'||' '''||file_name||''''||' resize '||round(highwater+2)||' '||'m'||';' from (
select /*+ rule */
   a.tablespace_name,
    a.file_name,
   a.bytes/1024/1024 file_size_MB,
    (b.maximum+c.blocks-1)*d.db_block_size/1024/1024 highwater
from dba_data_files a        ,
     (select file_id,max(block_id) maximum    
      from dba_extents       
      group by file_id) b,
      dba_extents c,
     (select value db_block_size       
      from v$parameter       
      where name='db_block_size') d
where a.file_id=  b.file_id
and   c.file_id  = b.file_id
and   c.block_id = b.maximum
order by a.tablespace_name,a.file_name);

