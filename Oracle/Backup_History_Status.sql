
set lines 250 pages 300
col STATUS form a25
col INPUT_BYTES_DISPLAY form a10
col OUTPUT_BYTES_DISPLAY form a10

select  INPUT_TYPE, STATUS,
to_char(START_TIME,'mm/dd/yy hh24:mi') start_time,
to_char(END_TIME,'mm/dd/yy hh24:mi') end_time,
round(elapsed_seconds/60,2) TIMETAKEN_MIN,INPUT_BYTES_DISPLAY,OUTPUT_BYTES_DISPLAY,COMPRESSION_RATIO
from V$RMAN_BACKUP_JOB_DETAILS 
where INPUT_TYPE <> 'ARCHIVELOG';

set lines 250 pages 300
col STATUS form a25
col INPUT_BYTES_DISPLAY form a10
col OUTPUT_BYTES_DISPLAY form a10

select  INPUT_TYPE, STATUS,
to_char(START_TIME,'mm/dd/yy hh24:mi') start_time,
to_char(END_TIME,'mm/dd/yy hh24:mi') end_time,
round(elapsed_seconds/60,2) TIMETAKEN_MIN,INPUT_BYTES_DISPLAY,OUTPUT_BYTES_DISPLAY,COMPRESSION_RATIO
from V$RMAN_BACKUP_JOB_DETAILS 
where INPUT_TYPE = 'ARCHIVELOG';