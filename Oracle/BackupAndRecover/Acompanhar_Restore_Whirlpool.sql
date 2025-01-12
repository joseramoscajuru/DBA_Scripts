#Script passado pela Juliana
#Monitorando o restore para mim,  so rodar um scriptzinho no server

while true
do
	    sqlplus -s "/ as sysdba" << EOF

			  set linesize 180 pages 200
			  col sid format 99999
			  col opname format a35
			  col target format a10
			  col units format a15
			  col timeremaining format 999999990 heading Remaining[Min]
			  col bps format 99999990.99 heading [Units/s]
			  col fertig format 90.99 heading "complete[%]"
			  col endat heading "Fisnish at"

			  col "User" format a15
			  col program format a30
			  col module format a30
			  col action format a20

			  select sid,
					 opname,
					 (totalwork-sofar)/time_remaining bps,
					 time_remaining/60 timeremaining,
					 sofar/totalwork*100 fertig,
					 to_char(sysdate + TIME_REMAINING/3600/24, 'yyyy-mm-dd hh24:mi:ss') endat
				from v\$session_longops
			   where 
				time_remaining > 0;
				-- and upper(opname) like '%RMAN%';

	       exit
EOF
	    sleep 10
done    


while true
do
        sqlplus -s "/ as sysdba" << EOF

      set linesize 1000 pages 100
      col sid format 99999
      col opname format a35
      col target format a10
      col units format a15
      col time_remaining format 999990 heading Remaining[s]
      col bps format 99990.99 heading [Units/s]
      col fertig format 90.99 heading "complete[%]"
      col endat heading "Fisnish at"
	  col message format a80
      col "User" format a15
      col program format a30
      col module format a30
      col action format a20

-- select t.sql_text,s.sid, s.serial#,s.username,s.status
-- from v\$session s, V\$sql t
-- where t.hash_value=s.sql_hash_value
-- and s.program like '%brspace%';

SELECT s.sid,s.serial#,TO_CHAR(start_time,'dd-mon-yyyy HH24:MI:SS') AS "START",
round((sofar/totalwork)*100,2) AS "%COMPLETE",sw.State, sw.SECONDS_IN_WAIT , l.message,s.event
from v\$session_longops l, V\$SESSION s, V\$SESSION_WAIT sw
where s.SID=sw.SID
and s.SID=l.SID
and upper(s.program) like '%RMAN%'
and totalwork <> 0
order by sid;

           exit
EOF
        sleep 10
done
