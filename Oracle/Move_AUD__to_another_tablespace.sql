
STEP 1: Check the owner and existing tablespace of AUD$ table 

set lines 1000
col segment_name format a30
select owner,segment_name,segment_type,tablespace_name,bytes/1024/1024 
from dba_segments 
where segment_name='AUD$'
/

SELECT table_name, tablespace_name 
FROM dba_tables
WHERE table_name IN ('AUD$', 'FGA_LOG$') 
ORDER BY table_name;

TABLE_NAME                     TABLESPACE_NAME
------------------------------ ------------------------------
AUD$                           SYSTEM
FGA_LOG$                       SYSTEM

STEP 2: Check the current size of two tables:

select segment_name,bytes/1024/1024 size_in_megabytes 
from dba_segments 
where segment_name in ('AUD$','FGA_LOG$');

STEP 3: Create a new tablespace and make sure that its size is large enough for the tables that will be moved:

create tablespace audit_tbs 
datafile '/u01/app/oracle/oradata/d1v11202/audit_tbs1.dbf' 
size 100M autoextend on;


STEP 2: Execute DBMS_AUDIT_MGMT procedure to move AUD$ table to SYSAUX tablespace

Use the dbms_audit_mgmt to move the tablespace .

SQL> BEGIN
DBMS_AUDIT_MGMT.set_audit_trail_location(
audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD,--this moves table AUD$
audit_trail_location_value => 'AUDIT_TBS');
END;
/
PL/SQL procedure successfully completed.


SQL> BEGIN
DBMS_AUDIT_MGMT.set_audit_trail_location(
audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_FGA_STD,--this moves table FGA_LOG$
audit_trail_location_value => 'AUDIT_TBS');
END;
/
PL/SQL procedure successfully completed.


STEP 3: check whether tablespace has been moved from system to AUDIT_DATA or not.

SELECT table_name, tablespace_name 
FROM dba_tables
WHERE table_name IN ('AUD$', 'FGA_LOG$') 
ORDER BY table_name;