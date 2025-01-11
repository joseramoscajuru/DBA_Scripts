


==================
analise_disco.sh
==================

cd /dev

ls -ltr /dev/r$1 >> /home/oracle/ibmdba/scripts/ls_ltr_disk.txt
lsattr -E -l $1 | grep reserve >>  /home/oracle/ibmdba/scripts/reserve_policy_no_reserve.txt
lsattr -E -l $1 | grep pvid >>  /home/oracle/ibmdba/scripts/pvid_none.txt
lspv | grep $1  >>  /home/oracle/ibmdba/scripts/lspv_none_None.txt

cd /home/oracle/ibmdba/scripts

./analise_disco.sh asmdsk046_24C5


OK - Verificar permissionamento e ownership dos discos (esta em /home/oracle/analise_disco.sh)

        chown oracle:dba /dev/rhdisn  ===> ESTA COMO oracle:asmadmin
        chmod 660 /dev/rhdiskn


[dpdb012dr +ASM /dev]$ ls -al /dev/rhdiskasm_0227
crw-rw----    1 grid19   oinstall     13, 30 Apr 26 12:31 /dev/rhdiskasm_0227
[dpdb012dr +ASM /dev]$ ls -al /dev/rhdiskasm_0228
crw-rw----    1 grid19   oinstall     13, 31 Apr 27 11:28 /dev/rhdiskasm_0228


OK - Checar se reserve_policy está como no_reserve. (esta em /home/oracle/analise_disco.sh)
        lsattr -E -l hdiskXXX | grep reserve (deve aparecer: reserve_policy no_reserve)
        exemplo:
        lsattr -E -l hdisk345 | grep reserve >  /tmp/reserve_policy_no_reserve.txt


[dpdb012dr +ASM /dev]$ lsattr -E -l hdiskasm_0227| grep reserve
reserve_policy  no_reserve                                          Reserve Policy                   True+
[dpdb012dr +ASM /dev]$ lsattr -E -l hdiskasm_0228| grep reserve
reserve_policy  no_reserve                                          Reserve Policy                   True+


OK - Checar se pvid está como none (esta em /home/oracle/analise_disco.sh)
        lsattr -E -l hdiskXXX | grep pvid (deve aparecer: pvid none)
        exemplo: lsattr -E -l hdisk345 | grep pvid >  /tmp/pvid_none.txt


[dpdb012dr +ASM /dev]$ lsattr -E -l hdiskasm_0227| grep pvid
pvid            none                                                Physical volume identifier       False
[dpdb012dr +ASM /dev]$ lsattr -E -l hdiskasm_0228| grep pvid
pvid            none                                                Physical volume identifier       False



OK - Verificar se os discos nao estao atrelados a VG ou GPFS (esta em /home/oracle/analise_disco.sh)
        lspv |grep hdiskxx (deve aparecer: hdisk... none None)

exemplo: lspv | grep  hdisk345  >  /tmp/lspv_none_None.txt


[dpdb012dr +ASM /dev]$ lspv |grep hdiskasm_0227
hdiskasm_0227   none                                hdiskasm_0227   locked      
[dpdb012dr +ASM /dev]$ lspv |grep hdiskasm_0228
hdiskasm_0228   none                                hdiskasm_0228   locked      



- Verificar se os discos disponibilizados estao reconhecidos pelo ASM
        select * from v$asm_disk ;  (os discos disponiveis aparecerao como CANDIDATED)


set line 1000
set pages 5000
col "Group" format 999
col "Disk" format 999
col "Disk Name" format a30
col "Header" format a15
col "Mode" format a8
col "Redundancy" format a10
col "Failure Group" format a20
col "Path" format a45
select group_number "Group", 
disk_number "Disk", 
header_status "Header", 
mode_status "Mode", 
state "State",
name "Disk Name",
path "Path"
from v$asm_disk
where header_status in ('CANDIDATE','FORMER')
order by path;


Group Disk Header          Mode     State    Disk Name                      Path
----- ---- --------------- -------- -------- ------------------------------ ---------------------------------------------
    0    1 CANDIDATE       ONLINE   NORMAL                                  /dev/rhdiskasm_0227
    0    0 CANDIDATE       ONLINE   NORMAL                                  /dev/rhdiskasm_0228


- Verificar nível de redundância do DiskGroup (External, Normal, High)


select group_number,
name,
state,
type,
total_mb/1024,
free_mb/1024,
free_mb/total_mb*100 "%Livre"
from v$asm_diskgroup;


GROUP_NUMBER NAME                           STATE       TYPE   TOTAL_MB/1024 FREE_MB/1024     %Livre
------------ ------------------------------ ----------- ------ ------------- ------------ ----------
           1 DG_MSAFRJ_ARC                  MOUNTED     EXTERN          1000   960.429688 96.0429688
           2 DG_MSAFRJ_DATA                 MOUNTED     EXTERN         10500   702.984375 6.69508929


. Adicionar os discos no ASM (COM O USUARIO grid11)

OK -- TESTAR DISCOS CRIANDO DISKGROUP TESTE_DISK

create diskgroup TESTE_DISK EXTERNAL REDUNDANCY 
DISK '/dev/rhdiskasm_0227',
	 '/dev/rhdiskasm_0228';


- check new created disk group:

set lines 1000
select group_number,
name,
state,
type,
total_mb/1024,
free_mb/1024
--free_mb/total_mb*100 "%Livre"
from v$asm_diskgroup;


GROUP_NUMBER NAME                           STATE       TYPE   TOTAL_MB/1024 FREE_MB/1024--FREE_MB/TOTAL_MB*100"%LIVRE"
------------ ------------------------------ ----------- ------ ------------- ------------------------------------------
           1 DG_MSAFRJ_ARC                  MOUNTED     EXTERN          1000                                 960.429688
           2 DG_MSAFRJ_DATA                 MOUNTED     EXTERN         10500                                 702.984375
           3 TESTE_DISK                     MOUNTED     EXTERN          1000                                 999.933594


SQL> DROP DISKGROUP TESTE_DISK;

Diskgroup dropped.



-- VERIFICAR ESTADO DOS DISCOS (deve aparecer como FORMER)
        select * from   v$asm_disk ;
        (está former)

set line 1000
set pages 5000
col "Group" format 999
col "Disk" format 999
col "Disk Name" format a30
col "Header" format a15
col "Mode" format a8
col "Redundancy" format a10
col "Failure Group" format a20
col "Path" format a45
select group_number "Group", 
disk_number "Disk", 
header_status "Header", 
mode_status "Mode", 
state "State",
name "Disk Name",
path "Path"
from v$asm_disk
where header_status='FORMER'
order by path;


Group Disk Header          Mode     State    Disk Name                      Path
----- ---- --------------- -------- -------- ------------------------------ ---------------------------------------------
    0    1 FORMER          ONLINE   NORMAL                                  /dev/rhdiskasm_0227
    0    0 FORMER          ONLINE   NORMAL                                  /dev/rhdiskasm_0228


ALTER DISKGROUP DG_MSAFRJ_DATA 
ADD DISK '/dev/rhdiskasm_0227',
         '/dev/rhdiskasm_0228'
REBALANCE POWER 8;

Diskgroup altered.


-- CHECAR O FIM DO REBALANCE

SELECT * FROM v$ASM_OPERATION;


GROUP_NUMBER NAME                           STATE       TYPE   TOTAL_MB/1024 FREE_MB/1024--FREE_MB/TOTAL_MB*100"%LIVRE"
------------ ------------------------------ ----------- ------ ------------- ------------------------------------------
           1 DG_MSAFRJ_ARC                  MOUNTED     EXTERN          1000                                 960.429688
           2 DG_MSAFRJ_DATA                 MOUNTED     EXTERN         11500                                 1702.96094
