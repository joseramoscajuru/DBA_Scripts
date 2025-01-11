# Verifique o motivo da espera
	$ sqlplus "/ as sysdba"
	SQL> select sid, seconds_in_wait as secs, event
            from v$session_wait
           where wait_time = 0
             and event like '%sbt%'
        order by sid;

	* Se a espera em segundos for maior que 8000, ento o RMan deve estar esperando por fita, informe o time de backup

# Verificando o tempo de backup em fita
	$ sqlplus "/ as sysdba"
	SQL> select sid,
                opname,
                target,
                sofar,
                totalwork,
                units,
                (totalwork-sofar)/time_remaining bps,
                time_remaining,
                sofar/totalwork*100 fertig
           from v$session_longops
          where time_remaining > 0
            and opname like 'RMAN%';

