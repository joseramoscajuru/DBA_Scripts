
Check disks present in disk groups

set lines 1000 pages 200
col path format a30
-- SELECT SUBSTR(dg.name,1,16) AS diskgroup, SUBSTR(d.name,1,16) AS asmdisk, d.path,
SELECT dg.name AS diskgroup, d.name AS asmdisk, d.path,
d.mount_status, d.state, d.failgroup AS failgroup
FROM V$ASM_DISKGROUP dg, V$ASM_DISK d WHERE dg.group_number = d.group_number
and dg.name='&dg';

--Quering ASM Disk Groups
set lines 1000
col name format a25
col DATABASE_COMPATIBILITY format a10
col COMPATIBILITY format a10
select * from v$asm_diskgroup;
--or
select name, state, type, total_mb, free_mb from v$asm_diskgroup;

--Quering ASM Disks
col PATH format a45
col name format a25
set lines 1000 pages 300
select name, path, group_number, TOTAL_MB, FREE_MB, READS, WRITES, READ_TIME,
WRITE_TIME from v$asm_disk order by 3,1;
--or
col PATH format a45
col name format a25
col header_status format a20
set lines 1000 pages 300
select name, path, mount_status, header_status, mode_status, group_number,
os_mb, total_mb, free_mb
from v$asm_disk
where header_status in ('CANDIDATE','FORMER')
order by 4;
order by 1,3;


col PATH format a50
col HEADER_STATUS  format a12
col name format a25
--select INCARNATION,
select name, path, MOUNT_STATUS,HEADER_STATUS, MODE_STATUS, STATE, group_number,
OS_MB, TOTAL_MB, FREE_MB, READS,
--WRITES, READ_TIME, WRITE_TIME, BYTES_READ,
--BYTES_WRITTEN, REPAIR_TIMER,
--MOUNT_DATE, CREATE_DATE
from v$asm_disk;

set lines 1000 pages 500
col PATH format a50
col HEADER_STATUS  format a12
col name format a25
select name, path, MOUNT_STATUS,HEADER_STATUS, MODE_STATUS, group_number,
OS_MB, TOTAL_MB, FREE_MB
from v$asm_disk;