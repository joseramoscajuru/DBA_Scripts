

-- EXCLUIR JOB CASO ELE J EXISTA

BEGIN
DBMS_SCHEDULER.DROP_JOB (
   job_name   =>  'NOME_DO_JOB',
   force      =>  TRUE);
END;

-- CRIA JOB

BEGIN
    DBMS_SCHEDULER.create_job (job_name => 'JOB_NOME_DO_JOB',
                               job_type => 'STORED_PROCEDURE',
                               job_action => 'SP_XXXX',
                               repeat_interval => 'FREQ=DAILY; BYHOUR=10,12,14,16,18,20,22; BYMINUTE=0; BYSECOND=0',
                               end_date => NULL,
                               enabled => TRUE,
                               comments => 'Teste');
End;
/