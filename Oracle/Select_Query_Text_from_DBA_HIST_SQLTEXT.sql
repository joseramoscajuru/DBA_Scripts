Selecting Query Text from the DBA_HIST_SQLTEXT View
The query text for the offending queries shown in the previous two examples can be obtained from
the DBA_HIST_SQLTEXT view with the following query.

To query DBA_HIST_SQLTEXT:

select command_type,sql_text
from dba_hist_sqltext
where sql_text like 
sql_id='4dr9vzdck2upw';

COMMAND_TYPE SQL_TEXT
------------ ----------------------------
3 select count(1) from t2, t2

select command_type,sql_text
from dba_hist_sqltext
where sql_id='f6c6qfq28rtkv';

COMMAND_TYPE SQL_TEXT
------------ ---------------------------
3 select count(*) from emp3