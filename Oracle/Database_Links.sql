SET LINESIZE 150

COLUMN owner FORMAT A30
COLUMN db_link FORMAT A30
COLUMN username FORMAT A30
COLUMN host FORMAT A30

SELECT owner,
       db_link,
       username,
       host
FROM   dba_db_links
ORDER BY owner, db_link;


SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON

BEGIN
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'SQLTERMINATOR', true);
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'PRETTY', true);
END;
/

SELECT DBMS_METADATA.get_ddl ('DB_LINK', db_link, owner)
FROM   dba_db_links
WHERE  owner = DECODE(UPPER('&1'), 'ALL', owner, UPPER('&1'));

SET PAGESIZE 14 LINESIZE 1000 FEEDBACK ON VERIFY ON

