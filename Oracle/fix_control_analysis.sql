Oracle has introduced a fix control mechanism in 10.2 which allows customers to turn off fixes for optimizer related bugs. This is governed by the underscore parameter fixcontrol. The bugs for which fixes can be turned off are listed in v$session_fix_control and v$system_fix_control and can also be seen in a 10053 output.

On a 10.2.0.2 database

SQL> select distinct bugno from v$session_fix_control;

BUGNO
----------
3499674
4556762
4569940
3118776
4519016
4175830
4663698
4631959
4550003
4584065
4487253
4611850
4663804
4602374
4728348
4723244
4554846
4545833
4488689
4519340

20 rows selected.

SQL> select distinct sid from v$mystat;

SID
----------
143

SQL> alter session set "_fix_control"='4728348:OFF';

Session altered.

SQL> select * from v$session_fix_control where session_id=143 and bugno=4728348;

SESSION_ID BUGNO VALUE DESCRIPTION OPTIMIZER_FEATURE_ENABLE EVENT IS_DEFAULT
---------- ---------- ---------- ---------------------------------------------------------------- --
143 4728348 0 consider mjc if equi-joined pred is dropped in kkoipt 10.2.0.2

A value of 0 indicates the fix is off.

SQL> alter session set "_fix_control"='4728348:ON';

Session altered.

SQL> select * from v$session_fix_control where session_id=143 and bugno=4728348;

SESSION_ID BUGNO VALUE DESCRIPTION OPTIMIZER_FEATURE_ENABLE EVENT IS_DEFAULT
---------- ---------- ---------- ---------------------------------------------------------------- --
143 4728348 1 consider mjc if equi-joined pred is dropped in kkoipt 10.2.0.2

It appears to me that if you need two fixes off in a session you have to specify them together else you lose the first change.

SQL> alter session set "_fix_control"='4728348:OFF';

Session altered.

SQL> alter session set "_fix_control"='4663698:OFF';

Session altered.

SQL> select * from v$session_fix_control where session_id=143 and bugno in (4728348,4663698);

SESSION_ID BUGNO VALUE DESCRIPTION OPTIMIZER_FEATURE_ENABLE EVENT IS_DEFAULT
---------- ---------- ---------- ---------------------------------------------------------------- --
143 4663698 0 for cached NL table set tab_cost_io to zero 10.2.0.2 0 0
143 4728348 1 consider mjc if equi-joined pred is dropped in kkoipt 10.2.0.2

Hence if you need more than one fix OFF you need to supply both bug numbers in the same command

SQL> alter session set "_fix_control"='4728348:OFF','4663698:OFF';

Session altered.

SQL> select * from v$session_fix_control where session_id=143 and bugno in (4728348,4663698);

SESSION_ID BUGNO VALUE DESCRIPTION OPTIMIZER_FEATURE_ENABLE EVENT IS_DEFAULT
---------- ---------- ---------- ---------------------------------------------------------------- --
143 4663698 0 for cached NL table set tab_cost_io to zero 10.2.0.2 0 0
143 4728348 0 consider mjc if equi-joined pred is dropped in kkoipt 10.2.0.2

