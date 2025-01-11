# Mostra objetos invalidos
select owner, object_name,object_type, status from  dba_objects where status = 'INVALID';

# Mostra count de objetos invalidos
select owner, count(*) from dba_objects where status = 'INVALID' group by owner;

#-- Mostra oque sao
 linesize 132
set pagesize 0
column owner format a20
column object_name format a40
select owner, object_name, object_type
from dba_objects
where status = 'INVALID'
order by owner, object_type
/

# Recompilar..
alter <object_type> <owner>.<object_name> compile;

@$ORACLE_HOME/rdbms/admin/utlrp

