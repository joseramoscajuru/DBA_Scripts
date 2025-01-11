CREATE OR REPLACE DIRECTORY <directory_name> AS '<operating_system_path>';

System Privileges

GRANT create any directory TO <user_name>;
GRANT drop any directory TO <user_name>;

VIEW DIRECTORIES

desc dba_directories

set linesize 121
col owner format a15
col directory_name format a20
col directory_path format a70

SELECT *
FROM dba_directories;

GRANT READ ON DIRECTORY <directory_name> TO <schema_name>

GRANT WRITE ON DIRECTORY <directory_name> TO <schema_name>

REVOKE READ ON DIRECTORY <directory_name> FROM <schema_name>

REVOKE WRITE ON DIRECTORY <directory_name> FROM <schema_name>

