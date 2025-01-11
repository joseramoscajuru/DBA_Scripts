a. Status

First, the query for the current state of the database in DBA_AUTOTASK_CLIENTS. Only in Enterprise Edition is the SQL Tuning Advisor ENABLED.

SQL> select client_name, status, attributes from dba_autotask_client;

CLIENT_NAME                        STATUS   ATTRIBUTES
---------------------------------  -------  ----------------------------------------
auto optimizer stats collection    ENABLED  ON BY DEFAULT, VOLATILE, SAFE TO KILL
auto space advisor                 ENABLED  ON BY DEFAULT, VOLATILE, SAFE TO KILL
sql tuning advisor                 ENABLED  ONCE PER WINDOW, ON BY DEFAULT, VOLATILE, SAFE TO KILL

 

As a further query the configured time window in DBA_AUTOTASK_WINDOW_CLIENTS:

select window_name, autotask_status, optimizer_stats from dba_autotask_window_clients;

WINDOW_NAME               AUTOTASK_STATUS  OPTIMIZER_STATS
------------------------  ---------------- ----------------
SUNDAY_WINDOW             ENABLED           ENABLED
SATURDAY_WINDOW           ENABLED           ENABLED
FRIDAY_WINDOW             ENABLED           ENABLED
THURSDAY_WINDOW           ENABLED           ENABLED
WEDNESDAY_WINDOW          ENABLED           ENABLED
TUESDAY_WINDOW            ENABLED           ENABLED
MONDAY_WINDOW             ENABLED           ENABLED

b. Activation / Deactivation

Quite generally, the auto tasks can be controlled with the DBMS_AUTO_TASK_ADMIN package.

To start and stop AUTO_TASKS enable or disable is sufficient.

exec dbms_auto_task_admin.disable;

select window_name, autotask_status, optimizer_stats from dba_autotask_window_clients;

WINDOW_NAME               AUTOTASK_STATUS  OPTIMIZER_STATS
------------------------  ---------------- ----------------
SUNDAY_WINDOW             DISABLED          ENABLED
SATURDAY_WINDOW           DISABLED          ENABLED
FRIDAY_WINDOW             DISABLED          ENABLED
THURSDAY_WINDOW           DISABLED          ENABLED
WEDNESDAY_WINDOW          DISABLED          ENABLED
TUESDAY_WINDOW            DISABLED          ENABLED
MONDAY_WINDOW             DISABLED          ENABLED

 

Following command deactivates only Optimizer Stats Collection:

begin  
dbms_auto_task_admin.disable(
    client_name => 'auto optimizer stats collection',
    operation => NULL,
    window_name => NULL);
end;
/

 

select window_name, autotask_status, optimizer_stats from dba_autotask_window_clients;

WINDOW_NAME               AUTOTASK_STATUS  OPTIMIZER_STATS
------------------------  ---------------- ----------------
SUNDAY_WINDOW             ENABLED           DISABLED
SATURDAY_WINDOW           ENABLED           DISABLED
FRIDAY_WINDOW             ENABLED           DISABLED
THURSDAY_WINDOW           ENABLED           DISABLED
WEDNESDAY_WINDOW          ENABLED           DISABLED
TUESDAY_WINDOW            ENABLED           DISABLED
MONDAY_WINDOW             ENABLED           DISABLED

 

SQL> select client_name, status from dba_autotask_client;

CLIENT_NAME                        STATUS   
---------------------------------  ---------        
auto optimizer stats collection    DISABLED 
auto space advisor                 ENABLED
sql tuning advisor                 ENABLED

 

c. Changing START time

If you want to change the start time, you have to adjust the REPEAT_INTERVAL. Below we will change for the MONDAY_WINDOW the start time to 5 clock with DBMS_SCHEDULER.SET_ATTRIBUTE:

begin  
dbms_scheduler.set_attribute(
    name      => 'MONDAY_WINDOW',
    attribute => 'repeat_interval',
    value     => 'freq=daily;byday=MON;byhour=5;byminute=0; bysecond=0');
end;
/

 

select window_name, repeat_interval, from dba_scheduler_windows where window_name = 'MONDAY_WINDOW';

WINDOW_NAME      REPEAT_INTERVAL
---------------- -----------------------------------------------------
MONDAY_WINDOW    freq=daily;byday=MON;byhour=5;byminute=0; bysecond=0

 

d. Changing DURATION

Is the time window of 4 hours not enough to work through all the tables and the Optimizer Statistics Collection runs out of the predetermined windows, the DURATION must be adjusted. Below, we set the window up to 5 hours.

begin
  dbms_scheduler.set_attribute(
    name      => 'MONDAY_WINDOW',
    attribute => 'duration',
    value     => numtodsinterval(5, 'hour'));
end;
/

select window_name, duration from dba_scheduler_windows where window_name = 'MONDAY_WINDOW';
 
WINDOW_NAME      REPEAT_INTERVAL
---------------  --------------------
MONDAY_WINDOW    +00 05:00:00.000000

  

e. Creating a new WINDOW

begin
  dbms_scheduler.create_window(
    window_name     => 'SPECIAL_WINDOW',
    duration        =>  numtodsinterval(3, 'hour'),
    resource_plan   => 'DEFAULT_MAINTENANCE_PLAN',
    repeat_interval => 'FREQ=DAILY;BYHOUR=10;BYMINUTE=0;BYSECOND=0');
  dbms_scheduler.add_group_member(
    group_name  => 'MAINTENANCE_WINDOW_GROUP',
    member      => 'SPECIAL_WINDOW');
end;
/