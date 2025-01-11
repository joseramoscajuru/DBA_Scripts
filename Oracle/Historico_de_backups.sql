set linesize 200
set pages 100
col TIME_TAKEN_DISPLAY for a20
col INPUT_BYTES_DISPLAY for a20
col OUTPUT_BYTES_DISPLAY for a20
col OUTPUT_DEVICE_TYPE for a20
col INPUT_TYPE for a15
col STATUS for a25
select start_time,end_time,output_device_type,input_type,status,time_taken_display,input_bytes_display,output_bytes_display 
from V$RMAN_BACKUP_JOB_DETAILS 
where input_type='DB FULL' order by start_time desc; 


while true
do
        sqlplus -s "/ as sysdba" << EOF

      set linesize 180 pages 200
      col sid format 99999
      col opname format a35
      col target format a10
      col units format a15
      col time_remaining format 999990 heading Remaining[s]
      col bps format 99990.99 heading [Units/s]
      col fertig format 90.99 heading "complete[%]"
      col endat heading "Fisnish at"

      col "User" format a15
      col program format a30
      col module format a30
      col action format a20

      select sid,
             opname,
             (totalwork-sofar)/time_remaining bps,
             time_remaining,
             sofar/totalwork*100 fertig,
             to_char(sysdate + TIME_REMAINING/3600/24, 'yyyy-mm-dd hh24:mi:ss') endat
        from v\$session_longops
       where time_remaining > 0
        and opname like 'RMAN%';
    set linesize 200
    set pages 100
    col TIME_TAKEN_DISPLAY for a20
    col INPUT_BYTES_DISPLAY for a20
    col OUTPUT_BYTES_DISPLAY for a20
    col OUTPUT_DEVICE_TYPE for a20
    col INPUT_TYPE for a15
    col STATUS for a25
    select start_time,end_time,output_device_type,input_type,status,time_taken_display,input_bytes_display,output_bytes_display 
    from V\$RMAN_BACKUP_JOB_DETAILS 
    where input_type='DB FULL' order by start_time desc; 
exit
EOF
        sleep 10
done