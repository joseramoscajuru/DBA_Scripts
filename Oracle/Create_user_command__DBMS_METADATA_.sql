set head off
set pagesize 0
set long 999999
set feedback off
set echo off
spool /tmp/createnewuser.sql
SELECT DBMS_METADATA.GET_DDL('USER',upper('&&USERNAME')) || '/' DDL
FROM DUAL
UNION ALL
SELECT DBMS_METADATA.GET_GRANTED_DDL('ROLE_GRANT',upper('&&USERNAME')) || '/' DDL
FROM DUAL
where exists (select 'x' from dba_role_privs drp where drp.grantee=upper('&&USERNAME'))
UNION ALL
SELECT DBMS_METADATA.GET_GRANTED_DDL('SYSTEM_GRANT',upper('&&USERNAME')) || '/' DDL
FROM DUAL
where exists (select 'x' from dba_sys_privs drp where drp.grantee=upper('&&USERNAME'))
UNION ALL
SELECT DBMS_METADATA.GET_GRANTED_DDL('OBJECT_GRANT',upper('&&USERNAME')) || '/' DDL
FROM DUAL
where exists(select 'x' from dba_tab_privs drp where drp.grantee=upper('&&USERNAME'))
/
spool off 

For Oracle >=10: 

clear screen
accept uname prompt 'Enter User Name : '
accept outfile prompt  ' Output filename : '
 
spool &&outfile..gen
 
SET LONG 2000000 PAGESIZE 0 head off verify off feedback off linesize 132
 
SELECT dbms_metadata.get_ddl('USER','&&uname') FROM dual;
SELECT DBMS_METADATA.GET_GRANTED_DDL('SYSTEM_GRANT','&&uname') from dual;
SELECT DBMS_METADATA.GET_GRANTED_DDL('ROLE_GRANT','&&uname') from dual;
SELECT DBMS_METADATA.GET_GRANTED_DDL('OBJECT_GRANT','&&uname') from dual;
 
spool off

More information for this package in the official Oracle 12c documentation :
http://docs.oracle.com/cd/E16655_01/appdev.121/e17602/d_metada.htm#ARPLS026

For Oracle <10 (runs well too with 10g, 11g):
1

clear screen
 
accept uname prompt 'Enter User Name : '
accept outfile prompt  ' Output filename : '
 
col username noprint
col lne newline
 
set heading off pagesize 0 verify off feedback off linesize 132
 
spool &&outfile..gen
 
prompt  -- genarate user ddl
SELECT username, 'CREATE USER '||username||' '||
       DECODE(password, 'EXTERNAL', 'IDENTIFIED EXTERNALLY',
              'IDENTIFIED BY VALUES '''||password||''' ') lne,
       'DEFAULT TABLESPACE '||default_tablespace lne,
       'TEMPORARY TABLESPACE '||temporary_tablespace||';' lne
  FROM DBA_USERS
 WHERE USERNAME LIKE UPPER('%&&uname%')
    OR UPPER('&&uname') IS NULL
 ORDER BY USERNAME;
 
SELECT username, 'ALTER USER '||username||' QUOTA '||
       DECODE(MAX_BYTES, -1, 'UNLIMITED', TO_CHAR(ROUND(MAX_BYTES/1024))||'K')
       ||' ON '||tablespace_name||';' lne
  FROM DBA_TS_QUOTAS
 WHERE USERNAME LIKE UPPER('%&&uname%')
    OR UPPER('&&uname') IS NULL
 ORDER BY USERNAME;
 
col grantee noprint
 
select grantee, granted_role granted_priv,
       'GRANT '||granted_role||' to '||grantee||
       DECODE(ADMIN_OPTION, 'Y', ' WITH ADMIN OPTION;', ';')
  from dba_role_privs
 where grantee like upper('%&&uname%')
         UNION
select grantee, privilege granted_priv,
       'GRANT '||privilege||' to '||grantee||
       DECODE(ADMIN_OPTION, 'Y', ' WITH ADMIN OPTION;', ';')
  from dba_sys_privs
 where grantee like upper('%&&uname%')
 order by 1, 2;
 
spool off