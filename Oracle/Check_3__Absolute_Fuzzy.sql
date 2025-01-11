
Check 3: Absolute Fuzzy

Objective: Additional Fuzzy check (Absolute Fuzzy check)


Occasionally, it is possible to see Fuzzy=NO and same checkpoint_change# 
for all the intended datafiles but OPEN RESETLOGS still fails

eg:

select fuzzy, status, error, recover, checkpoint_change#, checkpoint_time, count(*) 
from v$datafile_header 
group by fuzzy, status, error, recover, checkpoint_change#, checkpoint_time ;

FUZ STATUS  ERROR           REC CHECKPOINT_CHANGE#      CHECKPOINT_TIME   COUNT(*)
--- ------- --------------- --- ------------------ -------------------- ----------
NO  ONLINE                                 5311260 31-AUG-2011 23:10:14          7


SQL> ALTER DATABASE OPEN RESETLOGS ;

ORA-01194: file 4 needs more recovery to be consistent
ORA-01110: data file 3: '/<path>/undotbs02.dbf'


Hence, we should perform additional fuzzy check known as Absolute Fuzzy Check:


select hxfil file#, substr(hxfnm, 1, 50) name, fhscn checkpoint_change#, 
       fhafs Absolute_Fuzzy_SCN, max(fhafs) over () Min_PIT_SCN 
from x$kcvfh 
where fhafs!=0 ;

FILE#      NAME                                               CHECKPOINT_CHANG ABSOLUTE_FUZZY_S     MIN_PIT_SCN
---------- -------------------------------------------------- ---------------- ---------------- ----------------
         4 /<path>/undotbs01.dbf                                  5311260          5311524          5311524
         6 /<path>/system01.dbf                                   5311260          5311379          5311524
         
Note: Column Min_PIT_SCN will return same value even for multiple rows as we have applied 
ANALYTICAL "MAX() OVER ()" function on it.

Above query indicates that the recovery must be performed at least UNTIL SCN 5311524 to make datafiles 
consistent and ready to OPEN. Since the checkpoint_change# is smaller than Min_PIT_SCN, 
the datafiles will ask for more recovery.

 
Check 3 can be considered PASSED when:

a) No rows selected from above query (i.e. Min_PIT_SCN is 0 (Zero) for all the datafiles)

b) Min_PIT_SCN is returned less than Checkpoint_Change#