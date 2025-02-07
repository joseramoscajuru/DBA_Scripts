
set linesize 132
set pagesize 999
col instance            for a8
col software_version    for a20
col compatible_version  for a20
col diskgroup_name      for a15
select
  vac.db_name,
  vac.instance_name "INSTANCE",
  vad.name "DISKGROUP_NAME",
  vac.status,
  vac.software_version,
  vac.compatible_version
from
  v$asm_client vac,
  v$asm_diskgroup vad
where 1=1
and vac.group_number = vad.group_number
order by 1,2,3;

DB_NAME  INSTANCE DISKGROUP_NAME  STATUS       SOFTWARE_VERSION     COMPATIBLE_VERSION
-------- -------- --------------- ------------ -------------------- --------------------
DBPSTHST DBPSTHST DG_ARC          CONNECTED    12.2.0.1.0           11.2.0.4.0
DBPSTHST DBPSTHST DG_DATA         CONNECTED    12.2.0.1.0           11.2.0.4.0
DBPSTHST DBPSTHST DG_DATA2        CONNECTED    12.2.0.1.0           11.2.0.4.0
DBPSTHST DBPSTHST DG_P2K_DATA     CONNECTED    12.2.0.1.0           11.2.0.4.0
DBPSTHST DBPSTHST DG_PST_DATA     CONNECTED    12.2.0.1.0           11.2.0.4.0
