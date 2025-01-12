SQL> EXECUTE SYS.DBMS_SYSTEM.SET_EV(61,10232,10046,12,'');

PL/SQL procedure successfully completed.

SQL> EXECUTE SYS.DBMS_SYSTEM.set_sql_trace_in_session(61,10232,true);

PL/SQL procedure successfully completed.

SQL> show parameter user_du

NAME TYPE VALUE
------------------------------------ ----------- ------------------------------
user_dump_dest string /debug/oracle
SQL> select instance_name from v$instance; 

INSTANCE_NAME
----------------
NCWP4

SQL> EXECUTE SYS.DBMS_SYSTEM.set_sql_trace_in_session(61,10232,false);

PL/SQL procedure successfully completed.

SQL> select s.sid,s.serial#,p.spid,p.pid,s.username,s.osuser
from v$session s,v$process p
where s.paddr=p.addr and s.sid=61 and s.serial#=10232; 2 3 

SID SERIAL# SPID PID USERNAME
---------- ---------- ------------ ---------- ------------------------------
OSUSER
------------------------------
61 10232 24178940 144 ARTESIA
dmadmin


SQL> oradebug setospid 24178940;
 
depois explico essas . 
zhmscdp3......banco NCWP4 
SID SERIAL# PROGRAM STATUS
---------- ---------- ------------------------------------------------ --------
122 12889 JDBC Thin Client INACTIVE
217 38321 JDBC Thin Client INACTIVE
155 10544 JDBC Thin Client INACTIVE
129 9186 JDBC Thin Client ACTIVE
247 41114 JDBC Thin Client ACTIVE
224 59327 JDBC Thin Client ACTIVE
87 47869 ./documentum@adcudoccp1 (TNS V1-V3) INACTIVE
107 57711 ./documentum@adcudoccp1 (TNS V1-V3) INACTIVE
99 8818 ./documentum@adcudoccp1 (TNS V1-V3) INACTIVE
61 10232 JDBC Thin Client ACTIVE
 
v$session ...where username='ARTESIA' order by logon_time asc
