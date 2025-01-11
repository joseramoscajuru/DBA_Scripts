1- Verifica Lock ORACLE 9i e 10g
2- Verifica Lock ORACLE 8i
3- Mostra desde quando a sessao est parada
4- Mostra qual horrio a sessao fez seu ultimo trabalho
5- Gerar Trace
6- verifica valor alocado para bd por tablespace
7- Verifica realmente utilizado pelo BD por tablespace
8- Saber valor que um owner ocupa no banco de dados efetivamente
9- Verifica a alocaao de determinada tabela separada por datafiles ou seja
consumo de espao da tabela
10- Verificacao e SQL TEXT
11- Verificando instruao SQL pelo SID
12- Identificar usurio por SID
13- Identificar usurio por SPID
14- Lista execues e loads por SQL_ID( Considerar ofensivos quando o nmero
de loads for maior que executions)
15- rea ocupada pelos componentes da SGA
16- Gerar senha randmica
17- Verificando limites de banco de dados Sessions, process, etc
18- Verifica qual sessao est bloqueando no caso de lock
19- Agrupar usurios por tablespaces
20- Identifica as transaes Pendentes
21- Verificar eventos de espera tempos de resposta do BD - OWI
22- Verificando enfileiramentos
23- verifica a quantidade de REDO gerado por Sesso
24- indica transaes distribudas aguardando por recovery
25- mostra as conexes de entrada e sada para conexes pendentes
26- Mostra as mudanas de log (switch log)
27- Verifica usurios locando tabelas
28- Recompilar todos objetos invlidos
29 - Verifica a utilizao da rea de recuperao Flash
DB_RECOVERY_FILE_DEST

######## 1- Verifica Lock ORACLE 10g ########

SELECT /*+ rule */  l.inst_id,s.event, l.SID, s.serial# serial, p.spid,
s.username,
s.status, s.osuser, s.machine, s.program,
         to_char(s.logon_time,'dd/mm/yyyy hh24:mm:ss') LOGON_TIME, l.ctime
LOCK_TIME
    FROM gv$lock l, gv$session s, gv$process p
   WHERE s.inst_id = l.inst_id
     and s.inst_id = p.inst_id
     AND s.SID = l.SID
     and s.PADDR = p.addr
     AND (l.id1, l.id2, l.TYPE) IN (SELECT id1, id2, TYPE
                                      FROM gv$lock
                                     WHERE request > 0)
ORDER BY ctime DESC;

######## 2- Verifica Lock ORACLE 8i e 9i ########

SELECT  /*+ RULE */ l.SID, s.serial# serial, p.spid, s.username, s.status,
s.osuser, s.machine, s.program,
         to_char(s.logon_time,'dd/mm/yyyy hh24:mm:ss') LOGON_TIME, l.ctime
LOCK_TIME
    FROM gv$lock l, gv$session s, gv$process p
   WHERE s.inst_id = l.inst_id
     and s.inst_id = p.inst_id
     AND s.SID = l.SID
     and s.PADDR = p.addr
     AND (l.id1, l.id2, l.TYPE) IN (SELECT id1, id2, TYPE
                                      FROM gv$lock
                                     WHERE request > 0)
ORDER BY ctime DESC;

######## 3- Mostra desde quando a sessao est parada ########

select username,logon_time,last_call_et,
to_char(sysdate-(last_call_et/(60*60*24)),'hh24:mi:ss') last_work_time
from gv$session
where username is not null
and status = 'INACTIVE';

######## 4- Mostra qual horrio a sessao fez seu ultimo trabalho ########

select username,logon_time,last_call_et,
to_char(sysdate-(last_call_et/(60*60*24)),'hh24:mi:ss') last_work_time
from gv$session
where username is not null
and status = 'ACTIVE';

######## 5- Gerar Trace ########

EXEC sys.dbms_system.set_sql_trace_in_session(SID,serial,TRUE);

######## 6- verifica valor alocado para bd por tablespace ########

select tablespace_name, sum(bytes)/1024/1024 "Valor alocado em MB" from
dba_data_files
group by tablespace_name

######## 7- Verifica realmente utilizado pelo BD por tablespace ########

select tablespace_name, sum(bytes)/1024/1024 "valor utilizado em MB" from
dba_extents
group by tablespace_name

######## 8- Saber valor que um owner ocupa no banco de dados efetivamente
(nao espao alocado) separado por tablespace ########

select tablespace_name, SUM(bytes)/1024/1024 "valores em MB" from
dba_segments where owner = 'ARBOR'
group by rollup (tablespace_name)

######## 9- Verifica a alocaao de determinada tabela separada por datafiles
ou seja consumo de espao da tabela ########

select substr(D.file_name,1,200) as "FileSystem",
sum(E.bytes)/1024/1024/1024 as "TAMANHO EM GB"
from dba_data_files D,dba_extents E
where E.segment_name = 'NOME_TABELA'
and D.tablespace_name = 'NOME_TABLESPACE'
and D.FILE_ID = E.FILE_ID
group by rollup(substr(D.file_name,1,200))

######## 10- Verificacao e SQL TEXT ########

select sesion.sid,
       sesion.username,
       optimizer_mode,
       hash_value,
       address,
       cpu_time,
       elapsed_time,
       sql_text
  from gv$sqlarea sqlarea, gv$session sesion
 where sesion.sql_hash_value = sqlarea.hash_value
   and sesion.sql_address    = sqlarea.address
   and sesion.username = 'LF'

######## 11- Verificando instruao SQL pelo SID ########
select * from gv$sql
where address = (select sql_address from v$session where sid =26)

-- where address in(select sql_address from v$session where sid in(50,17))

######## 12- Identificar usurio por SID ########

select s.inst_id, s.sid, s.serial#, p.spid, s.status, s.username, s.program
from gv$session s, gv$process p
where s.paddr = p.addr
and s.inst_id = p.inst_id
and s.sid = &pid;

######## 13- Identificar usurio por SPID ########

select s.inst_id, s.sid, s.serial#, p.spid, s.status, s.username, s.program
from gv$session s, gv$process p
where s.paddr = p.addr
and s.inst_id = p.inst_id
and p.spid = &spid;
## opcional
 select p.PID,p.SPID,s.SID, s.serial#
 from v$process p,v$session s
 where s.paddr = p.addr
 and s.sid = &SESSION_ID
 and s.username = &USERNAME;

######## 14- Lista execues e loads por SQL_ID( Considerar ofensivos quando o nmero de loads for maior que executions) ########

select SQL_ID, SHARABLE_MEM/1024/1024, PERSISTENT_MEM/1024/1024, EXECUTIONS,
LOADS, LOADED_VERSIONS, OPTIMIZER_MODE
from gv$sql
where executions > 5
and loads > 5;

######## 15- rea ocupada pelos componentes da SGA ########

SELECT   NAME, TRUNC(SUM(mb),3) total, TRUNC(SUM(inuse),3) in_use
    FROM (SELECT CASE
                    WHEN NAME = 'buffer_cache'
                       THEN 'db_cache_size'
                    WHEN NAME = 'log_buffer'
                       THEN 'log_buffer'
                    ELSE pool
                 END NAME,
                 BYTES/1024/1024 mb,
                 CASE
                    WHEN NAME = 'buffer_cache'
                       THEN   (BYTES - (SELECT COUNT(*)
                                          FROM v$bh
                                         WHERE status = 'free')
                                * (SELECT VALUE
                                     FROM v$parameter
                                    WHERE NAME = 'db_block_size')
                              ) /1024/1024
                    WHEN NAME <> 'free memory'
                       THEN BYTES/1024/1024
                 END inuse
            FROM v$sgastat)
GROUP BY NAME;

######## 16- Geraao de senha randmica

select dbms_random.string('U', 2)||trunc(dbms_random.value(1000, 9999))
from dual;

######## 17- Verificando limites de banco de dados Sessions, process, etc
########

select * from v$resource_limit;

######## 18- Verifica qual sessao est bloqueando no caso de lock (pode ser
usado com o script 1) ########

Select * from dba_blockers;

######## 19- Agrupar usurios por tablespaces ########

select default_tablespace, temporary_tablespace, profile, count(*)
from dba_users
where username like '%VB'
group by default_tablespace, temporary_tablespace, profile
order by 4 desc;

######## 20- Identifica as transaes Pendentes ########
Select * from DBA_PENDING_TRANSACTIONS;

######## 21- Verificar eventos de espera tempos de resposta do BD - OWI
########

select event, time_waited as time_spent
from   v$session_event
where  sid = &sid
and    event not in (
         'Null event',
         'client message',
         'KXFX: Execution Message Dequeue - Slave',
         'PX Deq: Execution Msg',
         'KXFQ: kxfqdeq - normal deqeue',
         'PX Deq: Table Q Normal',
         'Wait for credit - send blocked',
         'PX Deq Credit: send blkd',
         'Wait for credit - need buffer to send',
         'PX Deq Credit: need buffer',
         'Wait for credit - free buffer',
         'PX Deq Credit: free buffer',
         'parallel query dequeue wait',
         'PX Deque wait',
         'Parallel Query Idle Wait - Slaves',
         'PX Idle Wait',
         'slave wait',
         'dispatcher timer',
         'virtual circuit status',
         'pipe get',
         'rdbms ipc message',
         'rdbms ipc reply',
         'pmon timer',
         'smon timer',
         'PL/SQL lock timer',
         'SQL*Net message from client',
         'WMON goes to sleep')
union all
select b.name, a.value
from   v$sesstat a, v$statname b
where  a.statistic# = b.statistic#
and    b.name       = 'CPU used when call started'
and    a.sid        = &sid;

######## 22- Verificando enfileiramentos ########

SELECT   i.instance_name, w.event, COUNT (*), SUM (seconds_in_wait)
   FROM gv$instance i,gv$session_wait w
  WHERE
  i.inst_id = w.inst_id and
  event not like 'Streams AQ%' and
  event not like 'queue messages%' and
  event not like 'SQL*Net%' and
  (w.inst_id, SID) IN (SELECT inst_id, SID
                             FROM gv$session
                            WHERE status = 'ACTIVE' AND username IS NOT
NULL)
GROUP BY i.instance_name,event
ORDER BY 3 DESC;

######## 23- verifica a quantidade de REDO gerado por Sesso ########

select ss.sid, ss.value
from v$sesstat ss, v$statname sn
where sn.statistic# = ss.statistic#
and sn.name = 'redo size'
order by 2 desc

######## 24- indica transaes distribudas aguardando por recovery ########

select * from dba_2pc_pending

######## 25- mostra as conexes de entrada e sada para conexes pendentes
########
select * from DBA_2PC_NEIGHBORS

######## 26- Mostra as mudanas de log (switch log) ########

select thread#,
       to_char(first_time,'DD-MON-YYYY') creation_date,
       to_char(first_time,'HH24:MI')     time,
       sequence#,
       first_change# lowest_SCN_in_log,
       next_change#  highest_SCN_in_log,
       recid         controlfile_record_id,
       stamp         controlfile_record_stamp
from   v$log_history
order by first_time desc;

######## 27- Verifica usurios locando tabelas ########

select b.owner, b.object_name, b.object_type, a.*,
DECODE ("LOCKED_MODE"
                   , 0, 'None'
                   , 1, 'NULL'
                   , 2, 'Row-Share'
                   , 3, 'Row-Excl.'
                   , 4, 'Share'
                   , 5, 'S/Row-Excl.'
                   , 6, 'Exclusive'
                 ) as "FORMA DE BLOQUEIO"
from sys.v_$locked_object a, all_objects b
where a.object_id = b.object_id

######## 28- Recompilar todos objetos invlidos ########
Rodar o script:

$ORACLE_HOME/rdbms/admin rodar o utlrp que recompila todos os objetos
invlidos

SQL> @$ORACLE_HOME/rdbms/admin/utlrp.sql;

######## 29 - Verifica a utilizao da rea de recuperao Flash

DB_RECOVERY_FILE_DEST ########
SELECT file_type,percent_space_used AS Utilizado,
percent_space_reclaimable AS Obsoleto,
number_of_files AS "numero de arquivos"
FROM v$flash_recovery_area_usage;

######## 30- Saber valor que uma tabela ocupa no banco de dados efetivamente

(nao espao alocado) separado por tablespace ########
select tablespace_name, SUM(bytes)/1024/1024 "valores em MB" from
dba_segments where segment_name = ''
group by rollup (tablespace_name)

