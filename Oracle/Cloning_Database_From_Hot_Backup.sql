Cloning Database From Hot Backup

To clone a db on another machine from hot backup, follow these steps:

1. Install Oracle server on new machine

2. Create directories, initfile, etc for the copy database on second server

3. Add database name to tnsnames.ora, listener.ora on second server

4. Create database service with ORADIM (if OS is Windows)

5. On original OPEN db:

ALTER DATABASE BACKUP CONTROL FILE TO TRACE RESETLOGS;

6. Rename trace file to create_control.sql, edited, contents are as follows:

STARTUP NOMOUNT
CREATE CONTROLFILE SET DATABASE "<SID>" RESETLOGS ARCHIVELOG
...
...
;

7. Then do:

ALTER SYSTEM ARCHIVE LOG CURRENT;

8. Copy the ORADATA dirctory including archived logs to second server

9. Go to second server, set SID, and use sqlplus to connect as SYSDBA

10. Delete the control files already copied over using OS commands

11. Run the CREATE CONTROL file script shown above

12. Issue:

RECOVER DATABASE USING BACKUP CONTROLFILE UNTIL CANCEL;

---------------------------------------------------------------------------------------------------

If you have 9i then use RMAN to create a duplicate the database.

Create the necessary folders, init.ora, password file, etc. I am using the DB_FILE_NAME_CONVERT and
LOG_FILE_NAME_CONVERT parameters in the init.ora file for the clone
database:

Example:

-- INIT.ORA NAME_CONVERT parameters.

db_file_name_convert = ('/DATA/ORACLE/ORADATA/HOMEBD', '/DATA/ORACLE/ORADATA/CLNE')
log_file_name_convert = ('/DATA/ORACLE/ORADATA/HOMEDB', '/DATA/ORACLE/ORADATA/CLNE')

Then use one of these RMAN scripts ( if you want or don't want to change the SID):

-- RMAN script with SET NEWNAME

run {
set newname for datafile 1 to '/data/oracle/oradata/clne/system01.dbf';
set newname for datafile 2 to '/data/oracle/oradata/clne/undotbs01.dbf';
set newname for datafile 3 to '/data/oracle/oradata/clne/cwmlite01.dbf';
set newname for datafile 4 to '/data/oracle/oradata/clne/drsys01.dbf';
set newname for datafile 5 to '/data/oracle/oradata/clne/example01.dbf';
set newname for datafile 6 to '/data/oracle/oradata/clne/indx01.dbf';
set newname for datafile 7 to '/data/oracle/oradata/clne/tools01.dbf';
set newname for datafile 8 to '/data/oracle/oradata/clne/users01.dbf';
set until logseq 18 thread 1;
allocate auxiliary channel d1 type disk;
duplicate target database to TEST
logfile '/data/oracle/oradata/clne/redo01.log' size 100M,
        '/data/oracle/oradata/clne/redo02.log' size 100M,
        '/data/oracle/oradata/clne/redo03.log' size 100M;
} 

- definir servidor destino
- ver file# e file_name na origem e alterar script
- ver tamanho redo logs na origem e alterar script ???
