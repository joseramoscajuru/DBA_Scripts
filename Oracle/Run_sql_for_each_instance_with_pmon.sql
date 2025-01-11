for db in $(ps -ef | grep pmon | grep -v grep | grep -v ASM| cut -d_ -f3| sort)
do
export ORACLE_SID=$db
#export ORACLE_HOME=`sed /#/d /var/opt/oracle/oratab | grep -w "${ORACLE_SID}:" | awk -F: '{print $2}'`
export ORACLE_HOME=`sed /#/d /etc/oratab | grep -w "${ORACLE_SID}:" | awk -F: '{print $2}'`
export PATH=$ORACLE_HOME/bin:$PATH

sqlplus -s /nolog <<__eof__
connect / as sysdba
set lines 180 pages 1000 head off
col name for a30
col value for a40
set serveroutput on echo on
prompt ################################
prompt $ORACLE_SID
<colocar sua query aqui>
prompt ################################
prompt
exit

__eof__