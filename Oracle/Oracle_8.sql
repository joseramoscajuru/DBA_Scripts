#Local do alert.log
select value from v$parameter where name='background_dump_dest';

Checar se o servio est iniciado no SERVICES do Windows.

From c:\> 
set ORACLE_SID=ASTA
set local=ASTA

(o SVRMGR30 pode estar no c:\orant\bin)

SVRMGR30
CONNECT INTERNAL
Password:xxxx
STARTUP

#Estender segmento de rollback
ALTER ROLLBACK SEGMENT R03 STORAGE (UNLIMITED);

