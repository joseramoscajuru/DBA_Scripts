
###################################
#Create and Modify Disk Group
###################################

create diskgroup FRA1 external redundancy disk '/dev/vx/rdsk/oraASMdg/fra1'
ATTRIBUTE 'compatible.rdbms' = '11.1', 'compatible.asm' = '11.1';

alter diskgroup FRA1  check all;

--on +ASM2 :
alter diskgroup FRA1 mount;


--Add a second disk:
alter diskgroup FRA1 add disk '/dev/vx/rdsk/oraASMdg/fra2';


--Add several disks with a wildcard:
alter diskgroup FRA1 add disk '/dev/vx/rdsk/oraASMdg/fra*';


--Remove a disk from a diskgroup:
alter diskgroup FRA1 drop disk 'FRA1_0002';


--Drop the entire DiskGroup
drop diskgroup DATA1 including contents;

--How to DROP the entire DiskGroup when it is in NOMOUNT Status
--Generate the dd command which will reset the header of all the
--disks belong the GROUP_NUMBER=0!!!!
select 'dd if=/dev/zero of=''' ||PATH||''' bs=8192 count=100' from v$asm_disk
where GROUP_NUMBER=0;


select * from v$asm_operation;

---------------------------------------------------------------------------------------

alter diskgroup FRA1 drop disk 'FRA1_0002';
alter diskgroup FRA1 add disk '/dev/vx/rdsk/fra1dg/fra3';

alter diskgroup FRA1 drop disk 'FRA1_0003';
alter diskgroup FRA1 add disk '/dev/vx/rdsk/fra1dg/fra4';

--When a new diskgroup is created, it is only mounted on the local instance,
--and only the instance-specific entry for the asm_diskgroups parameter is updated.
--By manually mounting the diskgroup on other instances, the asm_diskgroups parameter
--on those instances are updated.

--on +ASM1 :
create diskgroup FRA1 external redundancy disk '/dev/vx/rdsk/fradg/fra1'
ATTRIBUTE 'compatible.rdbms' = '11.1', 'compatible.asm' = '11.1';

--on +ASM2 :
alter diskgroup FRA1 mount;


--It works even for on going balances!!!
alter diskgroup DATA1 rebalance power 10;
