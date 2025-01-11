
-bash-4.2$ cat gera_purge_wm15.sql

set trimspool on lines 1000 pages 0 feedback off
spool purge_wm15.sql
select 'PURGE TABLE '||owner||'."'||object_name||'" ;'
from dba_recyclebin
where owner='WM15'
and type='TABLE'
/
spool off
