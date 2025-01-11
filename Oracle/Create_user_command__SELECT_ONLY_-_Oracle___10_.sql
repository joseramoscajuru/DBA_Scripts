
For Oracle <10 (runs well too with 10g, 11g):

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