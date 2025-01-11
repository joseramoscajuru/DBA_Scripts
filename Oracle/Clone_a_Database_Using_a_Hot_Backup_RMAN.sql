 Clone a Database Using a Hot Backup RMAN
Clone a Database Using a Hot Backup

    A) Take a hot backup of the SOURCE Instance

    To quickly take a hot backup , Refer to : Script-to-create-Script-to-take-Hot-Backup-of-Database

    B) Prepare the TARGET

    SHUTDOWN the target DATABASE and LISTENER
    Take backup and Remove the TARGET ORACLE_HOME and database

    C) Use tar to copy the ORACLE_HOME and the database (from the hot backup) to the TARGET system to replace the target system.

    On the Source : Create the tar files

    tar -cvf /tmp/ohome.tar <ORACLE_HOME location>
    tar -cvf /tmp/dbbkp.tar <Database Hot backup location>


    Copy or scp the tar files

    scp /tmp/ohome.tar oracle@192.168.2.131:/tmp/ohome.tar
    scp /tmp/dbbkp.tar oracle@192.168.2.131:/tmp/dbbkp.tar


    On the Target Intance :

    create the directories for the ORACLE_HOME and datafiles if it does not exist
    Extract the tar files

    cd <ORACLE_HOME location>
    tar -xvf /tmp/ohome.tar

    cd <datafile location>
    tar -xvf /tmp/dbbkp.tar



ON the TARGET

1 Login as target user user and Verify .profile and *.env file under $ORACLE_HOME
Make sure that the environment is set for the Target System.

cd $ORACLE_HOME
pwd

2 Check all oracle related file systems for user and group ownership

cd <TARGET file systems>
ls -l

Check user and group ownership : It should be proper


3 Modify the entries in the tnsnames.ora and listener.ora to have the Listner for the target instance

eg : My listener.ora - where target is dev
==================================

dev =
(ADDRESS_LIST =
(ADDRESS= (PROTOCOL= IPC)(KEY= EXTPROCdev))
(ADDRESS= (PROTOCOL= TCP)(Host= dbalounge)(Port= 1525))
)

SID_LIST_dev =
(SID_LIST =
(SID_DESC =
(ORACLE_HOME= /u03/oracle/devdb/10.2.0)
(SID_NAME = dev)
)
(SID_DESC =
(SID_NAME = PLSExtProc)
(ORACLE_HOME = /u03/oracle/devdb/10.2.0)
(PROGRAM = extproc)
)
)

STARTUP_WAIT_TIME_dev = 0
CONNECT_TIMEOUT_dev = 10
TRACE_LEVEL_dev = OFF

LOG_DIRECTORY_dev = /u03/oracle/devdb/10.2.0/network/admin
LOG_FILE_dev = dev
TRACE_DIRECTORY_dev = /u03/oracle/devdb/10.2.0/network/admin
TRACE_FILE_dev = dev
ADMIN_RESTRICTIONS_dev = OFF


eg : My TNS entry - where target is dev
==================================

dev=
(DESCRIPTION=
(ADDRESS=(PROTOCOL=tcp)(HOST=DBALOUNGE.com)(PORT=1 525))
(CONNECT_DATA=
(SERVICE_NAME=dev)
(INSTANCE_NAME=dev)
)
)


4 In config.c, make sure the entries are pointing to target .

cd $ORACLE_HOME/rdbms/lib
ls -ltr config*
vi config.c
Take care of Group. It should be the group the target user belongs to :
#define SS_DBA_GRP "dbTARGET"
#define SS_OPER_GRP "dbTARGET"



5 Move config.o

cd $ORACLE_HOME/rdbms/lib
mv config.o config.o.old_18jul10


6 If this is RAC to NON-RAC Refresh, relink Oracle with rac_off

cd $ORACLE_HOME/rdbms/lib
make -f ins_rdbms.mk rac_off

If this step did not fail with fatal errors, proceed with :
make -f ins_rdbms.mk ioracle


7 Relink all the executables.

cd $ORACLE_HOME/bin
./relink all

8 Verify the Timestamp
ls -l $ORACLE_HOME/bin/oracle



9 Verify that you can run sqlplus “/ as sysdba” without prompting for any password.

sqlplus "/ as sysdba"
connected to idle instance


10 Set the init.ora paramters and create the destination directory location
To see the directories to be created and corresponding parameters to be modified, Refer to :
Create-a-Database-Manually-using-Create-Database-Script

11 Prepare the Control file script from the trace bacup taken on production.

vi TARGET_control.sql

a) ? Consider the resetlog portion of this script . Delete the noresetlogs section of the script.

b)? Old Entry - CREATE CONTROLFILE REUSE DATABASE "SOURCE" NORESETLOGS ARCHIVELOG FORCE LOGGING

? New Entry - CREATE CONTROLFILE REUSE SET DATABASE "SOURCE" RESETLOGS ARCHIVELOG

c) Change the location of Datafiles to point to the Target,
Replace all occurances of : SOURCE replaced by TARGET
Replace all occurances of : SOURCE replaced by TARGET

d) Remove the TEMP file entries ( keep a safe copy, for later use).
Keep a safe backup of Temporary creation part and redo logfile creation statements.
After this , you can remove all lines after characterset and semicolon.

e) Inspect the control file script
The number of Datafiles should match that in the source.
select count(*) from v$datafile at the source.

Similarily, number of copied Datafiles at the Target should match the definition in the script.

Example – of what you will be left with in TARGET_control.sql
STARTUP NOMOUNT;
CREATE CONTROLFILE REUSE SET DATABASE "TARGET" RESETLOGS ARCHIVELOG
MAXLOGFILES 32
MAXLOGMEMBERS 5
MAXDATAFILES 1024
MAXINSTANCES 8
MAXLOGHISTORY 1361
LOGFILE
GROUP 1 (
'/TARGET/..../log01a.dbf',
'/TARGET/..../log01b.dbf'
) SIZE 200M,
GROUP 2 (
'/TARGET/..../log02a.dbf',
'/TARGET/..../log02b.dbf'
) SIZE 200M,
GROUP 3 (
'/TARGET/..../log03a.dbf',
'/TARGET/..../log03b.dbf'
) SIZE 200M,
….
DATAFILE
'/TARGET/..../system01.dbf',
'/TARGET/..../system02.dbf',
……….
……….. (representing other datafiles)

CHARACTER SET UTF8
;


12 Create the Controlfile

$sqlplus "/ as sysdba"
@TARGET_control.sql

13 See archive log mode

SQL>ARCHIVE LOG LIST
Should show automatic archiving “Enabled” and “Archivelog” Mode

14 Recover the database

SQL> recover database using backup controlfile until cancel;

Enter the archive file location, when prompted.

Use the following query on SOURCE to get the list of archives needed to be recovered -
select THREAD#, SEQUENCE# from v$log_history where &1 between FIRST_CHANGE# and NEXT_CHANGE#;

Here – For the value for $1 to be given will come from the sequence returned by the command – “recover database using backup controlfile until cancel;” which you have given on TARGET


15 Open the DB with resetlogs
SQL> alter database open resetlogs;

When the DB opens, check for any missing files or files needed for recovery

SQL> select * from v$recover_file;
SQL> select * from v$datafile where name like '%MISS%';
Should not return any rows for these queries.

16 Shutdown the Database

17 Check for the Default Temporary file –

select * from database_properties where property_name = 'DEFAULT_TEMP_TABLESPACE';

Confirm that this TEMP.
If the default is not TEMP,
SQL>alter database default temporary tablespace TEMP

18. Create the Temp datafiles , using the commands taken from the control file.

ALTER TABLESPACE TEMP ADD TEMPFILE __________

Example - The commands will be similar to below
ALTER TABLESPACE TEMP ADD TEMPFILE '/TARGET/..../temp20.dbf'
SIZE 134217728 REUSE AUTOEXTEND ON NEXT 52428800 MAXSIZE 1800M;
ALTER TABLESPACE TEMP ADD TEMPFILE '/TARGET/..../temp19.dbf'
SIZE 134217728 REUSE AUTOEXTEND ON NEXT 52428800 MAXSIZE 1800M;
ALTER TABLESPACE TEMP ADD TEMPFILE '/TARGET/..../temp18.dbf'
SIZE 134217728 REUSE AUTOEXTEND ON NEXT 52428800 MAXSIZE 1800M;
ALTER TABLESPACE TEMP ADD TEMPFILE '/TARGET/..../temp17.dbf'
SIZE 134217728 REUSE AUTOEXTEND ON NEXT 52428800 MAXSIZE 1800M;

Verify dba_temp_files, for all the temp file entries added to TEMP

SQL> select file_name from dba_temp_files;

19 Update global_name

select * from global_name;
update global_name set global_name='TARGET.ORACLEOUTSOURCING.COM';
commit;

SQL> select * from global_name;

GLOBAL_NAME
--------------------------------------------------------------------------------
TARGET


Different Approach As Per Oracle Documentation.

    Assumptions:

    Hot backups of the production server are there, including binary backup of controlfiles.

    Production Database Name: orcl
    Cloned Database Name: pub

    --Create pfile from the production servers spfile.

    SQL> create pfile='/u01/initpub.ora' from spfile;

    -- Make appropriate folder structures.

    [oracle@canada ~]$ mkdir -p /u01/app/oracle/admin/pub/adump
    [oracle@canada ~]$ mkdir -p /u01/app/oracle/oradata/pub
    [oracle@canada ~]$ mkdir -p /u01/app/oracle/flash_recovery_area/pub
    [oracle@canada ~]$ mkdir -p /u01/app/oracle/flash_recovery_area/PUB/archivelog


    -- Edit the initpub.ora file and change the location of all the files for
    -- the "pub" database.

    Also add the following parameters to the pfile:

    DB_UNIQUE_NAME=pub

    -- above parameter is necessary if database is created on the same machine.

    DB_FILE_NAME_CONVERT=(/u01/app/oracle/oradata/orcl/,/u01/app/oracle/oradata/pub/)

    -- above parameter is necessary if database is created on the same machine,
    -- or if the directory structure is different.

    LOG_FILE_NAME_CONVERT=(/u01/app/oracle/oradata/orcl/,/u01/app/oracle/oradata/pub/)

    -- above parameter is mandatory.

    LOG_ARCHIVE_DEST_1 = 'LOCATION=/u01/app/oracle/flash_recovery_area/PUB/archivelog/'

    Sample Pfile


    pub.__db_cache_size=62914560
    pub.__java_pool_size=4194304
    pub.__large_pool_size=4194304
    pub.__oracle_base='/u01/app/oracle'#ORACLE_BASE set from environment
    pub.__pga_aggregate_target=113246208
    pub.__sga_target=150994944
    pub.__shared_io_pool_size=0
    pub.__shared_pool_size=75497472
    pub.__streams_pool_size=0
    *.audit_file_dest='/u01/app/oracle/admin/pub/adump'
    *.audit_trail='db'
    *.compatible='11.2.0.0.0'
    *.control_files='/u01/app/oracle/oradata/pub/control01.ctl',
    '/u01/app/oracle/flash_recovery_area/pub/control02.ctl'
    *.db_block_size=8192
    *.db_domain=''
    *.db_name='orcl'
    *.db_recovery_file_dest='/u01/app/oracle/flash_recovery_area'
    *.db_recovery_file_dest_size=4039114752
    *.diagnostic_dest='/u01/app/oracle'
    *.dispatchers='(PROTOCOL=TCP) (SERVICE=pubXDB)'
    *.log_archive_format='%t_%s_%r.dbf'
    *.memory_target=262144000
    *.open_cursors=300
    *.processes=150
    *.remote_login_passwordfile='EXCLUSIVE'
    *.undo_tablespace='UNDOTBS1'
    DB_UNIQUE_NAME=pub
    DB_FILE_NAME_CONVERT=(/u01/app/oracle/oradata/orcl/,/u01/app/oracle/oradata/pub/)
    LOG_FILE_NAME_CONVERT=(/u01/app/oracle/oradata/orcl/,/u01/app/oracle/oradata/pub/)
    LOG_ARCHIVE_DEST_1 = 'LOCATION=/u01/app/oracle/flash_recovery_area/PUB/archivelog/'

    --Copy the backup datafiles, archived log files, and control files to folders created
    --earlier.


    [oracle@canada ~]$ export ORACLE_SID=pub
    [oracle@canada ~]$ sqlplus

    SQL*Plus: Release 11.2.0.1.0 Production on Thu Feb 16 19:02:27 2012

    Copyright (c) 1982, 2009, Oracle. All rights reserved.

    Enter user-name: / as sysdba
    Connected to an idle instance.

    SQL> startup nomount pfile='/u01/initpub.ora';
    ORACLE instance started.

    Total System Global Area 263639040 bytes
    Fixed Size 1335892 bytes
    Variable Size 197135788 bytes
    Database Buffers 62914560 bytes
    Redo Buffers 2252800 bytes

    SQL> alter database mount clone database;

    Database altered.

    SQL> set pagesize 100
    SQL> set linesize 130
    SQL> select name,file#,status from v$datafile;

    NAME FILE# STATUS
    ------------------------------ ---------- -------
    /u01/app/oracle/oradata/pub/sy 1 SYSOFF
    stem01.dbf

    /u01/app/oracle/oradata/pub/sy 2 OFFLINE
    saux01.dbf

    /u01/app/oracle/oradata/pub/un 3 OFFLINE
    dotbs01.dbf

    /u01/app/oracle/oradata/pub/us 4 OFFLINE
    ers01.dbf


    SQL> alter database datafile 1 online;

    Database altered.

    SQL> alter database datafile 2 online;

    Database altered.

    SQL> alter database datafile 3 online;

    Database altered.

    SQL> alter database datafile 4 online;

    Database altered.


    SQL> select name,file#,status from v$datafile;

    NAME FILE# STATUS
    -------------------------------------------------- ---------- -------
    /u01/app/oracle/oradata/pub/system01.dbf 1 SYSTEM
    /u01/app/oracle/oradata/pub/sysaux01.dbf 2 ONLINE
    /u01/app/oracle/oradata/pub/undotbs01.dbf 3 ONLINE
    /u01/app/oracle/oradata/pub/users01.dbf 4 ONLINE


    SQL>recover database until cancel using backup controlfile;

    --manually apply all the suggested archived log files and finish
    --the incomplete recovery.

    SQL>alter database open resetlogs; 