Para a criação do SQL Tuning task, vou utilizar as informações encontradas no AWR, então irei informar o snap_id inicial e final para identificar o período em que o SQL foi executado.

DECLARE
  l_sql_tune_task_id  VARCHAR2(100);
BEGIN
  l_sql_tune_task_id := DBMS_SQLTUNE.create_tuning_task (
                          begin_snap  => 43996,
                          end_snap    => 43997,
                          sql_id      => '2sk15bdfc6gaf',
                          scope       => DBMS_SQLTUNE.scope_comprehensive,
                          time_limit  => 1200,
                          task_name   => '2sk15bdfc6gaf_AWR_tuning_task',
                          description => 'Tuning task for statement 2sk15bdfc6gaf in AWR.');
  DBMS_OUTPUT.put_line('l_sql_tune_task_id: ' || l_sql_tune_task_id);
END;
/

Obs.: O paramêtro scope recebe o valor SCOPE_COMPREHENSIVE para que também seja gerados SQL Profiles, se possível.

Executando o SQL Tuning Task

EXEC DBMS_SQLTUNE.execute_tuning_task(task_name => '2sk15bdfc6gaf_AWR_tuning_task');

SELECT DBMS_SQLTUNE.report_tuning_task('2sk15bdfc6gaf_AWR_tuning_task') AS recommendations FROM dual; 
