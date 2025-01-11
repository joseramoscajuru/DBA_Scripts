
SQL_ID = d03bg3xa7cz3d

declare
 l_sql_tune_task_id varchar2(100);
begin
 l_sql_tune_task_id := dbms_sqltune.create_tuning_task (
  begin_snap => 19055, 
  end_snap => 19060,
  sql_id => 'c5t47a6ksfxvt',
  scope => dbms_sqltune.scope_comprehensive,
  time_limit => 4800,
  task_name => 'task_c5t47a6ksfxvt2',
  description => 'sql_id c5t47a6ksfxvt snaps 19058,19060');
 dbms_output.put_line('l_sql_tune_task_id: ' || l_sql_tune_task_id);
end;
/

begin
DBMS_SQLTUNE.EXECUTE_TUNING_TASK(task_name => 'task_c5t47a6ksfxvt2');
end;
/

Este último pego o resultado do advisor :

set long 999999999
set lines 190
col recommendations for a180
set pages 500
SELECT DBMS_SQLTUNE.REPORT_TUNING_TASK('task_c5t47a6ksfxvt2') AS recommendations FROM dual;