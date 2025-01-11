while true
do
sqlplus -s "/ as sysdba" << EOF

set linesize 180
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
and upper(opname) like 'RMAN%';

exit
EOF
sleep 3
done