#!/bin/ksh
SERVICE=’ora_pmon_SWX’
if ps -ef | grep -v grep | grep $SERVICE > /dev/null
then
#. $HOME/shell/.swx_profile
. $HOME/.profile
cd /u1/oracle/OraSWX/admin/SWX/bdump
rm -f alert.err
rm -f alert_work.log
if [ -f alert_${ORACLE_SID}.log ]
then
mv alert_${ORACLE_SID}.log alert_work.log
touch alert_${ORACLE_SID}.log
cat alert_work.log >> alert_${ORACLE_SID}.hist
grep ORA- alert_work.log > alert.err
fi
if [ `cat /u1/oracle/OraSWX/admin/SWX/bdump/alert.err|wc -l` -gt 0 ]
then
cd  /u1/oracle/OraSWX/admin/SWX/bdump|mailx -s “`hostname`:${ORACLE_SID}:Error in Alert Logfile `date`” abc@xyz.com </u1/oracle/OraSWX/admin/SWX/bdump/alert.err
fi
else
echo “$SERVICE is not running”
fi

