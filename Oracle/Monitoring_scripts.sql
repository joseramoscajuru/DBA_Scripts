
#Monitors scripts
 variavel="valor"
 while [ $variavel = "valor" ]; do
   sqlplus -s /nolog <<EOF
   connect / as sysdba
 set lines 180
 col Archive_sequence format a20
 col instance format a10
 col host_name format a20
 col open_mode format a20
 col SCN_DATE format a35
 select
 inst.instance_name Instance, dat.DATABASE_ROLE,'Last Applied='||max(sequence#) Archive_sequence,to_char(dat.current_scn,'99999999999999999') SCN
 from v\$archived_log arc, gv\$instance inst, gv\$database dat
 where arc.applied = (select decode(database_role, 'PRIMARY', 'NO', 'YES') from v\$database)
 and arc.thread# = inst.INST_ID
 and inst.inst_id = dat.inst_id
 and arc.resetlogs_change# = (select resetlogs_change# from v\$database)
 group by  inst.instance_name,dat.DATABASE_ROLE ,arc.thread#, to_char(dat.current_scn,'99999999999999999')
 order by arc.thread#;
 EOF
   sleep 5
   clear
 done


 variavel="valor"
 while [ $variavel = "valor" ]; do
   sqlplus -s /nolog <<EOF
   connect / as sysdba
 col name for a13
 col value for a20
 col unit for a30
 set lines 122
 SELECT NAME, VALUE, TIME_COMPUTED
 FROM V\$DATAGUARD_STATS
 WHERE NAME = 'apply lag';
 EOF
   sleep 30
   clear
 done