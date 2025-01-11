select distinct g.grantee username
from dba_users u
, ( select grantee,granted_role from dba_role_privs
connect by prior grantee = granted_role start with granted_role='DBA'
) g
where u.username = g.grantee
order by 1;