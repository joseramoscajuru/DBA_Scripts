
###################################
#TUNING and Analysis
###################################
--Only Performance Statistics
--N.B Time in Hundred seconds!
col READ_TIME format 9999999999.99
col WRITE_TIME format 9999999999.99
col BYTES_READ format 99999999999999.99
col BYTES_WRITTEN  format 99999999999999.99
select name, STATE, group_number, TOTAL_MB, FREE_MB,READS, WRITES, READ_TIME,
 WRITE_TIME, BYTES_READ, BYTES_WRITTEN, REPAIR_TIMER,MOUNT_DATE
from v$asm_disk order by group_number, name;


--Check the Num of Extents in use per Disk inside one Disk Group.
select max(substr(name,1,30)) group_name, count(PXN_KFFXP) extents_per_disk,
DISK_KFFXP, GROUP_KFFXP from x$kffxp, v$ASM_DISKGROUP gr
where GROUP_KFFXP=&group_nr 
group by GROUP_KFFXP, DISK_KFFXP order by GROUP_KFFXP, DISK_KFFXP;


--Find The File distribution Between Disks
SELECT * FROM v$asm_alias  WHERE  name='PWX_DATA.272.669293645';

SELECT GROUP_KFFXP Group#,DISK_KFFXP Disk#,AU_KFFXP AU#,XNUM_KFFXP Extent#
FROM   X$KFFXP WHERE  number_kffxp=(SELECT file_number FROM v$asm_alias
WHERE name='PWX_DATA.272.669293645');

--or

SELECT GROUP_KFFXP Group#,DISK_KFFXP Disk#,AU_KFFXP AU#,XNUM_KFFXP Extent#
FROM X$KFFXP WHERE  number_kffxp=&DataFile_Number;

--or
select d.name, XV.GROUP_KFFXP Group#, XV.DISK_KFFXP Disk#,
XV.NUMBER_KFFXP File_Number, XV.AU_KFFXP AU#, XV.XNUM_KFFXP Extent#,
XV.ADDR, XV.INDX, XV.INST_ID, XV.COMPOUND_KFFXP, XV.INCARN_KFFXP,
XV.PXN_KFFXP, XV.XNUM_KFFXP,XV.LXN_KFFXP, XV.FLAGS_KFFXP,
XV.CHK_KFFXP, XV.SIZE_KFFXP from v$asm_disk d, X$KFFXP XV
where d.GROUP_NUMBER=XV.GROUP_KFFXP and d.DISK_NUMBER=XV.DISK_KFFXP
and number_kffxp=&File_NUM order by 2,3,4;


--List the hierarchical tree of files stored in the diskgroup
SELECT concat('+'||gname, sys_connect_by_path(aname, '/')) full_alias_path FROM
(SELECT g.name gname, a.parent_index pindex, a.name aname,
a.reference_index rindex FROM v$asm_alias a, v$asm_diskgroup g
WHERE a.group_number = g.group_number)
START WITH (mod(pindex, power(2, 24))) = 0
CONNECT BY PRIOR rindex = pindex;

################################################################