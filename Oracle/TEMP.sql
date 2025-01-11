# Find out the all the sessions that are not active and have an entry in V$sort_usage.
You can do it by,

SELECT b.tablespace,b.segfile#,b.segblk#,b.blocks,a.sid,a.serial#,
a.username,a.osuser, a.status
FROM v$session a,v$sort_usage b
WHERE a.saddr = b.session_addr;


# Criar temporary tablespace
CREATE TEMPORARY TABLESPACE "TEMP" TEMPFILE
  EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1048576

alter temporary tablespace temp2 EXTENT MANAGEMENT LOCAL UNIFORM SIZE 131072;
alter temporary tablespace temp2 minimum extent 131072;

select dbms_metadata.get_ddl('TABLESPACE','TEMP2') from dual;

# Alterar extent
  CREATE TEMPORARY TABLESPACE TEMP TEMPFILE
  '/oradata1/COSP2/temp2_01t.dbf' SIZE 12582912000 REUSE 
  EXTENT MANAGEMENT LOCAL UNIFORM SIZE 16777216

alter database default temporary tablespace TEMP;

drop tablespace temp2 including contents and datafiles;

  CREATE TEMPORARY TABLESPACE TEMP2 TEMPFILE
  '/oradata1/COSP2/temp2_01.dbf' SIZE 12582912000 REUSE ,
  '/oradata2/COSP2/temp2_02.dbf' SIZE 10485760000 REUSE ,
  '/oradata3/COSP2/temp2_03.dbf' SIZE 10485760000 REUSE ,
  '/oradata4/COSP2/temp2_04.dbf' SIZE 8388608000 REUSE
  EXTENT MANAGEMENT LOCAL UNIFORM SIZE 131072

alter database default temporary tablespace TEMP2;

drop tablespace temp including contents and datafiles;

