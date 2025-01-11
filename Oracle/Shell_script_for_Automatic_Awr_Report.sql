
https://community.oracle.com/tech/developers/discussion/2527513/shell-script-for-automatic-awr-report

#!/bin/ksh
set -x
ORACLE_SID=DBSID
ORACLE_HOME=/u01/app/ora11g/product/11.2.0/db_1
export ORACLE_HOME
TERM=vt100
export TERM
PATH=/usr/bin:/etc:/usr/sbin:/usr/ucb:/usr/local/bin:/usr/bin/X11:/bin:/sbin:.
PATH=$ORACLE_HOME/bin:$PATH
export DT=`date '+%d_%b_%Y_%HH_%MM'`
export ORACLE_BASE ORACLE_SID ORACLE_HOME PATH DT
echo $DT
MAIL="ajay.more@abc.com"
CMAIL="ajay.more@abc.com"
AWRR="/u01/DBA_Scripts/AWR_REPO"

sqlplus -s "/ as sysdba"<<EOFSQL
set head off
set feed off
spool /tmp/bsnap.lst
select max(SNAP_ID)- 3 from dba_hist_snapshot;
spool off
spool /tmp/esnap.lst
select max(SNAP_ID) from dba_hist_snapshot;
spool off
spool /tmp/iname.lst
select instance_name from v\$instance;
spool off
spool /tmp/dname.lst
select database_name from v\$database;
spool off
spool /tmp/inum.lst
select instance_number from v\$instance;
spool off
spool /tmp/dbid.lst
select dbid from v\$database;
spool off
EOFSQL

BSNAP=`cat /tmp/bsnap.lst | tail -1 | awk '{ print $1}'`;export BSNAP
ESNAP=`cat /tmp/esnap.lst | tail -1 | awk '{ print $1}'`;export ESNAP
INAME=`cat /tmp/iname.lst | tail -1 | awk '{ print $1}'`;export INAME
DNAME=`cat /tmp/dname.lst | tail -1 | awk '{ print $1}'`;export DNAME
INUM=`cat /tmp/inum.lst | tail -1 | awk '{ print $1}'`;export INUM
DID=`cat /tmp/dbid.lst| tail -1 | awk '{ print $1}'`;export DID

echo "Begin Snap  : $BSNAP"
echo "End Snap    : $ESNAP"
#echo "InstanceName: $INAME"
echo "DB Name     : $DNAME"
#echo "InstanceId  : $INUM"
echo "DB ID       : $DID"


sqlplus -s "/ as sysdba"<<EOFSQL
      define  inst_num     = $INUM;
      define  num_days     = 12;
      define  inst_name    = 'ALL';
      define  db_name      = '$DNAME';
      define  dbid         = $DID;
      define  begin_snap   = $BSNAP;
      define  end_snap     = $ESNAP;
      define  report_type  = 'html';
      define  report_name  = $AWRR/Awr_report_$DT.html
      @@?/rdbms/admin/awrgrpti

EOFSQL

cat /u01/DBA_Scripts/mail_body.txt | mailx -a $AWRR/Awr_report_$DT.html -c $CMAIL -s "DB Report - DB "  $MAIL
