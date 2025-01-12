ACE  Database Health Check

Oracle dba must run this HC every time before SHUTDOWN and after STARTUP for all databases except for FIN91PRD (ussbyapsprd04 server) and FIN91RPT (ussbyapsprd05 server). For both databases we have an additional step that MUST be executed by Unix team before SHUTDOWN and STARTUP task.

Unix Team task:
1-) Place in FREEZE all Veritas service groups for FIN91PRD and FIN91RPT databases:
For all changes in ussbyapsprd04 or ussbyapsprd05 server, related to the STOP/START database, this task MUST be added and assigned to UNIX team.
 

Oracle DBA Team tasks:
1-) Set Oracle environment:
. oraenv
fin91trn

2-) Check all listeners running into the server:
ps -ef|grep lsnr

e.g:
$ ps -ef|grep lsnr
  oracle  /u01/app/oracle/product/11.2.0.2/Db_1/bin/tnslsnr LISTENER inherit

2.1-) For each listener, check the status and save in a .log file:
lsnrctl status LISTENER

3-)  Check Oracle services to identify what user have started the Oracle database:
ps ef|grep pmon

e.g:
$ ps -ef|grep pmon
  oracle  6846     1   0   Apr 20 ?           4:38 ora_pmon_fin91dmo
  oracle  8537     1   0   Apr 20 ?           4:03 ora_pmon_fin91cfg
  oracle  7456     1   0   Apr 20 ?           4:43 ora_pmon_fin91dev
  oracle  9634     1   0   Apr 20 ?           4:16 ora_pmon_fin91trn
  oracle 21349     1   0   Apr 21 ?          3:28 ora_pmon_fin91tst

4-) Check for errors in Oracle alert.log file
cat /u01/app/oracle/diag/rdbms/$ORACLE_SID/$ORACLE_SID/trace/alert_${ORACLE_SID}.log | tail -2000 | grep -i "ora-"

5-) Connect to sqlplus / as sysdba, run all queries below and save the result in a .log file
set lines 200
set pagesize 3000
col object_name for a30
col comp_name for a40

  prompt Instance:
  select instance_name||' running on '||host_name from v$instance; 
  
  prompt Invalid Datafiles:
  select name,status from v$datafile where status not in ('ONLINE','SYSTEM');  
  
  prompt Invalid objects:
  select count(*) invalid_objects from dba_objects where status<>'VALID';  
  select owner, object_type, object_name from dba_objects where status<>'VALID';  
    
  prompt Status datafile:
  select distinct status from v$datafile;
  
  prompt Status temp_files:
  select distinct status from v$tempfile;
  
  prompt Status dba_temp_files:
  select distinct status from dba_temp_files;
  
  prompt Status Backup:
  select distinct status from v$backup;

  prompt Components:
  SELECT comp_name , version, status FROM dba_registry;
  
  prompt Instance version:
  select version, status from v$instance;

6-) After database startup, repeat all steps from 1-4 and compare the .log files generated before shutdown and after startup.

7-) Place all log files into the change.

8-) After startup for FIN91PRD or FIN91RPT, ask to UNIX team to UNFREEZE all Veritas service groups for FIN91PRD and FIN91RPT databases to back to the normal functionality.
For all changes in ussbyapsprd04 or ussbyapsprd05 server, related to the STOP/START database, this task MUST be added and assigned to UNIX team.

Unix Team task:
2-) UNFREEZE all Veritas service groups for FIN91PRD and FIN91RPT databases:
For all changes in ussbyapsprd04 or ussbyapsprd05 server, related to the STOP/START database, this task MUST be added and assigned to UNIX team.

