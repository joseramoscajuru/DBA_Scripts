set long 32767 pages 0 lines 256
set trimspool on
column line format A254 WORD_WRAPPED
set sqlblanklines on
set feedback off  
set tab off
set newpage none

spool ddl-table-X08_TRIB_MERC.sql

exec dbms_output.enable(2000000);
exec dbms_metadata.set_transform_param (dbms_metadata.session_transform,'STORAGE',false);
exec dbms_metadata.set_transform_param (dbms_metadata.session_transform,'SEGMENT_ATTRIBUTES', false);
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SQLTERMINATOR',TRUE);
exec dbms_metadata.set_transform_param (dbms_metadata.session_transform, 'PRETTY', true);
exec dbms_metadata.set_transform_param(dbms_metadata.SESSION_TRANSFORM,'EXPORT',true);

select replace(lower(dbms_metadata.get_ddl(object_type => 'TABLE', name => 'X08_TRIB_MERC', schema => 'MSAF')),'"',NULL) line 
from dual ;

set trimspool off

select chr(10)|| chr(10) from dual;

prompt ++++++++++   Index DDLs shown below  ++++++++++++++

select chr(10)|| chr(10) from dual;

select replace(lower(dbms_metadata.get_ddl(object_type => 'INDEX', name => index_name , schema => 'MSAF')),'"',NULL) line
from dba_indexes
where table_name = 'X08_TRIB_MERC';

spool off