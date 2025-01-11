
SQL> SELECT client_name, status, consumer_group, window_group
FROM dba_autotask_client
ORDER BY client_name;  2    3  

CLIENT_NAME                                                      STATUS   CONSUMER_GROUP                 WINDOW_GROUP
---------------------------------------------------------------- -------- ------------------------------ ----------------------------------------------------------------
auto optimizer stats collection                                  DISABLED ORA$AUTOTASK_STATS_GROUP       ORA$AT_WGRP_OS
auto space advisor                                               ENABLED  ORA$AUTOTASK_SPACE_GROUP       ORA$AT_WGRP_SA
sql tuning advisor                                               DISABLED ORA$AUTOTASK_SQL_GROUP         ORA$AT_WGRP_SQ


SELECT window_name,TO_CHAR(window_next_time,'DD-MON-YY HH24:MI:SS')
,sql_tune_advisor, optimizer_stats, segment_advisor
FROM dba_autotask_window_clients; 

WINDOW_NAME                    TO_CHAR(WINDOW_NEXT_TIME SQL_TUNE OPTIMIZE SEGMENT_
------------------------------ ------------------------ -------- -------- --------
MONDAY_WINDOW                  22-APR-19 22:00:00       DISABLED DISABLED DISABLED
TUESDAY_WINDOW                 16-APR-19 22:00:00       DISABLED DISABLED DISABLED
WEDNESDAY_WINDOW               17-APR-19 22:00:00       DISABLED DISABLED DISABLED
THURSDAY_WINDOW                18-APR-19 22:00:00       DISABLED DISABLED DISABLED
FRIDAY_WINDOW                  19-APR-19 22:00:00       DISABLED DISABLED DISABLED
SATURDAY_WINDOW                20-APR-19 06:00:00       DISABLED DISABLED DISABLED
SUNDAY_WINDOW                  21-APR-19 06:00:00       DISABLED DISABLED ENABLED

7 rows selected.


BEGIN
DBMS_AUTO_TASK_ADMIN.ENABLE(
client_name => 'sql tuning advisor',
operation => NULL,
window_name => 'TUESDAY_WINDOW');
END;
/

BEGIN
DBMS_AUTO_TASK_ADMIN.DISABLE(
client_name => 'sql tuning advisor',
operation => NULL,
window_name => 'MONDAY_WINDOW');
END;
/

BEGIN
DBMS_AUTO_TASK_ADMIN.DISABLE(
client_name => 'sql tuning advisor',
operation => NULL,
window_name => 'TUESDAY_WINDOW');
END;
/

BEGIN
DBMS_AUTO_TASK_ADMIN.DISABLE(
client_name => 'sql tuning advisor',
operation => NULL,
window_name => 'WEDNESDAY_WINDOW');
END;
/

BEGIN
DBMS_AUTO_TASK_ADMIN.DISABLE(
client_name => 'sql tuning advisor',
operation => NULL,
window_name => 'THURSDAY_WINDOW');
END;
/

BEGIN
DBMS_AUTO_TASK_ADMIN.DISABLE(
client_name => 'sql tuning advisor',
operation => NULL,
window_name => 'FRIDAY_WINDOW');
END;
/

BEGIN
DBMS_AUTO_TASK_ADMIN.DISABLE(
client_name => 'sql tuning advisor',
operation => NULL,
window_name => 'SATURDAY_WINDOW');
END;
/


WINDOW_NAME                    TO_CHAR(WINDOW_NEXT_TIME SQL_TUNE OPTIMIZE SEGMENT_
------------------------------ ------------------------ -------- -------- --------
MONDAY_WINDOW                  22-APR-19 22:00:00       DISABLED DISABLED DISABLED
TUESDAY_WINDOW                 16-APR-19 22:00:00       DISABLED DISABLED DISABLED
WEDNESDAY_WINDOW               17-APR-19 22:00:00       DISABLED DISABLED DISABLED
THURSDAY_WINDOW                18-APR-19 22:00:00       DISABLED DISABLED DISABLED
FRIDAY_WINDOW                  19-APR-19 22:00:00       DISABLED DISABLED DISABLED
SATURDAY_WINDOW                20-APR-19 06:00:00       DISABLED DISABLED DISABLED
SUNDAY_WINDOW                  21-APR-19 06:00:00       ENABLED  DISABLED ENABLED

7 rows selected.
