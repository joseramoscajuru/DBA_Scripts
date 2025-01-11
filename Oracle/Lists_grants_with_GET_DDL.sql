
The most comprehensive and reliable method I know is still by using DBMS_METADATA:

select dbms_metadata.get_granted_ddl( 'SYSTEM_GRANT', :username ) from dual;
select dbms_metadata.get_granted_ddl( 'OBJECT_GRANT', :username ) from dual;
select dbms_metadata.get_granted_ddl( 'ROLE_GRANT', :username ) from dual;

