select count(*) from dba_objects where status<>'VALID';

set pages 500
select 'alter '||object_type||' '||owner||'.'||object_name||' compile;'
from dba_objects
where status = 'INVALID'
and object_type in ('PROCEDURE', 'TRIGGER', 'PACKAGE', 'FUNCTION', 'MATERIALIZED VIEW','SYNONYM')
and object_name not like 'BIN%'
and temporary = 'N'
union all
select 'alter package '||owner||'.'||object_name||' compile body;'
from dba_objects
where status = 'INVALID'
and object_type = 'PACKAGE BODY'
and temporary = 'N';


alter procedure alexandre.proc1 compile

select object_name, owner, object_type from dba_objects where status <> 'VALID';

