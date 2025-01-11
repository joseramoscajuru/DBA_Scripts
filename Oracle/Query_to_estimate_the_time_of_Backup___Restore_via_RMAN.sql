Below, a query to be executed on target database or database auxiliary ( in the case of duplicate) to estimate the time of restore and the completed percentage .

col OPNAME for a30
select OPNAME,SOFAR/TOTALWORK*100 PCT, trunc(TIME_REMAINING/60) MIN_RESTANTES,
trunc(ELAPSED_SECONDS/60) MIN_ATEAGORA
from v$session_longops where TOTALWORK>0 and upper(OPNAME) like '%RMAN%';


Output example of a duplicate:

OPNAME PCT MIN_RESTANTES MIN_ATEAGORA
------------------------------ ---------- ------------- ------------
RMAN: aggregate input 67.6037414 176 368
RMAN: full datafile restore 100 0 26
RMAN: full datafile restore 100 0 10
RMAN: full datafile restore 100 0 21
RMAN: full datafile restore 100 0 22
RMAN: full datafile restore 100 0 20
RMAN: full datafile restore 100 0 51
RMAN: full datafile restore 49.1620893 26 25
RMAN: full datafile restore 100 0 32
RMAN: full datafile restore 100 0 26
RMAN: full datafile restore 100 0 20
RMAN: full datafile restore 100 0 27
RMAN: full datafile restore 100 0 26
RMAN: full datafile restore 100 0 19
RMAN: full datafile restore 100 0 52
RMAN: full datafile restore 49.4441805 25 24


Reading the Output:

The line ( RMAN: aggregate input ) is the sum of total and it is showing that was executed 67,60% of total of restore, and took until now, 368 minutes, and estimates that rest 176 minutes.

The other lines are of partials ( RMAN: full datafile restore ), we have many completed ( pct=100) , and two restore of pieces in execution, that will still take 26 minutes, the first, and 25 minutes the second.
