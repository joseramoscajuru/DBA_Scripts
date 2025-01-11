set long 9000000000
set head off echo off
select 'select dbms_metadata.get_ddl(''TABLESPACE'',''' 
  ||  tablespace_name || ''') from dual;' from dba_tablespaces
/