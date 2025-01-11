##############################
cursor.sql
PROMPT Ultimo comando sql executado:
select OSUSER,SUBSTR(s.USERNAME,1,10) USU, q.SQL_TEXT
from v$sql q, v$session s
where s.SQL_ADDRESS=q.ADDRESS
and s.sid = &server_id;

PROMPT Conteudo do cursor interno do SGBD:
select sql.sql_text, sql.piece
from v$open_cursor cursor, V$SQLTEXT_WITH_NEWLINES sql, V$SESSION SESS
where cursor.user_name= sess.username
anD cursor.SID = sess.sid
and cursor.address = sql.address
and cursor.hash_value = sql.hash_value
and sess.sid = &SID 
order by cursor.sid, cursor.address, cursor.hash_value, sql.piece;


##############################

