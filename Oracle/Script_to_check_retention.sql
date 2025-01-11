rman target / catalog rmanqas/rmanqas@RMAN

allocate channel for maintenance device type 'sbt_tape'                                                                 
parms 'ENV=(TDPO_OPTFILE=C:\Program Files\Tivoli\TSM\AgentOBA64\tdpo_RRQVHOA2501_FORAD_QAS.opt)';                       
release channel;                          

sqlplus rmanqas/rmanqas@RMAN

set linesize 1000
set pagesize 1000
col retencao format a20
col HANDLE format a40
col GIGAS format 999,990.00
col g format 999,990.00
select name,dt,retencao, sum(gigas) g from (
SELECT  to_char(p.COMPLETION_TIME,'yyyy/mm') dt
,d.dbid
,d.name
,decode(INSTR(p.HANDLE,'ANUAL', 1, 1),0,decode(INSTR(p.HANDLE,'SEM', 1, 1),0,decode(INSTR(p.HANDLE,'MEN', 1, 1),0,decode(INSTR(p.HANDLE,'DIA', 1, 1),0,Decode(INSTR(p.TAG,'LEVEL', 1, 1),0,'CNTRL_FILE','LEVEL'),'DIA'),'MES'),'SEM'),'ANUAL'      ) RETENCAO,
 sum(p.bytes)/1024/1024/1024 GIGAS
  , count(*) qtd
-- , p.handle
FROM rc_backup_piece p ,
     rc_database d
WHERE p.db_id=d.dbid
-- and d.name in ( ‘ELLPRD’)--,‘CPFTE’,‘CPSC’,‘ELLDEV’,‘AMFTE’, ‘ELLQA’)
-- and
-- p.completion_time>=to_date(‘20180203’,‘yyyymmdd’) and
-- p.completion_time< to_date(‘20180204’,‘yyyymmdd’)
group by   to_char(p.COMPLETION_TIME,'yyyy/mm'),
d.dbid,d.name,
decode(INSTR(p.HANDLE,'ANUAL', 1, 1),0,decode(INSTR(p.HANDLE,'SEM', 1, 1),0,decode(INSTR(p.HANDLE,'MEN', 1, 1),0,decode(INSTR(p.HANDLE,'DIA', 1, 1),0,Decode(INSTR(p.TAG,'LEVEL', 1, 1),0,'CNTRL_FILE','LEVEL'),'DIA'),'MES'),'SEM'),'ANUAL'      )
--  , p.handle
)
--WHERE retencao <>‘CNTRL_FILE’
group by name,dt, retencao order by 1,2;