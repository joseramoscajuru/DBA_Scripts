    
 INST_ID        SID    SERIAL# USERNAME                       MACHINE              STATUS   SQL_ID        SQL_HASH_VALUE
 ---------- ---------- ---------- ------------------------------ -------------------- -------- ------------- --------------
          3        376       6109 MERCEDPA                       lppwa1468            ACTIVE   2k8txc1kuy25s     1705969848
 
 
SQL> select SQL_TEXT from v$sql where SQL_ID='2k8txc1kuy25s';
 
SQL_TEXT
 --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UPDATE M_T_2044927000_CCM_SHORTC_TG79  SET ID = -ID WHERE ID IN (SELECT M_T_2044927000_CCM_SHORTC_TG79.ID FROM  M_T_2044927000_CCM_SHORTC_TG79, M_CCM_SHORTCALLCHUNK  WHERE M_T_2044927000_CCM_SHORTC_TG79.CHUNKID  = 0 AND M_T_2044927000_CCM_SHORTC_TG79.M_TIME  = M_CCM_SHORTCALLCHUNK.M_TIME AND M_T_2044927000_CCM_SHORTC_TG79.PHONEID  = M_CCM_SHORTCALLCHUNK.PHONEID  AND M_T_2044927000_CCM_SHORTC_TG79.AGPHONELOGINDATE  = M_CCM_SHORTCALLCHUNK.AGPHONELOGINDATE  AND M_T_2044927000_CCM_SHORTC_TG79.SWITCHSKILL  = M_CCM_SHORTCALLCHUNK.SWITCHSKILL)


############Listar as sesses utilizando algum padro qualquer. Nesse caso ustilizando um DBLINK (@SARA).
set lines 100 pages 999
col "SID,SERIAL#" format a17
col DB_USER    format a15
col OSUSER format a10
select TO_CHAR(s.SID)||','||TO_CHAR(s.SERIAL#) "SID,SERIAL#", s.USERNAME DB_USER, s.OSUSER OS_USER, q.sql_text " "
from V$SESSION s, v$sqltext q
where  s.prev_hash_value = q.hash_value
and q.sql_text like '%@SARA%'
/

############LISTAR SESSES NO BD
select username, status, count(1) from v$session where type = 'USER' group by username, status;

############SCRIPT ORACLE PARA LISTAR LOCKS NO BD
/u01/app/oracle/product/11.2.0.2/Db_1/rdbms/admin/utllockt.sql

############# Lista sesses ativas no banco
set linesize 300
set pagesize 5000
col OWNER_BD format a10
col USUARIO format a8
col SID format 9999999
col P_ORACLE format 9999999
col STATUS format a8
col PID_UNIX format a12
col SERVIDOR format a15
col LOGON format a16
col PROCESSO_SO format a25
col MODULO format a14
col PGA_USED_MEM format 999999999
col PGA_ALLOC_MEM format 999999999
col PGA_MAX_MEM format 999999999

select SUBSTR(s.USERNAME,1,10) Owner_BD,
substr (OSUSER,1,8) usuario, s.SID SID,
s.SERIAL# p_oracle ,status,
SPID pid_unix, substr (machine,1,15) servidor,
to_char(logon_time,'DD/MM/YYYY hh24:mi') logon,
SUBSTR(s.program,1,25) processo_SO, SUBSTR(module,1,14) modulo
,pga_used_mem, pga_alloc_mem, pga_max_mem
from v$session s, v$process p
where s.PADDR = p.ADDR
and status = 'ACTIVE'
and s.username is not null
order by 8
/

############################# DADOS SOBRE AS SESSES BLOQUEADORAS

SELECT DECODE(request,0,'Holder: ','Waiter: ')||sid sess,
id1, id2, lmode, request, type
FROM V$LOCK
WHERE (id1, id2, type) IN
(SELECT id1, id2, type FROM V$LOCK WHERE request>0)
ORDER BY id1, request;


select sesion.sid,sesion.status,sesion.username,sql_text,sqlarea.first_load_time 
from v$sqlarea sqlarea, v$session sesion
where sesion.sql_hash_value = sqlarea.hash_value
and sesion.sql_address = sqlarea.address
and sesion.sid in (<SID LOCALIZADAS NA QUERY DE CIMA>);

