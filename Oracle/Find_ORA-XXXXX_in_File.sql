oerr ora <codigo do erro>

BEFORE=2
AFTER=3
FILE=file.txt
PATTERN=pattern
for i in $(grep -n $PATTERN $FILE | sed -e 's/\:.*//')
  do head -n $(($AFTER+$i)) $FILE | tail -n $(($AFTER+$BEFORE+1))
done

