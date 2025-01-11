BEFORE=2
AFTER=3
FILE=/debug/oracle/diag/rdbms/udsp/UDSP/trace/alert_UDSP.log
PATTERN=ORA-00020
for i in $(grep -n $PATTERN $FILE | sed -e 's/\:.*//')
  do head -n $(($AFTER+$i)) $FILE | tail -n $(($AFTER+$BEFORE+1))
done > ora00020_errors.lst &