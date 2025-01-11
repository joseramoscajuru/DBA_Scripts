-- RECRIAR ROLE

select 'create role ' || role || ';'
from dba_roles
where role = '&&role';

select 'grant ' || privilege || ' to &&role' ||
decode(admin_option,'YES',' with admin option;','NO',';')
from role_sys_privs
where role = '&&role';

select 'grant ' || privilege || ' on ' || owner || '.' || table_name
|| ' to &&role ' || decode(grantable,'YES','with grant option;','NO',';')
from role_tab_privs
where role = '&&role';

