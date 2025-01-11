
set pages 300 lines 1000
select owner, degree, count(*)
from dba_indexes
where degree > 1
group by owner, degree
order by 3 desc
/

OWNER                          DEGREE                                     COUNT(*)
------------------------------ ---------------------------------------- ----------
APEX_030200                    32                                              752
FDSPPRD                        16                                               96
FDSPPRD                        30                                               14
INTERFACE_RETAIL               32                                                3
VEROIT                         16                                                2
INTERFACE_COLETORES            16                                                1
SYSTEM                         64                                                1

7 rows selected.
