prompt
prompt #############
prompt BACKUP STATUS
prompt #############
set feedback on
set linesize 1000
set pagesize 50
col start_time         heading 'Started'      format a13
col backup_type        heading 'Backup Type'  format a12
col time_taken_display heading 'Elapsed|Time' format a10
col elapsed_min        heading 'Run|Min'      format 999999999
col output_mbytes      heading 'Size MB'      format 9,999,999,999
col backup_status      heading 'Status'       format a10 trunc
col cf                 heading 'Ctrl|Files'   format 9,999
col dfiles             heading 'Data|Files'   format 9,999
col l                  heading 'Arch|Files'   format 9,999
col output_instance    heading 'Ran on|Inst'  format 9
select
  to_char(j.start_time, 'Dy hh24:mi:ss') start_time,
  decode(j.input_type,'DB INCR',decode(i0,0,'Incr Lvl 1','Incr Lvl 0'),initcap(j.input_type)) backup_type,
  j.time_taken_display,
  j.elapsed_seconds/60 elapsed_min,
  (j.output_bytes/1024/1024) output_mbytes,
  initcap(j.status) backup_status,
  x.cf,
  x.i0 + x.i1 dfiles,
  x.l,
  ro.inst_id output_instance
from V$RMAN_BACKUP_JOB_DETAILS j
  left outer join (select
                     d.session_recid, d.session_stamp,
                     sum(case when d.controlfile_included = 'YES' then d.pieces else 0 end) CF,
                     sum(case when d.controlfile_included = 'NO'
                               and d.backup_type||d.incremental_level = 'D' then d.pieces else 0 end) DF,
                     sum(case when d.backup_type||d.incremental_level = 'D0' then d.pieces else 0 end) I0,
                     sum(case when d.backup_type||d.incremental_level = 'I1' then d.pieces else 0 end) I1,
                     sum(case when d.backup_type = 'L' then d.pieces else 0 end) L
                   from
                     V$BACKUP_SET_DETAILS d
                     join V$BACKUP_SET s on s.set_stamp = d.set_stamp and s.set_count = d.set_count
                   where s.input_file_scan_only = 'NO'
                   group by d.session_recid, d.session_stamp) x
    on x.session_recid = j.session_recid and x.session_stamp = j.session_stamp
  left outer join (select o.session_recid, o.session_stamp, min(inst_id) inst_id
                   from GV$RMAN_OUTPUT o
                   group by o.session_recid, o.session_stamp)
    ro on ro.session_recid = j.session_recid and ro.session_stamp = j.session_stamp
where j.start_time > trunc(next_day(sysdate-6,'SUNDAY'))
order by j.start_time
/