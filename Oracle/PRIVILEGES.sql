#PESQUISAR PRIVILGIOS
select * from dba_tab_privs where grantee = 'HR';

select * from dba_sys_privs where grantee = 'HR';

select * from dba_role_privs where grantee = 'HR';


#PRIVILGIOS em tablespaces especficas
alter user <user_name> quota unlimited on <tablespace_name>;
alter user <user_name> quota 1M on <tablespace_name>;

