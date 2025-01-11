Oracle RMAN Cloning
By Nazim On January 9, 2012 · Add Comment

Oracle Recovery Manager (RMAN), a command-line and Oracle Enterprise Manager-based tool, is the Oracle-preferred method for efficiently backing up and recovering an Oracle database.

Overview

    RMAN is a new feature introduced in 10g
    Recovery Manager designed to backup Oracle Database Files
    You can take advantage of the powerful Data Recovery Advisor feature, Which enables you to easily diagnose and repair data failures and corruption
    RMAN supports both cold and hot backup
    Does block level backup and recovery
    The RMAN online backup is easier to take than an online user-managed backup
    RMAN command language is platform independent
    The online backup doesn’t put the tablespace in “backup mode”, so extra redo logs are not generated
    Detailed reporting of backup operations
    Custom backup and recovery scripts easily and quickly
    RMAN can automatically delete unnecessary backup datafiles and archived redo log files on tape and disk
    Duplicate a database or create a standby database
    Recover database for test operation without restoring data
    If only a few data blocks are corrupted, then you can recover at the data block level, not entire datafile
    RMAN can use “active duplication” option
    RMAN automatically detects corrupt data blocks during backups

Advantages

    Incremental backups
    Simply usage of backup and recovery commands for manage.
    You can use “encrypted backups” option
    You can take “unused block compression” feature, so RMAN can skip unused data blocks during a backup
    It automatically manages the backup files without DBA intervention
    One repository for many databases
    More administrative tasks.

Configuration
Pre-requisite:
CATALOG INSTANCE
Database in Archive Mode
CLONING
At target database
Take online backup of target database using RMAN.
Configure and start listener service for target database.
At catalog database
Configure listener by using netca utility for catalog database and start the service.
At auxiliary clone database
1) Create one directory structure
mkdir auxdb

2) Create the initSID.ora to have the following entries

[oracle@panora05 ~]$ cd $ORACLE_HOME/dbs
[oracle@panora05 ~]$ vi initauxdb.ora
db_name=auxdb
instance_name=auxdb
compatible=10.2.0.1
undo_tablespace=undotbs1
control_files='/u01/oracle/auxdb/control01.ctl' ----------> File location before cloning
sga_max_size=500m
sga_target=400m
db_file_name_convert='/u01/oracle/prod','/u01/oracle/auxdb'
log_file_name_convert='/u01/oracle/prod','/u01/oracle/auxdb'

3) Configure two tns services for target and catalog database.
Configure two tns services using netca utility one for target database and one for your catalog database.
4) Start the database in nomount state
[oracle@panora05 admin]$ export ORACLE_SID=auxdb
[oracle@panora05 admin]$ sqlplus "/as sysdba"
SQL*Plus: Release 10.2.0.1.0 - Production on Mon Oct 3 10:03:21 2011
Copyright (c) 1982, 2005, Oracle.  All rights reserved.
Connected to an idle instance.
SQL&gt; startup nomount
ORACLE instance started.
Total System Global Area  524288000 bytes
Fixed Size                  1220384 bytes
Variable Size             226492640 bytes
Database Buffers          289406976 bytes
Redo Buffers                7168000 bytes
SQL&gt; exit
Disconnected from Oracle Database 10g Enterprise Edition Release 10.2.0.1.0 - Production
With the Partitioning, OLAP and Data Mining options

5) Login to RMAN and start the cloning
[oracle@panora05 ~]$rman target sys/manager@toprod catalog rman/rman@tocatalog auxiliary /
Recovery Manager: Release 10.2.0.1.0 - Production on Mon Oct 3 10:14:52 2011
Copyright (c) 1982, 2005, Oracle.  All rights reserved.

connected to target database: PROD (DBID=175064284)
connected to recovery catalog database
connected to auxiliary database: AUXDB (not mounted)
6) Now run following command –
 duplicate target DATABASE TO ‘auxdb’;
Starting Duplicate Db at 03-OCT-11
allocated channel: ORA_AUX_DISK_1
channel ORA_AUX_DISK_1: sid=36 devtype=DISK
contents OF Memory Script:
{
SET until scn  550170;
SET newname FOR datafile  1 TO "/u01/oracle/auxdb/system01.dbf";
SET newname FOR datafile  2 TO "/u01/oracle/auxdb/undotbs01.dbf";
SET newname FOR datafile  3 TO "/u01/oracle/auxdb/sysaux01.dbf";
SET newname FOR datafile  4 TO "/u01/oracle/auxdb/users01.dbf";
restore
CHECK readonly
clone DATABASE ;
}
executing Memory Script
executing command: SET until clause
executing command: SET NEWNAME
executing command: SET NEWNAME
executing command: SET NEWNAME
executing command: SET NEWNAME
Starting restore at 03-OCT-11
USING channel ORA_AUX_DISK_1
channel ORA_AUX_DISK_1: starting datafile backupset restore
channel ORA_AUX_DISK_1: specifying datafile(s) TO restore FROM backup SET
restoring datafile 00001 TO /u01/oracle/auxdb/system01.dbf
restoring datafile 00002 TO /u01/oracle/auxdb/undotbs01.dbf
restoring datafile 00003 TO /u01/oracle/auxdb/sysaux01.dbf
restoring datafile 00004 TO /u01/oracle/auxdb/users01.dbf
channel ORA_AUX_DISK_1: reading FROM backup piece /u01/oracle/fra/PROD/backupset/2011_10_03/o1_mf_nnndf_TAG20111003T101143_78lh8804_.bkp
channel ORA_AUX_DISK_1: restored backup piece 1
piece handle=/u01/oracle/fra/PROD/backupset/2011_10_03/o1_mf_nnndf_TAG20111003T101143_78lh8804_.bkp tag=TAG20111003T101143
channel ORA_AUX_DISK_1: restore complete, elapsed TIME: 00:00:26
Finished restore at 03-OCT-11
SQL statement:
CREATE CONTROLFILE REUSE SET DATABASE "AUXDB" RESETLOGS ARCHIVELOG
MAXLOGFILES     16
MAXLOGMEMBERS      3
MAXDATAFILES      100
MAXINSTANCES     8
MAXLOGHISTORY      292
LOGFILE
GROUP  1 ( '/u01/oracle/auxdb/redo01.log' ) SIZE 50 M  REUSE,
GROUP  2 ( '/u01/oracle/auxdb/redo02.log' ) SIZE 50 M  REUSE,
GROUP  3 ( '/u01/oracle/auxdb/redo03.log' ) SIZE 50 M  REUSE
DATAFILE '/u01/oracle/auxdb/system01.dbf'
CHARACTER SET WE8ISO8859P1
contents OF Memory Script:
{
switch clone datafile ALL;
}
executing Memory Script
released channel: ORA_AUX_DISK_1
datafile 2 switched TO datafile copy
INPUT datafile copy recid=1 stamp=763553748 filename=/u01/oracle/auxdb/undotbs01.dbf
datafile 3 switched TO datafile copy
INPUT datafile copy recid=2 stamp=763553748 filename=/u01/oracle/auxdb/sysaux01.dbf
datafile 4 switched TO datafile copy
INPUT datafile copy recid=3 stamp=763553748 filename=/u01/oracle/auxdb/users01.dbf
contents OF Memory Script:
{
SET until scn  550170;
recover
clone DATABASE
DELETE archivelog;
}
executing Memory Script
executing command: SET until clause
Starting recover at 03-OCT-11
allocated channel: ORA_AUX_DISK_1
channel ORA_AUX_DISK_1: sid=39 devtype=DISK
starting media recovery
archive log thread 1 SEQUENCE 2 IS already ON disk AS file /u01/oracle/fra/PROD/archivelog/2011_10_03/o1_mf_1_2_78lh92ok_.arc
archive log filename=/u01/oracle/fra/PROD/archivelog/2011_10_03/o1_mf_1_2_78lh92ok_.arc thread=1 SEQUENCE=2
media recovery complete, elapsed TIME: 00:00:02
Finished recover at 03-OCT-11
contents OF Memory Script:
{
shutdown clone;
startup clone nomount ;
}
executing Memory Script
DATABASE dismounted
Oracle instance shut down
connected TO auxiliary DATABASE (NOT started)
Oracle instance started
Total System Global Area     524288000 bytes
Fixed SIZE                     1220384 bytes
Variable SIZE                226492640 bytes
DATABASE Buffers             289406976 bytes
Redo Buffers                   7168000 bytes
SQL statement: CREATE CONTROLFILE REUSE SET DATABASE "AUXDB" RESETLOGS ARCHIVELOG
MAXLOGFILES     16
MAXLOGMEMBERS      3
MAXDATAFILES      100
MAXINSTANCES     8
MAXLOGHISTORY      292
LOGFILE
GROUP  1 ( '/u01/oracle/auxdb/redo01.log' ) SIZE 50 M  REUSE,
GROUP  2 ( '/u01/oracle/auxdb/redo02.log' ) SIZE 50 M  REUSE,
GROUP  3 ( '/u01/oracle/auxdb/redo03.log' ) SIZE 50 M  REUSE
DATAFILE '/u01/oracle/auxdb/system01.dbf'
CHARACTER SET WE8ISO8859P1
contents OF Memory Script:
{
SET newname FOR tempfile  1 TO "/u01/oracle/auxdb/temp01.dbf";
switch clone tempfile ALL;
catalog clone datafilecopy  "/u01/oracle/auxdb/undotbs01.dbf";
catalog clone datafilecopy  "/u01/oracle/auxdb/sysaux01.dbf";
catalog clone datafilecopy  "/u01/oracle/auxdb/users01.dbf";
switch clone datafile ALL;
}
executing Memory Script
executing command: SET NEWNAME
renamed TEMPORARY file 1 TO /u01/oracle/auxdb/temp01.dbf IN control file
cataloged datafile copy
datafile copy filename=/u01/oracle/auxdb/undotbs01.dbf recid=1 stamp=763553756
cataloged datafile copy
datafile copy filename=/u01/oracle/auxdb/sysaux01.dbf recid=2 stamp=763553756
cataloged datafile copy
datafile copy filename=/u01/oracle/auxdb/users01.dbf recid=3 stamp=763553756
datafile 2 switched TO datafile copy
INPUT datafile copy recid=1 stamp=763553756 filename=/u01/oracle/auxdb/undotbs01.dbf
datafile 3 switched TO datafile copy
INPUT datafile copy recid=2 stamp=763553756 filename=/u01/oracle/auxdb/sysaux01.dbf
datafile 4 switched TO datafile copy
INPUT datafile copy recid=3 stamp=763553756 filename=/u01/oracle/auxdb/users01.dbf
contents OF Memory Script:
{
ALTER clone DATABASE OPEN resetlogs;
}
executing Memory Script
DATABASE opened
Finished Duplicate Db at 03-OCT-11