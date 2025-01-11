=> to get SQL from sql_id:

select sql_text from v$sql where sql_id='buz4mk2hb27aq'; 

=> explain:

SQL> set autotrace traceonly explain

=> detalhes sessao dado o sql_id:

set lines 1000 pages 100
col username for a20
col sql_text for a50
SELECT a.username,
		a.sid,
		a.serial#,
		a.sql_id,
       b.sql_text,
       a.status
FROM   v$session a,
       v$sqlarea b
WHERE 
-- a.sql_id = '&sql_id'
a.sid=931
and a.sql_id = b.sql_id;