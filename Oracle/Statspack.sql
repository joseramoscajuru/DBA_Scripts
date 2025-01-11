#SELECT para checar o "level" atual
select NAME DB, SNAP_ID, to_char(snap_time,'DD.MM.YYYY:HH24:MI:SS') "Date/Time", SNAP_LEVEL from stats$snapshot,v$database where to_char(snap_time,'DD.MM.YYYY')='04.02.2012';

#Comando para alterar o "level" para 7
exec statspack.snap(i_snap_level => 7, i_modify_parameter => 'true');

#SELECT para exibir descritivo com diferenas entre os levels
SELECT * FROM stats$level_description ORDER BY snap_level;

#Script "default" oracle para gerar relatrio statspack (Oracle 9i)
@?/rdbms/admin/spreport



script para fazer o purge:

# First, we must set the environment . . . .
ORACLE_SID=$1
export ORACLE_SID
ORACLE_HOME=`cat /etc/oratab|grep ^$ORACLE_SID:|cut -f2 -d':'`
export ORACLE_HOME
PATH=$ORACLE_HOME/bin:$PATH
export PATH
$ORACLE_HOME/bin/sqlplus system/dEABK8KG<<!
select * from v\$database;
connect perfstat/perfstat
define losnapid=79928
define hisnapid=166667
@$ORACLE_HOME/rdbms/admin/sppurge
exit
!

begin
for i in 1..100000 loop 
UPDATE security
SET    display_security_alias = Concat('BAD_ALIAS_',display_security_alias)
WHERE  display_security_alias not like 'BAD_ALIAS%'
and  security_id 
IN (SELECT  security_id
    FROM   security_xref
    WHERE  security_alias_type 
       IN ('BADSYMBOL','ERRORSYMBOL','BADCUSIP','ERRORCUSIP'))
and rownum <= 500 ;
exit when sql%rowcount = 0
commit ; 
end loop ; 
commit ;
end ;
/

BEGIN
LOOP
DELETE /*+ index_ffs(st)*/
FROM perfstat.stats$sqltext st
WHERE (old_hash_value, text_subset) NOT IN (
SELECT /*+ hash_aj full(ss) no_expand*/ hash_value, text_subset
FROM perfstat.stats$sql_summary ss
WHERE snap_id NOT IN (SELECT DISTINCT snap_id FROM perfstat.stats$snapshot)
) AND ROWNUM<=10000;
EXIT WHEN SQL%ROWCOUNT = 0;
COMMIT;
END LOOP;
COMMIT;
END;
/ 

begin
for i in 1..100000 loop 
DELETE /*+ index_ffs(st)*/
FROM perfstat.stats$sqltext st
WHERE (hash_value, text_subset) NOT IN (
SELECT /*+ hash_aj full(ss) no_expand*/ hash_value, text_subset
FROM perfstat.stats$sql_summary ss
WHERE snap_id NOT IN (SELECT DISTINCT snap_id FROM perfstat.stats$snapshot)
) AND ROWNUM<=10000;
exit when sql%rowcount = 0
commit ; 
end loop ; 
commit ;
end ;
/

'sqlplus -s / as sysdba <<EOF
   whenever sqlerror exit sql.sqlcode;
   set echo off 
   set heading off

   shutdown immediate
   startup mount
   alter database noarchivelog;
   alter database open;

   exit;
EOF
'

'sqlplus -s / as sysdba <<EOF
begin
for i in 1..100000 loop 
DELETE /*+ index_ffs(st)*/
FROM perfstat.stats$sqltext st
WHERE (hash_value, text_subset) NOT IN (
SELECT /*+ hash_aj full(ss) no_expand*/ hash_value, text_subset
FROM perfstat.stats$sql_summary ss
WHERE snap_id NOT IN (SELECT DISTINCT snap_id FROM perfstat.stats$snapshot)
) AND ROWNUM<=10000;
exit when sql%rowcount = 0
commit ; 
end loop ; 
commit ;
end ;
/
exit;
EOF
'

while true; do 
sqlplus -s / as sysdba <<EOF
set feedback on serveroutput on timing on
select count(*) from perfstat.stats\$sqltext;
exit;
EOF
sleep 20
done


339417



while true; do date >> /var/log/perfmon.log; sleep 300; done &
vmstat 300 >> /var/log/perfmon.log &
