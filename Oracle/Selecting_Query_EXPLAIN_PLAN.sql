Selecting Query EXPLAIN PLAN
from the DBA_HIST_SQL_PLAN View
The EXPLAIN PLAN for the offending SQL is also captured. You may view information about the
execution plan through the DBA_HIST_SQL_PLAN view. If you want to display the EXPLAIN PLAN,
the simplest way is to use the DBMS_XPLAN package with a statement such as this one:

select *
from table(DBMS_XPLAN.DISPLAY_AWR('4dr9vzdck2upw'));

select *
from table(DBMS_XPLAN.DISPLAY_AWR('f6c6qfq28rtkv'));