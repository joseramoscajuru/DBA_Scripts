=== RODAR NO PRIMARY E NO DG ======

SET LINES 800
SET PAGESIZE 10000
BREAK ON REPORT
COMPUTE SUM LABEL TOTAL OF GAP ON REPORT
select primary.thread#,
       primary.maxsequence primaryseq,
       standby.maxsequence standbyseq,
       primary.maxsequence - standby.maxsequence gap
from ( select thread#, max(sequence#) maxsequence
       from v$archived_log
       where archived = 'YES'
         and resetlogs_change# = ( select d.resetlogs_change# from v$database d )
       group by thread# order by thread# ) primary,
     ( select thread#, max(sequence#) maxsequence
       from v$archived_log
       where applied = 'YES'
         and resetlogs_change# = ( select d.resetlogs_change# from v$database d )
       group by thread# order by thread# ) standby
where primary.thread# = standby.thread#;

set lines 180

col Arq_sequence format a50
col instance format a10
col host_name format a20
col open_mode format a20
col SCN_DATE format a35

select inst.host_name,inst.instance_name Instance, 'Last Applied='||max(sequence#)||' (resetlogs_change#='||arc.resetlogs_change#||')' Arq_sequence,
dat.OPEN_MODE, scn_to_timestamp(dat.current_scn) SCN_DATE
from v$archived_log arc, gv$instance inst, gv$database dat
where arc.applied = (select decode(database_role, 'PRIMARY', 'NO', 'YES') from v$database)
and arc.thread# = inst.INST_ID
and inst.inst_id = dat.inst_id
and arc.resetlogs_change# = (select resetlogs_change# from v$database)
group by inst.host_name, inst.instance_name, arc.thread#, arc.resetlogs_change#,dat.OPEN_MODE, scn_to_timestamp(dat.current_scn)
order by arc.thread#; 

