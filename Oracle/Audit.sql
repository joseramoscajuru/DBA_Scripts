set lines 120
set pages 100

col terminal format a30
col action_name format a15
col username format a15
col comment_text

select USERNAME, OS_USERNAME, to_char(TIMESTAMP,'dd/mm/yyyy hh24:mi:ss') timestamp,returncode,COMMENT_TEXT
from sys.dba_audit_trail
where username = upper('GMACFSIIF')
and timestamp >= trunc(sysdate)
and (returncode=28000 or returncode=1017);



select USERNAME, terminal, to_char(TIMESTAMP,'dd/mm/yyyy hh24:mi:ss') timestamp,returncode,COMMENT_TEXT
from sys.dba_audit_trail
where username = upper('GMACFSIIF')
and timestamp >= trunc(sysdate)
and (returncode=28000 or returncode=1017);