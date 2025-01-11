 set termout off
set pages 999
SET MARKUP HTML ON TABLE "class=emp cellspacing=0" ENTMAP OFF

col emp_name format a30 heading "<p class=left>Emp Name</p>"
col salary   format $999,999 heading "<p class=left>Salary</p>"

spool my_html.htm

select
   emp_name,
   salary
from
   emp e;

spool off;

======================================================================

Generating HTML reports from SQL Plus

http://ittichaicham.com/2008/12/generating-html-reports-from-sql-plus/comment-page-1/