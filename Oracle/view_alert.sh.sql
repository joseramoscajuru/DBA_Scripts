#!/usr/bin/bash -xv
#
# Filename: view_alert.sh
#
# DESCRIPTION
# Edit alert log file according the current settings from ". oraenv" command
#
#set -xv ## uncomment to debug
#
# Setup environment
#

ALERTDIR=`$ORACLE_HOME/bin/sqlplus -s "/ as sysdba" <<EOF
       set heading off feedback off verify off
       select value from v\\$parameter
       where name='background_dump_dest';
       exit
EOF`

#ALERTDIR=`grep background_dump_dest $ORACLE_HOME/dbs/init$ORACLE_SID.ora | awk -F= '{print $2}'`
#ALERTDIR= "Your Alert dir dest"
ALERTDIR=`echo $ALERTDIR | sed 's/^[ \t]*//'` # strip off leading tabs and white spaces
ALERTLOG=$ALERTDIR/alert_$ORACLE_SID.log
echo "Alert log location path: $ALERTLOG"
sleep 3
vi $ALERTLOG