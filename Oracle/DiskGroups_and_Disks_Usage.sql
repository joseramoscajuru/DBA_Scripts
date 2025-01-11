 col disk# for 999
 col total_mb for 999999999
 col free_mb for 999999999
 col DiskName for a25
 col path for a25
 set pages 255
 set lines 1000
 compute sum of total_mb on DiskGroup  
 compute sum of free_mb on DiskGroup  
 break on DiskGroup skip 1 on report -  
   
 SELECT
      a.name DiskGroup,
      b.disk_number Disk#,
      b.name DiskName, 
     b.total_mb,
      b.free_mb, 
     b.path, 
     header_status
   from 
     v$asm_disk b,
      v$asm_diskgroup a  
 where 
     a.group_number (+) =b.group_number  
 order by 
     b.group_number,
      b.disk_number,
      b.name  
 /  