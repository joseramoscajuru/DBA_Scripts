#O Script gera uma lista de bancos e CPU patchies aplicados

for db in $(ps -ef | grep pmon | grep -v grep | cut -d_ -f3| sort)
do
SERVER_NAME=`hostname`
DATE=`date +%Y%m%d-%H%M`
export ORACLE_SID=$db
export ORACLE_HOME=`sed /#/d /var/opt/oracle/oratab | grep -w "${ORACLE_SID}:" | awk -F: '{print $2}'`
#export ORACLE_HOME=`sed /#/d /etc/oratab | grep -w "${ORACLE_SID}:" | awk -F: '{print $2}'`
export PATH=$ORACLE_HOME/bin:$PATH
export LIBPATH=$ORACLE_HOME/lib
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export OUTPUT_FILE=${SERVER_NAME}

sqlplus -s /nolog <<__eof__ >> ${OUTPUT_FILE}
connect / as sysdba

#At aqui o script cria uma lista de BDs instalados.

prompt MISC: #########################################
prompt MISC: #########################################
prompt MISC: #########################################
prompt MISC: 


select ' * ' || b.instance_name || '  ' || a.action_time || '  ' || comments from (select action_time,comments from sys.registry$history order by action_time desc) a,v$instance b where rownum<2;

rem ******************
set linesize 170
col instance_name format a15 heading "Instance|Name"
col host_name format a15 heading "Hostname"
col version format a10 heading "Version"
col comments format a20 heading "Patch|Applied"
col id heading "Patch|Number"
col to_char(r.action_time,'DD-Mon-YYYY@HH24:mi:ss') format a20 heading "Date"
rem ******************



prompt MISC: APPLIED CPU HISTORY BY DATE

select distinct i.instance_name, i.host_name, i.version, r.comments, r.id, to_char(r.action_time,'DD-Mon-YYYY@HH24:mi:ss')
from v$instance i, sys.registry$history r
where r.comments like 'CPU%' or r.comments like 'PSU%'
order by to_char(r.action_time,'DD-Mon-YYYY@HH24:mi:ss')
/

prompt MISC: #########################################
prompt MISC: #########################################
prompt MISC: #########################################
prompt MISC: 

exit



__eof__

cat ${OUTPUT_FILE} |grep ${db} >> lista.txt
rm ${OUTPUT_FILE}

done

