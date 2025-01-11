View

V$ASM_ALIAS
V$ASM_CLIENT
V$ASM_DISK
V$ASM_DISKGROUP
V$ASM_FILE
V$ASM_OPERATION
V$ASM_TEMPLATE

select * from v$flash_recovery_area_usage;

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

### ASM Commands

lsdg
lsct 
alter diskgroup <name> mount; --> Mount Disk Group.
alter diskgroup <name> mount normal/restricted;


### Check for status

set lines 120
set pages 1000

col MOUNT_STATUS format a15
col PATH format a30
col HEADER_STATUS format a15
col MODE_STATUS format a10
col state format a10

select DISK_NUMBER,MOUNT_STATUS,HEADER_STATUS,MODE_STATUS,STATE,PATH FROM V$ASM_DISK; 


########################################
set lines 120
set pages 1000

col MOUNT_STATUS format a15
col PATH format a30
col name format a30
col state format a10

select GROUP_NUMBER,
DISK_NUMBER,
MOUNT_STATUS, 
STATE, 
NAME, 
PATH 
from v$asm_disk
order by name; 


### Check for free space in the ASM Disks 

set lines 255
col path for a35
col Diskgroup for a15
col DiskName for a20
col disk# for 999
col total_mb for 999,999,999
col free_mb for 999,999,999
compute sum of total_mb on DiskGroup
compute sum of free_mb on DiskGroup
break on DiskGroup skip 1 on report -

set pages 255

select a.name DiskGroup, b.disk_number Disk#, b.name DiskName, b.total_mb, b.free_mb, b.path, b.header_status
from v$asm_disk b, v$asm_diskgroup a
where a.group_number (+) =b.group_number
order by b.group_number, b.disk_number, b.name
/

set lines 122
set pages 66


### Listing disks

set lines 120
set pages 1000

col MOUNT_STATUS format a15
col PATH format a30
col name format a30
col state format a10

select GROUP_NUMBER,
DISK_NUMBER,
MOUNT_STATUS, 
STATE, 
NAME, 
PATH 
from v$asm_disk
order by name;

################

uss1udb009amprb:[POHDSSS1] /home/oracle -> cat asm_list_disks.sh
#!/bin/ksh
for i in `/etc/init.d/oracleasm listdisks`
do
   v_asmdisk=`/etc/init.d/oracleasm querydisk -d $i | awk  '{print $2}'`
   v_minor=`/etc/init.d/oracleasm querydisk -d $i | awk -F[ '{print $2}'| awk -F] '{print $1}' | awk '{print $1}'`
   v_major=`/etc/init.d/oracleasm querydisk -d $i | awk -F[ '{print $2}'| awk -F] '{print $1}' | awk '{print $2}'`
   v_device=`ls -la /dev | grep $v_minor | grep $v_major | awk '{print $10}'`

   echo "ASM disk $v_asmdisk based on /dev/$v_device  [$v_minor $v_major]"

done


################


uss1udb009amprb:[POHDSSS1] /home/oracle -> cat asm_copy_from.sh
#!/usr/bin/ksh
###############################################################################
# Filename: asm_copy_from.sh
# Location: /home/oracle/scripts
# Author  : Arthur Urbano
# Project : Copy ASM datafiles to local disk
# Overview: This purpose of this script is to perform a copy of datafiles from
#           ASM disks to a local disk.
#           Run mannualy --
# History : Original release 21-Jun-2010
################################################################################

export ORACLE_SID=+ASM3
export ORACLE_BASE=/usr/app/oracle
export ORA_NLS33=/usr/app/oracle/product/11.1.0/ocommon/nls/admin/data
export ORACLE_HOME=/usr/app/ASM/product/11.1.0

export LOCAL_DISK=/ora/backup/POHDSSS/asm_copy

export ARQ_LIST=$1
export LOG_NAME=`echo $ARQ_LIST|cut -d. -f1`
export LOG_FILE=/home/oracle/$LOG_NAME.log

touch $LOG_FILE

for var_list_files in `cat $ARQ_LIST`
do
   DT_INI=`date +'%d-%b-%Y %H:%M'`
   DTF_NAME=`echo $var_list_files|cut -d/ -f4`

asmcmd <<END
      cp $var_list_files $LOCAL_DISK/$DTF_NAME

END

   DT_END=`date +'%d-%b-%Y %H:%M'`

   echo "File Copied -> $DTF_NAME - started -> $DT_INI - completed -> $DT_END" >> $LOG_FILE


done


uss1udb009amprb:[POHDSSS1] /home/oracle -> cat asm_file_list_01.txt
+DATA/pohdsss/datafile/beta_load_history_aug2008.800.717125665
+DATA/pohdsss/datafile/beta_load_history_aug2008.729.717125549
+DATA/pohdsss/datafile/beta_load_history_aug2009.803.717126021


#########################3

set wrap off
set lines 120
set pages 999

col "Group Name"   form a25
col "Disk Name"    form a30
col "State"  form a15
col "Type"  form a7
col "Free GB"   form 9,999

prompt
prompt ASM Disk Groups
prompt ===============

select group_number  "Group"
,      name          "Group Name"
,      state         "State"
,      type          "Type"
,      total_mb/1024 "Total GB"
,      free_mb/1024  "Free GB"
from   v$asm_diskgroup
/

 

prompt
prompt ASM Disks
prompt =========

col "Group"          form 999
col "Disk"           form 999
col "Header"         form a9
col "Mode"           form a8
col "Redundancy"     form a10
col "Failure Group"  form a20
col "Path"           form a40
col "Disk Name"      form a20
 

select group_number  "Group"
,      disk_number   "Disk"
,      header_status "Header"
,      mode_status   "Mode"
,      state         "State"
,      redundancy    "Redundancy"
,      total_mb      "Total MB"
,      free_mb       "Free MB"
,      name          "Disk Name"
,      failgroup     "Failure Group"
,      path          "Path"
from   v$asm_disk
order by group_number
,        disk_number
/


prompt
prompt Instances currently accessing these diskgroups
prompt ==============================================

col "Instance" form a8
select c.group_number  "Group"
,      g.name          "Group Name"
,      c.instance_name "Instance"
from   v$asm_client c
,      v$asm_diskgroup g
where  g.group_number=c.group_number
/

 

prompt
prompt Current ASM disk operations
prompt ===========================
select *
from   v$asm_operation
/

 

prompt
prompt free ASM disks and their paths
prompt ===========================
select header_status , mode_status, path from V$asm_disk
where header_status in ('FORMER','CANDIDATE')
/

####################

/etc/init.d/oracleasm createdisk DATA_0004 /dev/mapper/vasm05p1
/etc/init.d/oracleasm createdisk DATA_0005 /dev/mapper/vasm06p1
/etc/init.d/oracleasm createdisk DATA_0006 /dev/mapper/vasm07p1
/etc/init.d/oracleasm createdisk DATA_0007 /dev/mapper/vasm08p1
/etc/init.d/oracleasm createdisk DATA_0008 /dev/mapper/vasm09p1
/etc/init.d/oracleasm createdisk DATA_0009 /dev/mapper/vasm10p1 
3:49:42 PM?/etc/init.d/oracleasm scandisks (em todos os nodes) 
3:49:45 PM?tudo como root 
3:55:04 PM?depois como oracle 
3:55:06 PM?ALTER DISKGROUP DATA ADD
DISK '/dev/mapper/vasm05p1';


Thanks Eric!

Arthur,

The new partitions for ASM are highlighted below in Blue.

bash-3.2$ ls -l /dev/mapper | grep vasm | grep p
brw-rw---- 1 oracle oinstall 253, 36 Jul 18 17:47 vasm01p1
brw-rw---- 1 oracle oinstall 253, 18 Jul 18 17:47 vasm02p1
brw-rw---- 1 oracle oinstall 253, 17 Jul 18 17:47 vasm03p1
brw-rw---- 1 oracle oinstall 253, 26 Jul 18 17:47 vasm04p1
brw-rw---- 1 oracle oinstall 253, 43 Jul 18 17:35 vasm05p1
brw-rw---- 1 oracle oinstall 253, 58 Jul 18 17:35 vasm06p1
brw-rw---- 1 oracle oinstall 253, 46 Jul 18 17:35 vasm07p1
brw-rw---- 1 oracle oinstall 253, 60 Jul 18 17:35 vasm08p1
brw-rw---- 1 oracle oinstall 253, 47 Jul 18 17:35 vasm09p1
brw-rw---- 1 oracle oinstall 253, 62 Jul 18 17:35 vasm10p1
brw-rw---- 1 oracle oinstall 253, 50 Jul 18 17:35 vasm11p1
brw-rw---- 1 oracle oinstall 253, 64 Jul 18 17:35 vasm12p1
brw-rw---- 1 oracle oinstall 253, 51 Jul 18 17:35 vasm13p1
brw-rw---- 1 oracle oinstall 253, 65 Jul 18 17:35 vasm14p1
brw-rw---- 1 oracle oinstall 253, 53 Jul 18 17:35 vasm15p1
brw-rw---- 1 oracle oinstall 253, 67 Jul 18 17:35 vasm16p1
brw-rw---- 1 oracle oinstall 253, 34 Jul 18 17:47 vasm51p1
brw-rw---- 1 oracle oinstall 253, 19 Jul 18 17:47 vasm52p1

us97udb010amprb:[DONBP1L1] /home/oracle -> ./dba_asm_list_disks.sh
ASM disk "DATA_0004" based on /dev/mapper/vasm05p1  [253, 43]
ASM disk "DATA_0005" based on /dev/mapper/vasm06p1  [253, 58]
ASM disk "DATA_0006" based on /dev/mapper/vasm07p1  [253, 46]
ASM disk "DATA_0007" based on /dev/mapper/vasm08p1  [253, 60]
ASM disk "DATA_0008" based on /dev/mapper/vasm09p1  [253, 47]
ASM disk "DATA_0009" based on /dev/mapper/vasm10p1  [253, 62]
us97udb010amprb:[DONBP1L1] /home/oracle ->

DISK_NUMBER MOUNT_STATUS    HEADER_STATUS   MODE_STATU STATE      PATH
----------- --------------- --------------- ---------- ---------- ------------------------------
          0 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/ora010binvg-asm_vol
          1 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/vvoting2p1
         36 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/vasm05
         34 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/vasm07
         32 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/vasm09
         30 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/vasm11
         29 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/vasm11p1
         28 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/vasm13
         27 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/vasm13p1
         26 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/vasm15
         25 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/vasm15p1
         24 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/vasm06
         22 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/vasm08
          2 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/vasm16p1
          3 CLOSED          FOREIGN         ONLINE     NORMAL     /dev/mapper/vvoting1p1
          4 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/vasm16
          5 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/vvoting2
          6 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/vasm01
          7 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/vvoting1
          8 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/vasm51
          9 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/vasm14p1
         10 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/vasm04
         11 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/vvoting3p1
         12 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/vasm14
         13 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/vasm12p1
         14 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/vasm12
         15 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/vvoting3
         16 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/vasm52
         17 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/vasm02
         18 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/vasm03
         20 CLOSED          CANDIDATE       ONLINE     NORMAL     /dev/mapper/vasm10
          0 CACHED          MEMBER          ONLINE     NORMAL     /dev/mapper/vasm01p1
          0 CACHED          MEMBER          ONLINE     NORMAL     /dev/mapper/vasm51p1
          3 CACHED          MEMBER          ONLINE     NORMAL     /dev/mapper/vasm04p1
          1 CACHED          MEMBER          ONLINE     NORMAL     /dev/mapper/vasm52p1
          1 CACHED          MEMBER          ONLINE     NORMAL     /dev/mapper/vasm02p1
          2 CACHED          MEMBER          ONLINE     NORMAL     /dev/mapper/vasm03p1
          9 CACHED          MEMBER          ONLINE     NORMAL     /dev/mapper/vasm10p1
          7 CACHED          MEMBER          ONLINE     NORMAL     /dev/mapper/vasm08p1
          5 CACHED          MEMBER          ONLINE     NORMAL     /dev/mapper/vasm06p1
          8 CACHED          MEMBER          ONLINE     NORMAL     /dev/mapper/vasm09p1
          6 CACHED          MEMBER          ONLINE     NORMAL     /dev/mapper/vasm07p1
          4 CACHED          MEMBER          ONLINE     NORMAL     /dev/mapper/vasm05p1

43 rows selected.


Group Disk Header    Mode     State      Redundancy   Total MB    Free MB Disk Name  Failure Gr Path
----- ---- --------- -------- ---------- ---------- ---------- ---------- ---------- ---------- ----------------------------------------
    0    0 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/ora010binvg-asm_vol
    0    1 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vvoting2p1
    0    2 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vasm16p1
    0    3 FOREIGN   ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vvoting1p1
    0    4 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vasm16
    0    5 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vvoting2
    0    6 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vasm01
    0    7 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vvoting1
    0    8 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vasm51
    0    9 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vasm14p1
    0   10 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vasm04
    0   11 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vvoting3p1
    0   12 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vasm14
    0   13 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vasm12p1
    0   14 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vasm12
    0   15 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vvoting3
    0   16 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vasm52
    0   17 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vasm02
    0   18 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vasm03
    0   20 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vasm10
    0   22 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vasm08
    0   24 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vasm06
    0   25 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vasm15p1
    0   26 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vasm15
    0   27 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vasm13p1
    0   28 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vasm13
    0   29 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vasm11p1
    0   30 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vasm11
    0   32 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vasm09
    0   34 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vasm07
    0   36 CANDIDATE ONLINE   NORMAL     UNKNOWN             0          0                       /dev/mapper/vasm05
    1    0 MEMBER    ONLINE   NORMAL     UNKNOWN         32767      11303 DATA_0000  DATA_0000  /dev/mapper/vasm01p1
    1    1 MEMBER    ONLINE   NORMAL     UNKNOWN         32767      11303 DATA_0001  DATA_0001  /dev/mapper/vasm02p1
    1    2 MEMBER    ONLINE   NORMAL     UNKNOWN         32767      11281 DATA_0002  DATA_0002  /dev/mapper/vasm03p1
    1    3 MEMBER    ONLINE   NORMAL     UNKNOWN         32767      11290 DATA_0003  DATA_0003  /dev/mapper/vasm04p1
    1    4 MEMBER    ONLINE   NORMAL     UNKNOWN         32767      11299 DATA_0004  DATA_0004  /dev/mapper/vasm05p1
    1    5 MEMBER    ONLINE   NORMAL     UNKNOWN         32767      11324 DATA_0005  DATA_0005  /dev/mapper/vasm06p1
    1    6 MEMBER    ONLINE   NORMAL     UNKNOWN         32767      11284 DATA_0006  DATA_0006  /dev/mapper/vasm07p1
    1    7 MEMBER    ONLINE   NORMAL     UNKNOWN         32767      11283 DATA_0007  DATA_0007  /dev/mapper/vasm08p1
    1    8 MEMBER    ONLINE   NORMAL     UNKNOWN         32767      11289 DATA_0008  DATA_0008  /dev/mapper/vasm09p1
    1    9 MEMBER    ONLINE   NORMAL     UNKNOWN         32767      11283 DATA_0009  DATA_0009  /dev/mapper/vasm10p1
    2    0 MEMBER    ONLINE   NORMAL     UNKNOWN          8191       5479 FLASH_0000 FLASH_0000 /dev/mapper/vasm51p1
    2    1 MEMBER    ONLINE   NORMAL     UNKNOWN          8191       5469 FLASH_0001 FLASH_0001 /dev/mapper/vasm52p1

