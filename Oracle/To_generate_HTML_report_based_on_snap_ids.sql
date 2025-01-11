

-- To generate HTML report based on snap ids:

set heading off
set trimspool off
set linesize 1500
set termout on
set feedback off
spool awr_from_console.htm
select output from table(dbms_workload_repository.awr_report_html(&dbid, &inst_num, &bid, &eid));
spool off;

set heading off
set trimspool off
set linesize 1500
set termout on
set feedback off
spool awrrpt_1_192700_192701_09112023-00-01.html
select output from table(dbms_workload_repository.awr_report_html(3125024632, 1, 192722, 192723));
spool off;
