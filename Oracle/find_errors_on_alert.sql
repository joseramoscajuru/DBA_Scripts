
BEFORE=2
AFTER=3
FILE=/u01/app/oracle/diag/rdbms/dbmspprd/DBMSPPRD/trace/alert_DBMSPPRD.log
PATTERN=ORA-00600
for i in $(grep -n $PATTERN $FILE | sed -e 's/\:.*//')
  do head -n $(($AFTER+$i)) $FILE | tail -n $(($AFTER+$BEFORE+1))
done > shutdown_messages.lst &