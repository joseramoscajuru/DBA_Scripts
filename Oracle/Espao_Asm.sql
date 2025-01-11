
col total_mb for 9999999999
select  name,type,
                total_mb/1024 "Total_GB",
                free_mb/1024 "Free_GB",
--                ROUND(100 * NVL(free_mb,0) / total_mb, 2) percent_empty,
                100 - (ROUND(100 * NVL(free_mb,0) / total_mb, 2)) percent_full
from v$asm_diskgroup 
order by name;



lsdg

==========================================================================================
Monitor space used in ASM Disk Groups

SET LINESIZE  145
SET PAGESIZE  9999
SET VERIFY    off
COLUMN group_name             FORMAT a20           HEAD 'Disk Group|Name'
COLUMN sector_size            FORMAT 99,999        HEAD 'Sector|Size'
COLUMN block_size             FORMAT 99,999        HEAD 'Block|Size'
COLUMN allocation_unit_size   FORMAT 999,999,999   HEAD 'Allocation|Unit Size'
COLUMN state                  FORMAT a11           HEAD 'State'
COLUMN type                   FORMAT a6            HEAD 'Type'
COLUMN total_mb               FORMAT 999,999,999   HEAD 'Total Size (MB)'
COLUMN used_mb                FORMAT 999,999,999   HEAD 'Used Size (MB)'
COLUMN pct_used               FORMAT 999.99        HEAD 'Pct. Used'


break on report on disk_group_name skip 1
compute sum label "Grand Total: " of total_mb used_mb on report


SELECT
    name                                     group_name
  , sector_size                              sector_size
  , block_size                               block_size
  , allocation_unit_size                     allocation_unit_size
  , state                                    state
  , type                                     type
  , total_mb                                 total_mb
  , (total_mb - free_mb)                     used_mb
  , ROUND((1- (free_mb / total_mb))*100, 2)  pct_used
FROM
    v$asm_diskgroup
ORDER BY
    name
/
===============================================================================================


set pages 999 lines 1000
col "GROUP_NUMBER" for 9
col "NAME" for a20
col "% Used"
select GROUP_NUMBER,
NAME,
TOTAL_MB,
FREE_MB,
USABLE_FILE_MB,
100 - floor(FREE_MB/TOTAL_MB*100) "% Used"
from v$asm_diskgroup where upper(name)=upper('&GroupName');







