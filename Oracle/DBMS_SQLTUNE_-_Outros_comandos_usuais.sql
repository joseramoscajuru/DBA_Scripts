
Outros comandos usuais:
 
-- Interrompendo e reassumindo a execução

EXEC DBMS_SQLTUNE.interrupt_tuning_task (task_name => '2sk15bdfc6gaf_AWR_tuning_task');

EXEC DBMS_SQLTUNE.resume_tuning_task (task_name => '2sk15bdfc6gaf_AWR_tuning_task'); 

-- Cancelando o SQL tuning task. 

EXEC DBMS_SQLTUNE.cancel_tuning_task (task_name => '2sk15bdfc6gaf_AWR_tuning_task'); 

-- Reiniciando o SQL Tuning Task, permintindo sua execução novamente. 

EXEC DBMS_SQLTUNE.reset_tuning_task (task_name => '2sk15bdfc6gaf_AWR_tuning_task');