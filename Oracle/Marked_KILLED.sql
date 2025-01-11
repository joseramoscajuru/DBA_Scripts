#Lidando com sesses marcadas como KILLED
#Notas do Metalink:
Note:1023442.6
Note:100859.1  ALTER SYSTEM KILL SESSION does not Release Locks Killing a 
                    Thread on Windows NT
Note:1041427.6 KILLING INACTIVE SESSIONS DOES NOT REMOVE SESSION ROW FROM 
                    V$SESSION
Note:1023442.6 HOW TO HAVE ORACLE CLEAN-UP OLD USER INFO AFTER KILLING 
                    SESSION UNDER MTS
Note:387077.1  How to find the process identifier (pid, spid) after the 
                    corresponding session is killed?


set lines 100 pages 999
col "SID,SERIAL#" format a17
col DB_USER    format a15
col OSUSER format a10
select TO_CHAR(s.SID)||','||TO_CHAR(s.SERIAL#) "SID,SERIAL#", s.USERNAME DB_USER, s.OSUSER OS_USER, p.PID, p.PROGRAM, q.sql_text " "
from V$SESSION s, V$PROCESS p, V$SQL q
where s.PADDR = p.ADDR and s.prev_hash_value = q.hash_value
and s.sid=&sid;


select s.inst_ID||'-'||CHR(39)||TO_CHAR(s.sid)||','||TO_CHAR(s.serial#)||CHR(39) SID,s.username, 
s.status, decode(s.program,NULL,machine,s.program) program, s.machine,
p.spid, to_char(s.logon_time,'DD/MM/YY hh24:mi:ss') Logon, s.sql_address
from v$session s, 
v$process p
where s.paddr = p.addr
and s.sid=&sid;


uss1udb009amprb
130.103.12.112

select sid,serial#,STATUS from v$session where paddr not in (select addr from v$process) and username is not null;

select sid, serial#, status from v$session where sid=124;

SELECT spid, osuser, s.program 
                FROM v$process p, v$session s 
                WHERE p.addr=s.paddr
				and s.sid=124;


select spid, program from v$process 
    where program!= 'PSEUDO' 
    and addr not in (select paddr from v$session)
    and addr not in (select paddr from v$bgprocess)
    and addr not in (select paddr from v$shared_server);

	select * from v$process where addr=(select creator_addr from v$session where sid=124);










					
					KILLING INACTIVE SESSIONS DOES NOT REMOVE SESSION ROW FROM V$SESSION [ID 1041427.6] 

--------------------------------------------------------------------------------
 
  Modified 25-JAN-2012     Type PROBLEM     Status PUBLISHED   


***Checked for relevance on 25-Jan-2012***

Problem Description 
=================== 

You used alter system kill session or Instance Manager disconnect and some 
sessions delete from Instance Manager and v$session but others remain. 
 
In Instance Manager some sessions show a status of killed.  When you query the 
status on columns status and server in v$session the status shows killed and 
the server shows as pseudo.  They are not cleared until the database is 
brought down and back up.

set lines 100 pages 999
col "SID,SERIAL#" format a17
col DB_USER    format a15
col OSUSER format a10
select TO_CHAR(s.SID)||','||TO_CHAR(s.SERIAL#) "SID,SERIAL#", s.USERNAME DB_USER, s.OSUSER OS_USER, p.PID, p.PROGRAM, q.sql_text " "
from V$SESSION s, V$PROCESS p, V$SQL q
where s.PADDR = p.ADDR and s.prev_hash_value = q.hash_value
and p.spid = '20899';

(20897, 20899, 21213, 14108, 20930, 21026,  3083, 27280, 27282,  8084, 20958,  8103,  7905,  7997, 20014, 24055, 24049, 24103);
/

select s.inst_ID||'-'||CHR(39)||TO_CHAR(s.sid)||','||TO_CHAR(s.serial#)||CHR(39) SID,s.username, 
s.status, decode(s.program,NULL,machine,s.program) program, s.machine,
p.spid, to_char(s.logon_time,'DD/MM/YY hh24:mi:ss') Logon, s.sql_address
from gv$session s, 
gv$process p
where s.paddr = p.addr
and s.sid=124;

