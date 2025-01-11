
#overall information - run on primary and standby
 set lines 180
 col Archive_sequence format a50
 col instance format a10
 col host_name format a20
 col open_mode format a20
 col SCN_DATE format a35
 select
 inst.host_name,
 inst.instance_name Instance, dat.DATABASE_ROLE,
 'Last Applied='||max(sequence#)||' (resetlogs_change#='||arc.resetlogs_change#||')' Archive_sequence,
 dat.OPEN_MODE, to_char(dat.current_scn,'99999999999999999') SCN
 from v$archived_log arc, gv$instance inst, gv$database dat
 where arc.applied = (select decode(database_role, 'PRIMARY', 'NO', 'YES') from v$database)
 and arc.thread# = inst.INST_ID
 and inst.inst_id = dat.inst_id
 and arc.resetlogs_change# = (select resetlogs_change# from v$database)
 group by inst.host_name, inst.instance_name,dat.DATABASE_ROLE ,arc.thread#, arc.resetlogs_change#,dat.OPEN_MODE, to_char(dat.current_scn,'99999999999999999')
 order by arc.thread#;