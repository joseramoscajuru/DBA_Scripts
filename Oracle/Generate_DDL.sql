set long 1000000
set pagesize 0
set linesize 1000
set trim on

SELECT dbms_metadata.get_ddl('OBJECT_TYPE', 'OBJECT_NAME', 'OWNER') FROM DUAL;


##EXEMPLO:

spool pkgbody.pkg
set long 10000000
set pagesize 0
set linesize 1000
set trim on
SELECT dbms_metadata.get_ddl('PACKAGE_BODY', 'PKG_MARKET_SHARE_PROD_SLM_RPT', 'PPMSYSTEM_ADMIN') FROM DUAL;

