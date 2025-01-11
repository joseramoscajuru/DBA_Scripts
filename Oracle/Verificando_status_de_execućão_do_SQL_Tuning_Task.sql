
SELECT task_name, status 
  FROM dba_advisor_log 
 WHERE task_name = '60rjr82rt64hf_AWR_tuning_task';
 owner = 'MARCUS_SOARES';


TASK_NAME                      STATUS
------------------------------ -----------
2sk15bdfc6gaf_AWR_tuning_task   COMPLETED


SELECT owner, task_name, execution_start, execution_end, status 
  FROM dba_advisor_log  
WHERE STATUS = 'EXECUTING'
 ORDER BY execution_start;
 
 The following example queries the status of the task with task ID 884:

VARIABLE my_tid NUMBER;  
EXEC :my_tid := 884
COL ADVISOR_NAME FORMAT a20
COL SOFAR FORMAT 999
COL TOTALWORK FORMAT 999

SELECT TASK_ID, ADVISOR_NAME, SOFAR, TOTALWORK, 
       ROUND(SOFAR/TOTALWORK*100,2) "%_COMPLETE"
FROM   V$ADVISOR_PROGRESS
WHERE  TASK_ID = :my_tid;
