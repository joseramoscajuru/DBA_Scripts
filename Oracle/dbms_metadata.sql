select dbms_metadata.get_ddl('USER','XCHGLDR') from dual;

Take the password value string from the user creation DDL.

alter user XCHGLDR identified by <new temp pass>;

ALTER USER XCHGLDR IDENTIFIED BY VALUES <password value string>;