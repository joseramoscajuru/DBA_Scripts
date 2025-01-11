
-----------------------------------------------------------------------------------------------------------
-- Header:      gerador_awr.sql   03-dez-2014.22:15   $    FSX Scripts - Flavio Soares X Scripts
--
-- Filename:    gerador_awr.sql
--
-- Version:     v1
--
-- Purpose:     Gera AWR dinamicos sequencialmente, no  formato escolhido a partir de um range de SNAPID fornecido.
--
-- Modified:
--
-- Notes:       O gerador_awr.sql foi testado no Oracle  11g/12c, Single e RAC Instance
-- !!Para a execuÃ§Ã£o do script  Ã© necessÃ¡rio permissÃ£o de leitura/Escrita no diretÃ³rio atual da execuÃ§Ã£o!!
--                  
-- Usage:       SQL> @gerador_awr
--
-- Others:      
--
-- Author:      Flavio Soares 
-- Copyright:   (c) Flavio Soares - http://flaviosoares.com  - All rights reserved.
-------------------------------------------------------------------------------------------------------

SET TERMOUT OFF  STORE SET store_set_saved.sql  SET TERMOUT ON
SET FEEDBACK OFF SERVEROUTPUT  ON SQLBL ON LINES 5000 VERIFY OFF PAGES 2000

---- PROMPT ====> Showing the  AWR Settings Inverval/Retention
----   COLUMN  awr_env_interval_minutes    HEADING  "Minute|Snapshot Interval" 
----   COLUMN  awr_env_retention_minutes 
----     HEADING  "Minute|Snapshot Retention"      COLUMN  awr_env_retention_days 
----        HEADING  "Days|Snapshot Retention"      
----          SELECT  EXTRACT( day FROM  snap_interval) *24*60+ 
----  EXTRACT( hour FROM snap_interval) 
---- *60+  EXTRACT( minute FROM snap_interval ) awr_env_interval_minutes,
----   EXTRACT( day FROM retention) *24*60+  EXTRACT( hour FROM retention)
----   *60+  EXTRACT( minute FROM retention )  awr_env_retention_minutes, 
----   ((  EXTRACT( day FROM retention)  *24*60+  EXTRACT( hour FROM retention)
----   *60+  EXTRACT( minute FROM retention )  )/60/24)  awr_env_retention_days
----   from dba_hist_wr_control;
 
----  PROMPT  PROMPT  ACCEPT _gen_wr_type PROMPT  '====> 
----  Entering the type of AWR Report: [html/text]: ' DEFAULT 'html'
 
----  PROMPT  PROMPT  ACCEPT _gen_wr_days PROMPT  '====> 
----  Entering the number of days of snapshots listed: ' DEFAULT 8

DEFINE _gen_wr_type = 'html';

DEFINE _gen_wr_days = 2;

 
---- COLUMN  gen_wr_startup_time     HEADING STARTUP_TIME    FORMAT   
----  a28   COLUMN gen_wr_begin_time      
----   HEADING BEGIN_TIME    
----   FORMAT    a28   COLUMN gen_wr_end_time          HEADING END_TIME   
----      FORMAT    a28   
---- COLUMN gen_wr_snap_id        
----    HEADING SNAP_ID         FORMAT    999999  COLUMN gen_wr_dbid         
----       HEADING DBID   
----           FORMAT    99999999999  NEW_VALUE _gen_awr_dbid  COLUMN gen_wr_inst_id          
----   HEADING INST_ID         FORMAT    999999     
----    NEW_VALUE _gen_awr_inst_id  COLUMN gen_wr_inst_name 
----          HEADING INSTANCE_NAME   FORMAT    a15         
----   NEW_VALUE _gen_awr_inst_name
----   BREAK ON gen_wr_dbid SKIP 1 ON  
----   gen_wr_inst_id SKIP 1 ON gen_wr_inst_name SKIP 1 ON gen_wr_startup_time SKIP 1
  SELECT  s.dbid                  gen_wr_dbid,  s.instance_number    
    gen_wr_inst_id,   i.instance_name    
       gen_wr_inst_name,  TO_CHAR(s.startup_time, 'DD/MM/YYYY HH24:MI') 
          gen_wr_startup_time,   s.snap_id                                    
           gen_wr_snap_id,   TO_CHAR(s.begin_interval_time, 'DD/MM/YYYY HH24:MI') 
  gen_wr_begin_time,  TO_CHAR(s.end_interval_time, 'DD/MM/YYYY HH24:MI')   
  gen_wr_end_time,  s.error_count
  FROM dba_hist_snapshot s, v$instance  i 
  WHERE end_interval_time >=  sysdate - TO_NUMBER(&_gen_wr_days)
  AND i.instance_number =  s.instance_number  ORDER BY gen_wr_dbid,
  gen_wr_inst_id, gen_wr_snap_id;

---- ACCEPT _gen_wr_begin PROMPT  '====> Entering the BEGIN SNAP ID : '          
---- PROMPT  ACCEPT _gen_wr_end   PROMPT '====> Entering the END SNAP ID :  '

		---	193063 23 Nov 2022 09:00      2
		---	193064 23 Nov 2022 10:00      2
		---	193065 23 Nov 2022 11:00      2

DEFINE _gen_wr_begin = '193063';
DEFINE _gen_wr_end = '193065';


---   SET TERMOUT OFF
---   COLUMN  gen_awr_report_inst_restart NEW_VALUE _gen_count_inst_restart NOPRINT
---   SELECT  CASE WHEN COUNT(DISTINCT TO_CHAR(s.startup_time, 'DD/MM/YYYY  HH24:MI')) > 1  
---   THEN 6 ELSE 0 END gen_awr_report_inst_restart  FROM dba_hist_snapshot s,  v$instance i  
---   WHERE i.instance_number =  s.instance_number  AND snap_id BETWEEN
---   TO_NUMBER(&_gen_wr_begin) AND TO_NUMBER(&_gen_wr_end);
---   HEADING OFF TERMOUT OFF
---   SELECT  CASE WHEN &_gen_count_inst_restart  > 1 THEN    '        
---   ====== PAY ATENTION: There are restart instance between the snapshot id 
---   that you choose ======  ' || chr(10) || chr(10) END 
---   FROM DUAL;
---   EXEC  DBMS_LOCK.SLEEP(&_gen_count_inst_restart);
 
SET TERMOUT OFF
  SPOOL RUN_gen_awr_report.sql
  DECLARE
  l_snap_id             NUMBER  := 0;        l_report_type     
  VARCHAR2(20) := 'AWR_REPORT_TEXT';  l_gen_awr_name  
  VARCHAR2(50) := '';  l_files_generate_awr  VARCHAR2(10000) := '';
  PROCEDURE out(p_name in VARCHAR2) is  BEGIN  DBMS_OUTPUT.PUT_LINE(p_name);     
  END; 
  BEGIN  out('PROMPT Generation AWR SNAPID ...' || 
  &_gen_wr_begin  || ' TO ' || &_gen_wr_end);
  out('SET FEEDBACK OFF HEADING OFF');  out('exec DBMS_LOCK.SLEEP(0.5);');
  l_snap_id := &_gen_wr_begin;
  IF ('&_gen_wr_type' = 'html') THEN   l_report_type := 'AWR_REPORT_HTML' ; 
  END IF;
  WHILE (l_snap_id + 1) <> &_gen_wr_end   LOOP
  out('SET PAGES 0 LINES 32767 FEEDBACK OFF HEADING OFF');
  l_gen_awr_name :=   'gen_awr_' ||  '&_gen_awr_inst_name' || '_' || l_snap_id || '_' ||
  (l_snap_id + 1)  || '_report.' || 
  CASE WHEN  '&_gen_wr_type' = 'text' THEN 'txt' ELSE 'html' END;
  out('SPOOL ' || l_gen_awr_name );  out('SELECT * FROM TABLE 
  (DBMS_WORKLOAD_REPOSITORY.' || 
  l_report_type || '(' || &_gen_awr_dbid || ',' ||   &_gen_awr_inst_id || 
  ',' || l_snap_id || ',' ||
  (l_snap_id + 1) || '));');  out('SPOOL off');
  l_files_generate_awr := l_files_generate_awr || chr(10)  || 'PROMPT AWR begin snap '
  || l_snap_id ||   
  ' to end snap ' ||   (l_snap_id + 1)  || ' generated, file: ' || l_gen_awr_name;
  l_snap_id := l_snap_id + 1;
  END LOOP;
  out('exec DBMS_LOCK.SLEEP(2);');  out('PROMPT');      
  out('PROMPT');  out(l_files_generate_awr);    
  END;  /
  SET TERMOUT ON
  SPOOL OFF
 
--- PROMPT  PROMPT
---   @@RUN_gen_awr_report.sql
---   PROMPT
   UNDEFINE _gen_wr_days _gen_wr_begin _gen_wr_begin _gen_wr_end _gen_count_inst_restart _gen_wr_type  _gen_awr_dbid
---   @@store_set_saved.sql
---   host rm -f  RUN_gen_awr_report.sql  host rm  -f store_set_saved.sql
  
  
