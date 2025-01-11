col object_name format a40
col comp_name format a40
set lines 999

spool check_list.log

! sqlplus teste/steste@orp8

set lines 300
col INSTANCE_NAME format a15
col STATUS format a11
col DATABASE_STATUS format a11
col "STARTUP TIME" format a20
col OPEN_MODE format a11
col HOST_NAME format a15
select to_char(a.startup_time, 'HH24:MI DD-MON-YY') "STARTUP TIME",
    to_char(b.created, 'HH24:MI DD-MON-YY') "CREATION TIME"
,	a.INSTANCE_NAME
,	a.HOST_NAME
,	a.STATUS
,	a.DATABASE_STATUS
,	a.SHUTDOWN_PENDING
,	b.OPEN_MODE
from	 gV$INSTANCE a, gV$DATABASE b
/
set lines 1000
set pages 1000
col instance_name format a20
col host_name format a30
col "Startup time" format a20
col database_status format a20
col status format a10
select instance_name, host_name, status, database_status, to_char(startup_time, 'HH24:MI DD-MON-YY') "Startup time" from gv$instance;
select distinct status,error from v$datafile_header;
select name, open_mode, created from v$database;
select distinct fuzzy from v$datafile_header;
select distinct recover from v$datafile_header;
select distinct status from v$datafile;
select distinct enabled from v$datafile;    
select distinct status from dba_data_files;
select distinct status from dba_tablespaces;
select distinct status from v$backup;
select distinct status from v$logfile;
select distinct status from v$tempfile;

show parameter dump_dest
**** entrar no diretorio de background_dump_dest 
**** verificar qual  o arq de log ls -ltr alert*
**** verificar o arquivo de log tail -100 <nome do arquivo>
alter system switch logfile;
alter system checkpoint;	
select count(*) from dba_objects where status<>'VALID';
select owner,object_name,object_type,status from dba_objects where status<>'VALID';
select comp_name,version,status from dba_registry;

#Verficao de Database Link
select OBJECT_NAME,STATUS from dba_objects where OBJECT_TYPE ='DATABASE LINK';

spool off


col "INSTANCE_NAME" for a20
col "HOST_NAME" for a20
col "VERSION" for a20
col "STATUS" for a20
col "SHUTDOWN_PENDING" for a20
col "DATABASE_STATUS" for a20 
select INSTANCE_NAME, HOST_NAME, VERSION, STATUS, SHUTDOWN_PENDING, DATABASE_STATUS, BLOCKED from v$instance;


#HEALTH CHECK COMPLETO (Testar)
SET LINESIZE 155
SET serveroutput on;
clear scr;
declare
x number;
BEGIN

dbms_output.enable;
dbms_output.put_line(CHR(10));

execute immediate 'alter session SET nls_date_FORmat="dd-MON-yy hh24:mi:ss"'; 


dbms_output.put_line('=====================================   STARTING STANDARD HEALTH CHECK   =====================================');
dbms_output.put_line(CHR(2));

FOR c in (SELECT * FROM gv$instance)
loop
dbms_output.put_line('Host: '||c.host_name||' => Instance '||c.instance_name||' is '||c.status||' since '||c.startup_time||' .: Role: '||c.instance_role);
END loop;

FOR c in (SELECT * FROM v$database)
loop
dbms_output.new_line;
dbms_output.put_line(CHR(10)||'============================================   DATABASE DETAILS   ============================================');
dbms_output.put_line(CHR(10)||'Database Name: '||c.name||' --- DBID: '||c.dbid||' --- Open Mode: '||c.open_mode||' --- Log Mode: '||c.log_mode);
#dbms_output.put_line('Flashback Enable: '||c.flashback_on||' --- Current SCN: '||c.current_scn||' --- Archivelog Change#: '||c.archivelog_change#);
dbms_output.put_line('Database Role: '||c.database_role||' --- Protection Mode: '||c.protection_mode||' --- Protection Level: '||c.protection_level);
END loop;

FOR c in (SELECT ROUND(SUM(used.bytes) / 1024 / 1024 / 1024 ) Total_GB,	
ROUND(SUM(used.bytes) / 1024 / 1024 / 1024 ) - ROUND(free.p / 1024 / 1024 / 1024) Used_GB,
ROUND(free.p / 1024 / 1024 / 1024) Free_GB
from    (select	bytes
	from	v$datafile
	union	all
	select	bytes
	from 	v$tempfile
	union 	all
	select 	bytes
	from 	v$log) used,	
	(select SUM(bytes) as p from dba_free_space) free
group by free.p)
loop
dbms_output.put_line('Total DB Space (GB): '||c.total_gb||' --- Used DB Space (GB): '||c.used_gb||' --- Free DB Space (GB): '||c.free_gb);
END loop;

dbms_output.put_line(CHR(10)||'========================= DATAFILES, TEMPFILES, TABLESPACES, LOGFILES, BACKUPS, LOCKS ========================');

dbms_output.new_line;


FOR c in (SELECT count(status) qty, status, nvl(error,'NO ERROR') error FROM v$datafile_header group by status, error)
loop
dbms_output.put_line(CHR(10)||'Total'||to_char(c.qty,'000')||' Datafiles as '||c.status||' - Error: '||c.error);
END loop;

FOR c in (SELECT count(status) qty, status FROM v$tempfile group by status)
loop
dbms_output.new_line;
dbms_output.put_line('Total'||to_char(c.qty,'000')||' Tempfiles as '||c.status);
END loop;

FOR c in (SELECT count(status) qty, status  FROM dba_tablespaces group by status)
loop
dbms_output.new_line;
dbms_output.put_line('Total'||to_char(c.qty,'000')||' Tablespaces as '||c.status);
END loop;

FOR c in (SELECT count(status) qty, status FROM gv$backup group by status)
loop
dbms_output.new_line;
dbms_output.put_line('Total'||to_char(c.qty,'000')||' Backups as '||c.status);
END loop;

FOR c in (SELECT count(member) qty, nvl(status,'NO ERROR') status FROM gv$logfile group by status)
loop
dbms_output.new_line;
dbms_output.put_line('Total'||to_char(c.qty,'000')||' Logfiles as '||c.status);
END loop;

SELECT count(sid) into x FROM gv$lock WHERE (id1, id2, type) in (SELECT id1, id2, type FROM gv$lock WHERE request>0) ORDER BY id1, request;

dbms_output.new_line;
dbms_output.put_line(CHR(10)||'Locked Sessions:');

if (x = 0) then
dbms_output.new_line;
dbms_output.put_line('There are no locked sessions');

else
FOR c in (SELECT decode(request,0,'Holder: ','Waiter: ')||sid sess, id1, id2, lmode, request, type FROM gv$lock WHERE (id1, id2, type) in (SELECT id1, id2, type FROM gv$lock WHERE request>0) ORDER BY id1, request)
loop

dbms_output.put_line('Session: '||c.sess||' - ID1: '||c.id1||' - ID2: '||c.id2);
dbms_output.new_line;

END loop;
END if;

dbms_output.put_line(CHR(10)||'======================================   ENDING STANDARD HEALTH CHECK   ======================================');

END;
/
SET serveroutput off
dbms_output.new_line;
dbms_output.put_line(CHR(10)||'Checking backups');
for c in (select count(status) qty, status from v$backup group by status)
loop
dbms_output.new_line;
dbms_output.put_line('Total Backups: '||c.qty||' - '||c.status);
end loop;

dbms_output.new_line;
dbms_output.put_line(CHR(10)||'Checking logfiles');
for c in (select count(status) qty, nvl(status,'NO ERROR') status from v$logfile group by status)
loop
dbms_output.new_line;
dbms_output.put_line('Errors on logfiles: '||c.qty||' - '||c.status);
end loop;

dbms_output.new_line;
dbms_output.put_line(CHR(10)||'Checking tempfiles');
for c in (select count(status) qty, status from v$tempfile group by status)
loop
dbms_output.new_line;
dbms_output.put_line('Total Tempfiles: '||c.qty||' - '||c.status);
end loop;

dbms_output.put_line(CHR(10)||CHR(10)||'--== Ending standard Health Check ==--'||CHR(10));

end;
/
set serveroutput off;


nohup /oraarcp/oracle9/dbtools/RMAN_online_lanfree_bkup_90.sh arcprd 1>> /oraarcp/oracle/orareports/online.rpt/online.bkup.lst 2>&1 &

nohup /u01/app/oracle/dbtools/hot_backups/hot_incremental_0.sh fin91cnv /u01/app/oracle/dbtools/hot_backups/hot_incr_0_fin91cnv.cmdfile >/u01/app/oracle/dbtools/logs/fin91cnv.log 2>&1



