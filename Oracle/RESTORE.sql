#Exemplo de restore usado na Nisouce
Baixar o BD e depois
rman target / catalog rman/prd03mar@RCATPRD10

startup nomount;

run {
     allocate channel t1 type 'sbt_tape' PARMS='ENV=(TDPO_OPTFILE=/usr/tivoli/tsm/client/oracle/bin64/tdpo.opt)';
     set until time "to_date('16-02-2012 22:00:00','dd-mm-yyyy hh24:mi:ss')";
      RESTORE DATABASE ;
    }


#Exemplo de restore/recover feito na Whirlpool (Voltar o BD as 09:00:00)
shutdown immediate
startup mount
rman target / nocatalog
RUN
{
    allocate channel t1 type sbt parms 'ENV=(TDPO_OPTFILE=/usr/tivoli/tsm/client/oracle/bin64/tdpo_orp3.opt)';
    restore database until time "to_date('2012-05-18 09:00:00', 'yyyy-mm-dd hh24:mi:ss')";
    release channel t1;
}

RUN
{
    allocate channel t1 type sbt parms 'ENV=(TDPO_OPTFILE=/usr/tivoli/tsm/client/oracle/bin64/tdpo_orp3.opt)';    
    recover database until time "to_date('2012-05-18 09:00:00', 'yyyy-mm-dd hh24:mi:ss')";
    release channel t1;
}


#Restaurar achives de backup para poder completar o recover
restore archivelog from logseq = 47330 until logseq = 47337;

#Abrir o BD aps o procedimento
alter database open resetlogs

#Para acompanhar RESTORE
while true
do
sqlplus -s "/ as sysdba" << EOF

set linesize 180 pages 300
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

exit
EOF
sleep 20
done

